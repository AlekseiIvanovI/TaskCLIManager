#!/usr/bin/bash

# Determine the directory where taskcli is located
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Add alias to .bashrc
echo "alias taskcli='$SCRIPT_DIR/taskcli.sh'" >> ~/.bashrc

# Make all scripts executable
chmod +x $SCRIPT_DIR/taskcli.sh
chmod +x $SCRIPT_DIR/taskcli.py
chmod +x $SCRIPT_DIR/export_tasks.pl
chmod +x $SCRIPT_DIR/summary.awk

echo -e "\033[1;32mTaskCLI installed successfully!\033[0m"
echo "To start using, either:"
echo "1. Run: source ~/.bashrc"
echo "2. Or open a new terminal"
echo "Then try: taskcli --help"