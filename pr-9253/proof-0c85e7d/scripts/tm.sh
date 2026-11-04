#!/usr/bin/env bash
# Runs "$2" in the private tmux shell (which holds the generated values in its environment), output to $P/$1.out,
# exit status to $P/$1.done. Usage: tm.sh <label> <command>
P="${P:?folder for this run's private output}"
rm -f "$P/$1.done"
tmux send-keys -t p9253c "( $2 ) > $P/$1.out 2>&1; echo \$? > $P/$1.done" Enter
