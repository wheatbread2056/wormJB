the user should already have A-Shell and the shortcut

# shortcut stage

1. the shortcut installs the `git` dependency.

2. the shortcut cds into ~ which is the a-shell home directory

3. the shortcut clones the github repo

4. the shortcut runs the main script.

# script stage

now that the main script is running, it will show some fake information about a fake exploit that does not exist. then it will say its setting up the environment, but it will really be doing:

5. check if a same or newer version of wormJB is already installed.

6. install neofetch for A-Shell

7. cd to / by default in A-Shell (gives the illusion of a root filesystem, since A-Shell can look in root for some reason but can't go inside the folders besides some specific ones)

8. make fake jb directories like /var/jb in ~ (since root /var isnt writable or even readable)

9. install wormJB tools (scripts) that report some fake jailbreak information but some might actually be semi useful but probably not

10. "install" apt (also just a script)

11. install some config profile to get fake zebra (safe)

12. say done and neofetch.
