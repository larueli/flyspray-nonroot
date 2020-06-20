#!/bin/bash
if [ ! -z "$REMOVE_SETUP" ]
then 
    rm -rf /var/www/html/setup
fi
apache2-foreground