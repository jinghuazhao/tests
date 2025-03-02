import streamlit as st

# Set the title of the app
st.title("Text Reversal App")

# Create a text input widget
user_input = st.text_input("Enter some text:")

# If the user has entered text, display the reversed text
if user_input:
    reversed_text = user_input[::-1]
    st.write(f"Reversed Text: {reversed_text}")
