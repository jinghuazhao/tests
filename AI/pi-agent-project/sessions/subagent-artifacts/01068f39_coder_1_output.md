All tests pass. Here's the complete implementation:

---

## **File Tree**

```
pi-agent-project/
├── pyproject.toml              # Package metadata, CLI entry point
├── data.csv                    # Input data (exists)
└── csvstats/                   # Main package
    ├── __init__.py             # Package init (exports version, public API)
    ├── __main__.py             # Entry point for `python -m csvstats`
    ├── cli.py                  # Argument parsing & main entry
    ├── reader.py               # Safe CSV parsing with validation
    ├── stats.py                # Mean/median calculations
    └── exceptions.py           # Custom exception classes
```

---

## **Full Source Code**

### `pyproject.toml`
```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "csvstats"
version = "0.1.0"
description = "A CLI tool for calculating CSV column statistics"
requires-python = ">=3.8"

[project.scripts]
csvstats = "csvstats.cli:main"
```

### `csvstats/__init__.py`
```python
"""CSV Statistics CLI Package."""

__version__ = "0.1.0"

from .exceptions import CSVError, StatsError
from .reader import read_csv_column
from .stats import calculate_statistics

__all__ = [
    "__version__",
    "CSVError",
    "StatsError",
    "read_csv_column",
    "calculate_statistics",
]
```

### `csvstats/exceptions.py`
```python
"""Custom exceptions for csvstats package."""


class CSVStatsError(Exception):
    """Base exception for csvstats package."""
    pass


class CSVError(CSVStatsError):
    """Raised for CSV parsing or IO errors."""
    pass


class StatsError(CSVStatsError):
    """Raised for statistics calculation errors."""
    pass


class ValidationError(CSVStatsError):
    """Raised for data validation errors."""
    pass
```

### `csvstats/reader.py`
```python
"""CSV reading module with validation."""

import csv
from pathlib import Path
from typing import List

from .exceptions import CSVError, ValidationError


def read_csv_column(filepath: Path, column_name: str = "value") -> List[float]:
    """
    Read a numeric column from a CSV file.
    
    Args:
        filepath: Path to the CSV file.
        column_name: Name of the column to extract (default: "value").
    
    Returns:
        List of float values from the column.
    
    Raises:
        CSVError: For IO errors, parsing errors, or missing column.
        ValidationError: For non-numeric data.
    """
    if not filepath.exists():
        raise CSVError(f"File not found: {filepath}")
    
    if not filepath.is_file():
        raise CSVError(f"Not a file: {filepath}")
    
    values = []
    errors = []
    
    try:
        with open(filepath, "r", encoding="utf-8", newline="") as f:
            try:
                sample = f.read(1)
                if not sample:
                    raise CSVError("File is empty")
                f.seek(0)
            except OSError as e:
                raise CSVError(f"Cannot read file: {e}") from e
            
            reader = csv.DictReader(f)
            
            if reader.fieldnames is None:
                raise CSVError("No header row found")
            
            if column_name not in reader.fieldnames:
                available = ", ".join(f"'{n}'" for n in reader.fieldnames)
                raise CSVError(
                    f"Column '{column_name}' not found. "
                    f"Available columns: {available}"
                )
            
            for row_num, row in enumerate(reader, start=2):
                raw_value = row.get(column_name, "").strip()
                
                if not raw_value:
                    errors.append(f"Row {row_num}: empty value")
                    continue
                
                try:
                    value = float(raw_value)
                    values.append(value)
                except ValueError:
                    errors.append(
                        f"Row {row_num}: cannot convert '{raw_value}' to number"
                    )
    
    except PermissionError as e:
        raise CSVError(f"Permission denied: {filepath}") from e
    except csv.Error as e:
        raise CSVError(f"CSV parsing error: {e}") from e
    except UnicodeDecodeError as e:
        raise CSVError(f"File encoding error (expected UTF-8): {e}") from e
    except OSError as e:
        raise CSVError(f"IO error reading file: {e}") from e
    
    if errors:
        error_list = "; ".join(errors[:5])
        if len(errors) > 5:
            error_list += f"; ... and {len(errors) - 5} more errors"
        raise ValidationError(f"Data validation failed: {error_list}")
    
    if not values:
        raise ValidationError("No valid data rows found")
    
    return values
```

