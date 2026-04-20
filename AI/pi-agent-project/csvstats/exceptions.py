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
