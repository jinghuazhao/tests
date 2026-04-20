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
            # Try to detect if file is empty
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
            
            for row_num, row in enumerate(reader, start=2):  # start=2 (1-based, plus header)
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
        error_list = "; ".join(errors[:5])  # Show first 5 errors
        if len(errors) > 5:
            error_list += f"; ... and {len(errors) - 5} more errors"
        raise ValidationError(f"Data validation failed: {error_list}")
    
    if not values:
        raise ValidationError("No valid data rows found")
    
    return values
