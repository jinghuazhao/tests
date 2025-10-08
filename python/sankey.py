import plotly.graph_objects as go

# Sample node labels
label = [
    "Start", "Math", "Physics", "Engineering",
    "Academia", "Industry", "Research", "Teaching"
]

# Define flow: from source to target
source = [0, 0, 1, 1, 2, 2, 3, 3]  # From nodes
target = [1, 2, 4, 5, 5, 6, 6, 7]  # To nodes
value  = [5, 3, 2, 1, 2, 1, 2, 1]  # Flow magnitudes

# Create the Sankey diagram
fig = go.Figure(data=[go.Sankey(
    node=dict(
        pad=15,
        thickness=20,
        line=dict(color="black", width=0.5),
        label=label,
        color="lightblue"
    ),
    link=dict(
        source=source,
        target=target,
        value=value,
        color="rgba(50, 150, 200, 0.4)"
    )
)])

fig.update_layout(title_text="Sample Sankey Diagram: Career Paths", font_size=12)
fig.show()
