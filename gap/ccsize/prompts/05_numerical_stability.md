- Prefer log-scale computations
- Avoid subtracting nearly equal numbers
- Avoid division by small values
- Guard all denominators
- Ensure log arguments > 0

Check:
- is.nan
- is.infinite
- negative variance

On failure:
- warning("numerical issue")
- return NA_real_
