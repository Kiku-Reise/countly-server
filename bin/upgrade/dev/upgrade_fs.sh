#!/bin/bash

echo "Running filesystem modifications"

VER="20.04.2"

CONTINUE="$(countly check before upgrade fs "$VER")"

if [ "$CONTINUE" != "1" ] && [ "$1" != "combined" ]
then
    echo "Filesystem is already up to date with $VER"
    read -r -p "Are you sure you want to run this script? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        CONTINUE=1
    fi
fi

if [ "$CONTINUE" == "1" ]
then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
    # CUR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    #enable command line
    bash "$DIR/scripts/detect.init.sh"
    
    #removing moved files
    if [ -f "$DIR/../plugins/populator/frontend/public/stylesheets/banking.css" ]; then
        rm -rf "$DIR/../plugins/populator/frontend/public/stylesheets/banking.css";
    fi
    if [ -f "$DIR/../plugins/populator/frontend/public/stylesheets/ecommerce.css" ]; then
        rm -rf "$DIR/../plugins/populator/frontend/public/stylesheets/ecommerce.css";
    fi
    if [ -f "$DIR/../plugins/populator/frontend/public/stylesheets/gaming.css" ]; then
        rm -rf "$DIR/../plugins/populator/frontend/public/stylesheets/gaming.css";
    fi
    if [ -f "$DIR/../plugins/populator/frontend/public/stylesheets/healthcare.css" ]; then
        rm -rf "$DIR/../plugins/populator/frontend/public/stylesheets/healthcare.css";
    fi
    if [ -f "$DIR/../plugins/populator/frontend/public/stylesheets/navigation.css" ]; then
        rm -rf "$DIR/../plugins/populator/frontend/public/stylesheets/navigation.css";
    fi


    countly plugin upgrade star-rating
    countly plugin upgrade users
    countly plugin upgrade consolidate
    countly plugin upgrade push
    (cd "$DIR/../plugins/push/api/parts/apn" && npm install --unsafe-perm)

    #install dependencies, process files and restart countly
    countly task dist-all

    #call after check
    countly check after upgrade fs "$VER"
fi
