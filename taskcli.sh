#!/usr/bin/bash

# ---- TASK CLI -----
# Bash script, is the entry point and driver for all TaskCLI commands

# All operations run in the current directory,
# Data stores and other scripts must be stored in the same directory

# Function that displays help screen & correct usage for tool
help() { cat <<EOF
TaskCLI - terminal to-do manager
Usage: taskcli <command> [args]

Commands:
        --add TASK             Add a new task
        --list                 Show tasks
        --done ID              Mark task done
        --remove ID            Remove task
        --summary              AWK summary report
        --export               Perl -> HTML export
        --help                 This is the help screen
EOF
}

# Confirm a command was entered. show help if not
if [ $# -eq 0 ]; then
        # No arguments were provided
        help
        exit
fi

# Route command to the correct scripting tool/action
# use case statement
cmd=$1               # First argument is the command
shift                # removes the first parameter: $2 -> $3, $3 -> $4, ... 
ARGS="$@"            # Remaining arguments, if any, copied into a string

case "$cmd" in
        --add)
                # call the python file and pass the needed arguments to add a new task
                python3 taskcli.py --add "$ARGS" ;;
        --list)
                # call the python file to list all tasks
                python3 taskcli.py --list ;;
        --done)
                # call the python file and pass the id to mark a task as done
                python3 taskcli.py --done "$ARGS" ;;
        --remove)
                # call the python file and pass the id to remove a taks
                python3 taskcli.py --remove "$ARGS" ;;
        --summary)
                # calls the awk script to generate a summary about the tasks
                awk -f summary.awk tasks.json ;;
        --export)
                # calls a perl script to generate a table of the tasks in the file tasks.html 
                perl export_tasks.pl ;;
        --help|*)
                # any unrecognized input goes here and shows correct usage and commands
                help ;;
esac