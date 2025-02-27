jScripts for transporting my dotfiles around. I'll make it more extensible at some point but for right now it is what it is

USAGE:

Basic Usage: configHandler.sh (flags here) 

-r=REPOLINK | --repo=REPOLINK

    - Sets the push/pull repo to the repolink 
-push | --push 

    - Amalgamates dotfiles and pushes them to the repo 
-pull | --pull 

    - Pulls dotfiles from the repo and puts them into their place (if you dont want to put them in their place just use git pull) 
-c | --clean 

    - Installs everything fresh and then loads config files if applicable 
-s | --starter 

    - Same thing as clean but adds certain things to path in your .zshrc (If you dont have prior config files this will make things actually work)

cleanInstall.sh

    This is what is run through -c and --starter
    you can give this the --starter or -s flag for the same behavior
    just a standalone script if you want to run it that way

configVar.sh

    configfile where you can put in file paths and other variables so that you dont have to pass in flags every time

