#!/usr/bin/perl
#
# export_tasks.pl – very simple HTML exporter for TaskCLI
# -------------------------------------------------------
# Reads tasks.json (an array of objects like
#   { "id": 1, "description": "Buy milk", "done": 0 }
# )
# and writes tasks.html with a basic table.

use strict;
use warnings;

my $JSON_FILE = 'tasks.json';
my $HTML_FILE = 'tasks.html';

# -------------------------------------------------------
# 1. Slurp the JSON file (it’s tiny, so no streaming needed)
# -------------------------------------------------------
open my $jf, '<', $JSON_FILE
  or die "Cannot open $JSON_FILE: $!";

my $json_text = do { local $/; <$jf> };
close $jf;

# -------------------------------------------------------
# 2. Extremely small‑scale “parse”
#    – we just want id / description / done.
#    – Good enough for the predictable format TaskCLI writes.
# -------------------------------------------------------
my @tasks;
while ( $json_text =~ /
        \{                # opening brace
        .*?"id"\s*:\s*(\d+)          # id
        .*?"description"\s*:\s*"(.*?)"  # description
        .*?"done"\s*:\s*(\d+)        # done flag
        .*?\}              # closing brace
      /gsx )
{
    push @tasks, { id => $1, desc => $2, done => $3 };
}

# -------------------------------------------------------
# 3. Build very simple HTML
# -------------------------------------------------------
open my $hf, '>', $HTML_FILE
  or die "Cannot open $HTML_FILE for writing: $!";

print $hf <<"HTML_HEAD";
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>Task List</title></head>
<body>
<table border="1" cellpadding="4">
<tr><th>ID</th><th>Status</th><th>Description</th></tr>
HTML_HEAD

foreach my $t (@tasks) {
    my $status = $t->{done} ? '✓' : '✗';
    print $hf "<tr><td>$t->{id}</td><td>$status</td><td>$t->{desc}</td></tr>\n";
}

print $hf <<"HTML_TAIL";
</table>
</body>
</html>
HTML_TAIL

close $hf;

print "Tasks exported to $HTML_FILE successfully!\n";
