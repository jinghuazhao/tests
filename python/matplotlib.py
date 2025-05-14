import matplotlib.pyplot as plt
x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
y = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]  # Example y-values (prime numbers)
plt.plot(x, y, marker='o', linestyle='-', color='b', label='Prime Numbers')
plt.title('Plot of Prime Numbers')
plt.xlabel('Index')
plt.ylabel('Prime Number')
plt.grid(True)
plt.legend()
plt.savefig('prime_numbers_plot.png', dpi=300, bbox_inches='tight')
plt.show()
