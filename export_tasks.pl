#!/usr/bin/perl

use strict;
use warnings;

my $JSON_FILE = 'tasks.json';
my $HTML_FILE = 'tasks.html';

# Read the JSON file
open my $jf, '<', $JSON_FILE
  or die "Cannot open $JSON_FILE: $!";

my $json_text = do { local $/; <$jf> };
close $jf;

# Simple JSON parsing for our specific format
my @tasks;
while ($json_text =~ /"id"\s*:\s*(\d+).*?"name"\s*:\s*"([^"]*)".*?"done"\s*:\s*(true|false)/sg) {
    push @tasks, { id => $1, desc => $2, done => $3 };
}

# Build simple HTML
open my $hf, '>', $HTML_FILE
  or die "Cannot open $HTML_FILE for writing: $!";

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
        tr:hover { background-color: #f5f5f5; }
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

foreach my $t (@tasks) {
    my $status = ($t->{done} eq 'true') ? '✓' : '✗';
    my $status_class = ($t->{done} eq 'true') ? 'status-done' : 'status-pending';
    
    print $hf "<tr>\n";
    print $hf "    <td>$t->{id}</td>\n";
    print $hf "    <td class=\"$status_class\">$status</td>\n";
    print $hf "    <td>$t->{desc}</td>\n";
    print $hf "</tr>\n";
}

print $hf <<HTML_TAIL;
    </table>
</body>
</html>
HTML_TAIL

close $hf;

print "Tasks exported to $HTML_FILE successfully!\n";
