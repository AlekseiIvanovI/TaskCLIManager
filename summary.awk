#!/usr/bin/awk -f

# AWK script to generate a summary report from the tasks JSON file
BEGIN {
    FS=":";
    taskCount = 0;
    doneTasks = 0;
    openTasks = 0;
    inTask = 0;
    print "\n--- TaskCLI Summary Report ---\n";
}

# Start of a task object
/"id":/ {
    taskCount++;
    inTask = 1;
}

# Check if a task is marked as done
inTask && /"done":/ {
    if ($2 ~ /true/) {
        doneTasks++;
    }
    inTask = 0;
}

END {
    openTasks = taskCount - doneTasks;
    
    print "Total tasks:      " taskCount;
    print "Completed tasks:  " doneTasks;
    print "Pending tasks:    " openTasks;
    
    if (taskCount > 0) {
        completionRate = (doneTasks / taskCount) * 100;
        printf("Completion rate:  %.1f%%\n", completionRate);
    } else {
        print "Completion rate:  N/A (no tasks)";
    }
    
    print "\n--- End of Summary ---\n";
}
