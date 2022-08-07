#!/bin/bash

echo "# WARNING!!!"
echo "# This is a collection of random bash script with no correlation"
echo "# and NOT intended to be executed as all-in-one script."
echo "# exit!"
exit 1

# Cleanup (kill) orphaned ssh session
# Watch you user session
w
# insert 'TTY' of the orphan session here:
user_tty="pts/4"
echo "Thic proccess will be killed:"
ps -ef | grep ${user_tty} | head -n1
ps -ef | grep ${user_tty} | head -n1 | awk '{print $2}' | xargs kill -15
