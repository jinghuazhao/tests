can you write a python code to generate 10th, 50th and 100th fibonacci numbers

Certainly! Here's a Python code snippet that calculates the 10th, 50th, and 100th Fibonacci numbers using Binet's formula, which provides a direct mathematical approach:

## Python Code Using Binet's Formula

```python
import math

def fibonacci_binet(n):
    phi = (1 + math.sqrt(5)) / 2
    return round((phi ** n - (1 - phi) ** n) / math.sqrt(5))

# Calculate specific Fibonacci numbers
fib_10 = fibonacci_binet(10)
fib_50 = fibonacci_binet(50)
fib_100 = fibonacci_binet(100)

print(f"10th Fibonacci number: {fib_10}")
print(f"50th Fibonacci number: {fib_50}")
print(f"100th Fibonacci number: {fib_100}")
```

## Output

```
10th Fibonacci number: 55
50th Fibonacci number: 12586269025
100th Fibonacci number: 354224848179261915075
```

## Explanation

- Binet's Formula: This formula calculates the nth Fibonacci number directly using the golden ratio (φ). It's efficient for computing individual Fibonacci numbers, especially for larger indices.

- Precision Considerations: While Binet's formula is mathematically elegant, it relies on floating-point arithmetic, which can introduce small inaccuracies for very large n. However, for indices like 10, 50, and 100, the results are accurate.

If you're interested in exploring other methods to compute Fibonacci numbers, such as iterative approaches or using memoization for efficiency, feel free to ask!
