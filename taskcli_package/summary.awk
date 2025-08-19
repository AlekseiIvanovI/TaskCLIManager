#!/usr/bin/awk -f

# AWK script to generate a summary report from tasks.json file

# Run BEFORE procesing any lines
BEGIN {
    FS=":";                # Sets the field seperator to ':'
    taskCount = 0;         # counts # of total tasks
    doneTasks = 0;         # counts # of done tasks
    openTasks = 0;         # counts # of open tasks
    inTask = 0;            # flag to confirm we have a current task

    # Prints the report header
    print "\n--- TaskCLI Summary Report ---\n";
}

# Marks start of a task new object in tasks.json
/"id":/ {
    taskCount++;            # increment # of total tasks
    inTask = 1;             # set flag to confirm we have a current task
}

# Executes if we have a current task and if that task is marked as done
inTask && /"done":/ {
    if ($2 ~ /true/) {
        doneTasks++;        # increment # of done tasks
    }
    inTask = 0;             # clear flag for current task
}

# Runs after all the lines in tasks.json processed, print results
END {
    openTasks = taskCount - doneTasks;
    
    # Print results
    print "Total tasks:      " taskCount;
    print "Completed tasks:  " doneTasks;
    print "Pending tasks:    " openTasks;

    # Determine % of tasks completed, if > 0 tasks completed
    if (taskCount > 0) {
        completionRate = (doneTasks / taskCount) * 100;
        printf("Completion rate:  %.1f%%\n", completionRate);
    } else {
        print "Completion rate:  N/A (no tasks)";
    }

    # Prints at the end of the summary
    print "\n--- End of Summary ---\n";
}