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
        # argparse calls sys.exit(2) on error
        return e.code if isinstance(e.code, int) else 2
    
    filepath = Path(parsed.file)
    column_name = parsed.column
    
    try:
        # Read data
        values = read_csv_column(filepath, column_name)
        
        # Calculate statistics
        stats = calculate_statistics(values)
        
        # Output results
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
