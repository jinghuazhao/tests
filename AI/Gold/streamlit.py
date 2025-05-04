import streamlit as st

st.title("Text Reversal App")
user_input = st.text_input("Enter some text:")
if user_input:
    reversed_text = user_input[::-1]
    st.write(f"Reversed Text: {reversed_text}")
