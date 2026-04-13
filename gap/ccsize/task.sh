#!/bin/bash

TASK=$1

if [ -z "$TASK" ]; then
  echo "Usage: task <unify|fix|validate|optimize>"
  exit 1
fi

TASK_FILE="tasks/$TASK.md"

if [ ! -f "$TASK_FILE" ]; then
  echo "Task not found: $TASK_FILE"
  exit 1
fi

echo "========================"
echo "PROMPT SYSTEM"
echo "========================"

# Load all modular prompts in correct order
cat prompts/00_core_behavior.md
echo ""
cat prompts/01_project_context.md
echo ""
cat prompts/02_execution_strategy.md
echo ""
cat prompts/03_method_selection.md
echo ""
cat prompts/04_input_validation.md
echo ""
cat prompts/05_numerical_stability.md
echo ""
cat prompts/06_r_rules.md
echo ""
cat prompts/07_output_constraints.md
echo ""
cat prompts/08_testing.md
echo ""
cat prompts/09_antipatterns.md

echo ""
echo "========================"
echo "TASK"
echo "========================"

cat "$TASK_FILE"
