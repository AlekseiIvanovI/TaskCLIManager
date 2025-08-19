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
        --export [sort]        Perl -> HTML export (sort: id|status|name)
        --help                 This is the help screen
EOF
}

# Validate numeric ID input
validate_id() {
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "Error: Task ID must be a number" >&2
        exit 1
    fi
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
                if [ -z "$ARGS" ]; then
                    echo "Error: Task description cannot be empty" >&2
                    exit 1
                fi
                python3 taskcli.py --add "$ARGS" ;;
        --list)
                python3 taskcli.py --list ;;
        --done)
                validate_id "$ARGS"
                python3 taskcli.py --done "$ARGS" ;;
        --remove)
                validate_id "$ARGS"
                python3 taskcli.py --remove "$ARGS" ;;
        --summary)
                awk -f summary.awk tasks.json ;;
        --export)
                # Default sort is by ID if no parameter given
                sort_param="${ARGS:-id}"  # Use "id" if ARGS is empty
                perl export_tasks.pl "$sort_param" ;;
        --help|*)
                help ;;
esac
