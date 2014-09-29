find_ghost_processes
===============================================================================

This is a Bash script which finds all running processes whose source files have
been deleted (e.g.., a running script whose executable has been deleted). It
creates a report of all such processes and recovers and saves a copy of the
source files. 

Use cases: forensics, file recovery
