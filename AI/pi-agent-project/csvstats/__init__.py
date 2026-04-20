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
