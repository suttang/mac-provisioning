#!/bin/bash

echo '=================================================='
echo 
echo '           🎉   Congratulations   🎉                '
echo
echo Basic settings was completed.
echo in next, copy dropbox files to your machine for advanced settings.
echo for that, you need to open Dropbox app and wait sync done.
echo

sleep 0.5

while true; do
    read -p 'Do you want to open Dropbox.app? [Y/n]' Answer
    case $Answer in
        '' | [Yy]* )
            sleep 0.5
            open /Applications/Dropbox.app
            break;
            ;;
        [Nn*] )
            sleep 0.5
            break;
            ;;
        * )
            echo Please answer Y or n
    esac
done

echo 
echo When Dropbox sync is completed,
echo execute the following command.
echo
echo ' make continue'
echo
echo ==================================================