import matplotlib.pyplot as plt
import numpy as np
from fractions import Fraction

# Continued fraction for pi: [3; 7, 15, 1, 292, 1, 1, 1, 2, 1]
cf_pi = [3, 7, 15, 1, 292, 1, 1, 1, 2, 1]

# Function to compute convergents from continued fraction
def compute_convergents(cf):
    convergents = []
    for i in range(1, len(cf) + 1):
        frac = Fraction(cf[i - 1])
        for a in reversed(cf[:i - 1]):
            frac = a + Fraction(1, frac)
        convergents.append(frac)
    return convergents

# Compute convergents and errors
convergents = compute_convergents(cf_pi)
pi_val = np.pi
errors = [abs(float(c) - pi_val) for c in convergents]
convergent_nums = list(range(1, len(convergents) + 1))

# Plotting error (log scale)
plt.figure(figsize=(8, 5))
plt.plot(convergent_nums, errors, marker='o', color='dodgerblue', label='|Convergent - π|')
plt.yscale('log')
plt.title("Convergent Accuracy of π's Continued Fraction")
plt.xlabel("Convergent Number")
plt.ylabel("Absolute Error (log scale)")
plt.grid(True, which="both", ls="--", alpha=0.6)
plt.xticks(convergent_nums)
plt.legend()
plt.tight_layout()
plt.show()
