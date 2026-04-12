TASK:
Fix numerical instability in ccsize().

RULES:
- Use log-scale where appropriate
- Prevent division by small numbers
- Ensure outputs match published tables within 1%

OUTPUT:
Final R code only