### `csvstats/stats.py`
```python
"""Statistics calculation module."""

import statistics
from typing import Dict, List

from .exceptions import StatsError


def calculate_statistics(values: List[float]) -> Dict[str, float]:
    """
    Calculate mean and median of a list of numbers.
    
    Args:
        values: List of numeric values.
    
    Returns:
        Dictionary with 'mean' and 'median' keys.
    
    Raises:
        StatsError: If values list is empty or calculation fails.
    """
    if not values:
        raise StatsError("Cannot calculate statistics: no values provided")
    
    try:
        mean_val = statistics.mean(values)
        median_val = statistics.median(values)
    except statistics.StatisticsError as e:
        raise StatsError(f"Statistics calculation failed: {e}") from e
    except (TypeError, ValueError) as e:
        raise StatsError(f"Invalid data for statistics: {e}") from e
    
    return {
        "mean": mean_val,
        "median": median_val,
        "count": len(values),
    }
```

### `csvstats/cli.py`
```python
"""CLI interface for csvstats."""

import argparse
import sys
from pathlib import Path
from typing import Optional, Sequence

from . import __version__
from .exceptions import CSVStatsError
from .reader import read_csv_column
from .stats import calculate_statistics


def create_parser() -> argparse.ArgumentParser:
    """Create the argument parser."""
    parser = argparse.ArgumentParser(
        prog="csvstats",
        description="Calculate statistics (mean, median) from a CSV file.",
        epilog="Exit codes: 0=success, 1=runtime error, 2=CLI error",
    )
    
    parser.add_argument(
        "file",
        type=str,
        help="Path to CSV file (default: looks for 'value' column)",
    )
    
    parser.add_argument(
        "-c", "--column",
        type=str,
        default="value",
        metavar="NAME",
        help="Column name to analyze (default: 'value')",
    )
    
    parser.add_argument(
        "--version",
        action="version",
        version=f"%(prog)s {__version__}",
    )
    
    return parser


def format_number(n: float) -> str:
    """Format number for display, removing trailing zeros."""
    if n == int(n):
        return str(int(n))
    return f"{n:.6f}".rstrip("0").rstrip(".")


def main(args: Optional[Sequence[str]] = None) -> int:
    """
    Main entry point.
    
    Returns:
        Exit code (0=success, 1=runtime error, 2=CLI error).
    """
    parser = create_parser()
    
    try:
        parsed = parser.parse_args(args)
    except SystemExit as e:
        return e.code if isinstance(e.code, int) else 2
    
    filepath = Path(parsed.file)
    column_name = parsed.column
    
    try:
        values = read_csv_column(filepath, column_name)
        stats = calculate_statistics(values)
        
        print(f"Column: {column_name}")
        print(f"Count:  {stats['count']}")
        print(f"Mean:   {format_number(stats['mean'])}")
        print(f"Median: {format_number(stats['median'])}")
        
        return 0
    
    except CSVStatsError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1
    except KeyboardInterrupt:
        print("\nInterrupted.", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
```

### `csvstats/__main__.py`
```python
"""Entry point for python -m csvstats."""

import sys

from .cli import main

if __name__ == "__main__":
    sys.exit(main())
```

---

## **Validation Results**

```
$ python3 -m csvstats data.csv
Column: value
Count:  5
Mean:   30
Median: 30

$ python3 -m csvstats --version
csvstats 0.1.0

$ python3 -m csvstats data.csv --column foo 2>&1
Error: Column 'foo' not found. Available columns: 'value'
Exit code: 1

$ python3 -m csvstats nonexistent.csv 2>&1
Error: File not found: nonexistent.csv
Exit code: 1
```

**Features implemented:**
- Pure stdlib (no external dependencies)
- RFC 4180 compliant CSV parsing via `csv.DictReader`
- Column access by name (resilient to reordering)
- Comprehensive error handling with line numbers
- Exit codes: 0=success, 1=runtime error, 2=CLI error
- Both `python -m csvstats` and console script entry points