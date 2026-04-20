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
