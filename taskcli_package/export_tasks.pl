#!/usr/bin/perl

# A Perl file for a simple export of tasks.json to tasks.html with a basic table format

use strict;
use warnings;

# Define file names
my $JSON_FILE = 'tasks.json';
my $HTML_FILE = 'tasks.html';

# ----- Read the JSON file into a string ------
# Open the .json file for reading, close if it can't be opened
open my $jf, '<', $JSON_FILE
  or die "Cannot open $JSON_FILE: $!";

# Copy the entire .json file into json_text
my $json_text = do { local $/; <$jf> }; # "$/" overwrites '\n' seperator so entire file is read
close $jf;    # Close file, no longer need it

# Simple .json parsing for our specific format
my @tasks; # array to hold list of parsed tasks

# Find every occurrence of: "id": 12, "name": "John", "done": true|false
# "/s" -> searches past \n through entire string
# "/g" -> remembers where in the string last match was found, starts search there not at beginning
# "/x" -> allows  regex to be on multiple lines for readability
# .*? <- '?' stops as soon as the next field is matched
while ($json_text =~ /"id"\s*:\s*(\d+) 
                      .*?"name"\s*:\s*"([^"]*)"
                      .*?"done"\s*:\s*(true|false)
                      /sgx) {
    # found match, push 1st field to task.id, ...
    push @tasks, { id => $1, desc => $2, done => $3 };
} # Done reading the file into a string

# ----- Build simple HTML -------
# Open the .html file for writing, close if it can't be opened
open my $hf, '>', $HTML_FILE
  or die "Cannot open $HTML_FILE for writing: $!";

# Print the opening tags, header, and begin the table
# Style - body           -> body text font and margin
# Style - h1             -> main header color + bottom border/line 
# Style - table          -> table has full display width, borders, and seperating spacing above 
# Style - th, td         -> all data and header cells have padding, are left-alligned, and have a bottom border
# Style - th             -> give table header light gray background color
# Style - status-done    -> class for done tasks; green and bold txt
# Style - status-pending -> class for pending tasks; red and bold txt
print $hf <<HTML_HEAD;
<!DOCTYPE html>  
<html>
<head>
    <meta charset="utf-8">
    <title>TaskCLI - Task List</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #333; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f2f2f2; }
        .status-done { color: green; font-weight: bold; }
        .status-pending { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <h1>TaskCLI - Task List</h1>
    <p>Total tasks: @{[scalar @tasks]}</p>
    <table>
        <tr>
            <th>ID</th>
            <th>Status</th>
            <th>Task</th>
        </tr>
HTML_HEAD

# Iterate through each parsed task and create one table row for each task
foreach my $t (@tasks) {
    # Determine if current task is done or not, assign special char. Check if true, X if false
    my $status = ($t->{done} eq 'true') ? '✓' : '✗';
    # Determine if task class is done or pending. Done if true, pending if false
    my $status_class = ($t->{done} eq 'true') ? 'status-done' : 'status-pending';

    # Print to the .html table row
    print $hf "<tr>\n";                                           # new table row
    print $hf "    <td>$t->{id}</td>\n";                          # First field is the current task id
    print $hf "    <td class=\"$status_class\">$status</td>\n";   # Second field is the status as a symbol
    print $hf "    <td>$t->{desc}</td>\n";                        # Third field is the description of the task
    print $hf "</tr>\n";                                          # closing tag for the table row
} # Done writing all tasks to tasks.html, each task is a table row

# Print the closing tags
print $hf <<HTML_TAIL;
    </table>
</body>
</html>
HTML_TAIL

# Close the file 
close $hf;

# Display the action was successful to the user, and provide a link to tasks.html
print "Tasks exported to $HTML_FILE successfully!\n";