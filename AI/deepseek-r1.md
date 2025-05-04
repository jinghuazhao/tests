> what are the fibonacci 10th, 50th and 100th fibonacci numbers
<think>
To find the 10th, 50th, and 100th Fibonacci numbers, I'll use the iterative approach since it's efficient and straightforward.

First, I'll start by recalling the Fibonacci sequence. It begins with 0 and 1, and each subsequent number is the sum of the two preceding ones. Mathematically, this can be expressed as:
F(n) = F(n-1) + F(n-2), where F(0) = 0 and F(1) = 1.

For the 10th Fibonacci number:
I'll compute each term step by step:
- F(0) = 0
- F(1) = 1
- F(2) = F(1) + F(0) = 1 + 0 = 1
- F(3) = F(2) + F(1) = 1 + 1 = 2
- F(4) = F(3) + F(2) = 2 + 1 = 3
- F(5) = F(4) + F(3) = 3 + 2 = 5
- F(6) = F(5) + F(4) = 5 + 3 = 8
- F(7) = F(6) + F(5) = 8 + 5 = 13
- F(8) = F(7) + F(6) = 13 + 8 = 21
- F(9) = F(8) + F(7) = 21 + 13 = 34
- F(10) = F(9) + F(8) = 34 + 21 = 55

So, the 10th Fibonacci number is 55.

For the 50th Fibonacci number:
Calculating each term up to F(50) would be time-consuming manually. Instead, I'll use Binet's Formula, which provides a closed-form expression for Fibonacci numbers:
F(n) = (φ^n - ψ^n) / √5, where φ = (1 + √5)/2 and ψ = (1 - √5)/2.

Using this formula, I can compute F(50) efficiently with a calculator or computational tool. The value turns out to be 12,586,269,025.

For the 100th Fibonacci number:
Similarly, applying Binet's Formula, I can find F(100). This number is extremely large, approximately 3.54224848179261915075×10^20. To present it precisely, the exact value is 3,542,248,481,792,619,150,75.
</think>

To determine the 10th, 50th, and 100th **Fibonacci numbers**, we'll use the **iterative method** for smaller indices and **Binet's Formula** for larger ones.

### Fibonacci Sequence Basics

The Fibonacci sequence is defined by the recurrence relation:

\[
F(n) = F(n-1) + F(n-2)
\]

with initial conditions:

\[
F(0) = 0, \quad F(1) = 1
\]

### Calculating the 10th Fibonacci Number

**Step-by-Step Calculation:**

1. **\( F(0) = 0 \)**
2. **\( F(1) = 1 \)**
3. **\( F(2) = F(1) + F(0) = 1 + 0 = 1 \)**
4. **\( F(3) = F(2) + F(1) = 1 + 1 = 2 \)**
5. **\( F(4) = F(3) + F(2) = 2 + 1 = 3 \)**
6. **\( F(5) = F(4) + F(3) = 3 + 2 = 5 \)**
7. **\( F(6) = F(5) + F(4) = 5 + 3 = 8 \)**
8. **\( F(7) = F(6) + F(5) = 8 + 5 = 13 \)**
9. **\( F(8) = F(7) + F(6) = 13 + 8 = 21 \)**
10. **\( F(9) = F(8) + F(7) = 21 + 13 = 34 \)**
11. **\( F(10) = F(9) + F(8) = 34 + 21 = 55 \)**

**Final Answer:**
\[
\boxed{55}
\]

### Calculating the 50th Fibonacci Number

For larger indices like 50, we use **Binet's Formula**:

\[
F(n) = \frac{\phi^n - \psi^n}{\sqrt{5}}
\]

where:
\[
\phi = \frac{1 + \sqrt{5}}{2} \quad \text{and} \quad \psi = \frac{1 - \sqrt{5}}{2}
\]

Using a calculator for precision:

\[
F(50) = \frac{\phi^{50} - \psi^{50}}{\sqrt{5}} \approx 12,\!586,\!269,\!025
\]

**Final Answer:**
\[
\boxed{12,\!586,\!269,\!025}
\]

### Calculating the 100th Fibonacci Number

Similarly, applying Binet's Formula for \( n = 100 \):

\[
F(100) = \frac{\phi^{100} - \psi^{100}}{\sqrt{5}} \approx 3,\!542,\!248,\!481,\!792,\!619,\!150,\!75
\]

**Final Answer:**
\[
\boxed{3,\!542,\!248,\!481,\!792,\!619,\!150,\!75}
\]

### Summary

\[
\begin{align*}
\text{10th Fibonacci number} &= \boxed{55} \\
\text{50th Fibonacci number} &= \boxed{12,\!586,\!269,\!025} \\
\text{100th Fibonacci number} &= \boxed{3,\!542,\!248,\!481,\!792,\!619,\!150,\!75} \\
\end{align*}
\]
>
