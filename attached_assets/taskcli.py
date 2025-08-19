#!/usr/bin/python3

# when --add, --list, --remove, --done options are chosen in Bash script it issues the command to run taskcli.py
# Bash passes the command line as "python3 taskcli.py <cmd> <args>"

#--add is working w/ JSON file, DB is created but not adding tasks correctly.
#--list is not being recognized by the Python script, maybe argparse error?
#        ./taskcli.sh --list


# Parsing command-line arguments
import argparse

# Readng and writing task data in JSON format
import json

# Interacting with file system
import os

#ADDED - SQLite3 database
import sqlite3

# File where tasks will be stored
TASKS_FILE = "tasks.json"

#ADDED - DB where task will be stored
DB_FILE = "tasks.db"
connection = sqlite3.connect(DB_FILE)
cVar = connection.cursor()

#ADDED - ensure DB table exists
def ensure_db():
        cVar.execute("""CREATE TABLE IF NOT EXISTS tasks (
                                        id INTEGER PRIMARY KEY,
                                        name TEXT NOT NULL,
                                        done INTEGER NOT NULL);""")
        connection.commit()

# Function to load tasks from the JSON file
def load_tasks():
        #If the tasks file doesn't exist, return an empty list
        if not os.path.exists(TASKS_FILE):
                return[]

        # Open the file in read mode
        with open (TASKS_FILE, "r") as file:
                try:
        # Try to load and return the JSON data (a list of tasks)
                        return json.load(file)
                except json.JSONDecodeError:
                        # If the file is empty or has invalid JSON, return an empty list
                        return[]



# Function to save the list of tasks from the JSON file
def save_tasks(tasks):
        # Open the tasks file in write mode
        with open(TASKS_FILE, "w") as f:
                # Write the list of tasks to the file in JSON format, with indent for readability
                json.dump(tasks, f, indent=2)


# Function to add a new task
def add_task(task_name):

        # Load existing taks from the file
        tasks = load_tasks()

        # Generate a new task ID (one more than the current number of tasks)
        task_id = len(tasks) + 1

        # Create a new task and add it to the list
        tasks.append({"id": task_id, "name": task_name, "done": False})

        # Save the updated task list back to the file
        save_tasks(tasks)

        #ADDED - update the database
        cVar.execute("INSERT INTO tasks (id, name, done) VALUES (?, ?, ?)", (task_id, task_name, 0))
        connection.commit()

        # Print confirmation message
        print(f"Added task: {task_name}")


# Function to display all tasks
def list_tasks():

        # Load tasks from the file
        tasks = load_tasks()

        # If there are no tasks, print a message and exit
        if not tasks:
                print ("No tasks found.")
                return

        # Loop through each task and print its ID, status, and name
        for task in tasks:
                status = "✓" if task["done"] else "✗" # checkmate if done, X if not
                print(f"[{task['id']}] {status} {task['name']}")

#FIXME - Function to mark a task as done
def mark_done(task_id):
        # update JSON file, and maybe a check that task id exists before updating either db or json
        cVar.execute("UPDATE tasks SET done = 1 WHERE id = ?", (task_id,))
        connection.commit()
        print ("Task marked as done.")



#FIXME -  Function to remove a task
def remove_task(task_id):
        # update JSON file, and maybe a check that task id exists before updating either db or json
        cVar.execute("DELETE FROM tasks WHERE id = ?", (task_id,))
        connection.commit()
        print ("Task removed!")


def main():
        # Create a command-line argument parser with a description
        parser = argparse.ArgumentParser(description="TaskCLI - Command-line To-Do List")

        # Define the --add argument for adding a new task
        parser.add_argument("--add", metavar="TASK", help="Add a new task")

        # Define the --list argument for listing all tasks
        parser.add_argument("--list", action="store_true", help="List all tasks")

        #FIXME - Define the --done argument for marking a task as done
        #FIXME - Define the --remove argument for removing a task

        # Parse the command-line arguments
        args = parser.parse_args()

        #ADDED - ensure db and json exist
        ensure_db()

        # If the user provided -add, call the function to add a task
        if args.add:
                add_task(args.add)

        # If the user provided --list, call the function to list tasks
        elif args.list:
                list_tasks()

        #If no valid arguments were provided, show the help message
        else:
                parser.print_help()

# Run the main fnc if script is executed directly
if __name__ == "__main__":
        main()

