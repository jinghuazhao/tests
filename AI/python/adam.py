import tensorflow as tf

# Generate some random training data
x_train = tf.random.normal(shape=[100, 1])
y_train = 3 * x_train + tf.random.normal(shape=[100, 1], stddev=0.1)

# Define the model architecture
model = tf.keras.models.Sequential([
    tf.keras.layers.Dense(units=1, input_shape=[1])
])

# Define the optimizer and compile the model
optimizer = tf.keras.optimizers.Adam(learning_rate=0.01)
model.compile(optimizer=optimizer, loss='mse')

# Train the model for 100 epochs
history = model.fit(x_train, y_train, epochs=100, verbose=0)

# Plot the training loss over time
import matplotlib.pyplot as plt
plt.plot(history.history['loss'])
plt.title('Training loss over time')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.show()
