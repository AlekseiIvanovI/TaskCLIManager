#!/usr/bin/python3

# Parsing command-line arguments
import argparse

# Reading and writing task data in JSON format
import json

# Interacting with file system
import os

# SQLite3 database
import sqlite3

# File where tasks will be stored
TASKS_FILE = "tasks.json"

# DB where task will be stored
DB_FILE = "tasks.db"

# Ensure DB table exists
def ensure_db():
    connection = sqlite3.connect(DB_FILE)
    cursor = connection.cursor()
    cursor.execute("""CREATE TABLE IF NOT EXISTS tasks (
                    id INTEGER PRIMARY KEY,
                    name TEXT NOT NULL,
                    done INTEGER NOT NULL);""")
    connection.commit()
    return connection, cursor

# Function to load tasks from the JSON file
def load_tasks():
    # If the tasks file doesn't exist, return an empty list
    if not os.path.exists(TASKS_FILE):
        return []

    # Open the file in read mode
    with open(TASKS_FILE, "r") as file:
        try:
            # Try to load and return the JSON data (a list of tasks)
            return json.load(file)
        except json.JSONDecodeError:
            # If the file is empty or has invalid JSON, return an empty list
            return []

# Function to save the list of tasks to the JSON file
def save_tasks(tasks):
    # Open the tasks file in write mode
    with open(TASKS_FILE, "w") as f:
        # Write the list of tasks to the file in JSON format, with indent for readability
        json.dump(tasks, f, indent=2)

# Function to add a new task
def add_task(task_name, connection, cursor):
    # Load existing tasks from the file
    tasks = load_tasks()
    
    # Find the maximum ID in the existing tasks
    max_id = 0
    for task in tasks:
        if task["id"] > max_id:
            max_id = task["id"]
    
    # Also check max ID in database
    cursor.execute("SELECT MAX(id) FROM tasks")
    result = cursor.fetchone()
    db_max_id = result[0] if result[0] is not None else 0
    
    # Use the highest max_id from either source
    max_id = max(max_id, db_max_id)
    
    # Generate a new task ID
    task_id = max_id + 1

    # Create a new task and add it to the list
    tasks.append({"id": task_id, "name": task_name, "done": False})

    # Save the updated task list back to the file
    save_tasks(tasks)

    # Update the database
    cursor.execute("INSERT INTO tasks (id, name, done) VALUES (?, ?, ?)", (task_id, task_name, 0))
    connection.commit()

    # Print confirmation message
    print(f"Added task: {task_name}")

# Function to display all tasks
def list_tasks():
    # Load tasks from the file
    tasks = load_tasks()

    # If there are no tasks, print a message and exit
    if not tasks:
        print("No tasks found.")
        return

    # Loop through each task and print its ID, status, and name
    for task in tasks:
        status = "✓" if task["done"] else "✗"  # checkmark if done, X if not
        print(f"[{task['id']}] {status} {task['name']}")

# Function to mark a task as done
def mark_done(task_id, connection, cursor):
    # Load tasks from the file
    tasks = load_tasks()
    
    # Convert task_id to integer
    task_id = int(task_id)
    
    # Find the task with the given ID
    found = False
    for task in tasks:
        if task["id"] == task_id:
            task["done"] = True
            found = True
            break
    
    if not found:
        print(f"Task with ID {task_id} not found.")
        return
    
    # Save the updated tasks back to the file
    save_tasks(tasks)
    
    # Update the database
    cursor.execute("UPDATE tasks SET done = 1 WHERE id = ?", (task_id,))
    connection.commit()
    
    print(f"Task {task_id} marked as done.")

# Function to remove a task
def remove_task(task_id, connection, cursor):
    # Load tasks from the file
    tasks = load_tasks()
    
    # Convert task_id to integer
    task_id = int(task_id)
    
    # Find the task with the given ID
    found = False
    for i, task in enumerate(tasks):
        if task["id"] == task_id:
            # Remove the task from the list
            tasks.pop(i)
            found = True
            break
    
    if not found:
        print(f"Task with ID {task_id} not found.")
        return
    
    # Save the updated tasks back to the file
    save_tasks(tasks)
    
    # Delete from the database
    cursor.execute("DELETE FROM tasks WHERE id = ?", (task_id,))
    connection.commit()
    
    print(f"Task {task_id} removed!")

def backup_tasks():
    """Create a backup of the tasks file"""
    import shutil
    from datetime import datetime

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = f"tasks_{timestamp}.json"
    shutil.copy2(TASKS_FILE, backup_file)
    print(f"Created backup: {backup_file}")

def main():
    # Create a command-line argument parser with a description
    parser = argparse.ArgumentParser(description="TaskCLI - Command-line To-Do List")

    # Define the arguments
    parser.add_argument("--add", metavar="TASK", help="Add a new task")
    parser.add_argument("--list", action="store_true", help="List all tasks")
    parser.add_argument("--done", metavar="ID", help="Mark a task as done")
    parser.add_argument("--remove", metavar="ID", help="Remove a task")
    parser.add_argument("--backup", action="store_true", help="Create backup of tasks") # New backup argument

    # Parse the command-line arguments
    args = parser.parse_args()

    # Ensure db and json exist
    connection, cursor = ensure_db()

    try:
        # Process the command-line arguments
        if args.add:
            add_task(args.add, connection, cursor)
        elif args.list:
            list_tasks()
        elif args.done:
            mark_done(args.done, connection, cursor)
        elif args.remove:
            remove_task(args.remove, connection, cursor)
        elif args.backup:
            backup_tasks()
        else:
            parser.print_help()
    finally:
        # Close the database connection
        connection.close()

# Run the main function if script is executed directly
if __name__ == "__main__":
    main()
