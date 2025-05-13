#!/usr/bin/bash

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

# Working with files in the current directory instead of "$HOME/taskcli"
# This ensures that scripts and data files are located in the same place

# Confirm a command was entered. show help if not
if [ $# -eq 0 ]; then
        help
        exit
fi

# Route command to the correct scripting tool/action
# use case statement
cmd=$1
shift
ARGS="$@"

case "$cmd" in
        --add)
                python3 taskcli.py --add "$ARGS" ;;
        --list)
                python3 taskcli.py --list ;;
        --done)
                python3 taskcli.py --done "$ARGS" ;;
        --remove)
                python3 taskcli.py --remove "$ARGS" ;;
        --summary)
                awk -f summary.awk tasks.json ;;
        --export)
                perl export_tasks.pl ;;
        --help|*)
                help ;;
esac
