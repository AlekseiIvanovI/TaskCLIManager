#!/usr/bin/bash

# Test script for TaskCLI

echo "Running TaskCLI tests..."
echo "-----------------------"

# Test adding tasks
echo "1. Testing task addition:"
taskcli --add "Test task 1"
taskcli --add "Test task 2"
taskcli --list

# Test marking as done
echo -e "\n2. Testing mark as done:"
taskcli --done 1
taskcli --list

# Test removal
echo -e "\n3. Testing removal:"
taskcli --remove 2
taskcli --list

# Test summary
echo -e "\n4. Testing summary:"
taskcli --summary

# Test export
echo -e "\n5. Testing export:"
taskcli --export
ls -l tasks.html

# Test backup
echo -e "\n6. Testing backup:"
taskcli --backup
ls -l tasks_*.json

echo -e "\nTests completed!"