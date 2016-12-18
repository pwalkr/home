#!/bin/bash

cCols=6

cOffset=4

cEnd='\e[0m'

for i in $(eval echo {$cOffset..255})
do
    iOffset=$((i - cOffset))

    imod=$((iOffset % cCols))
    if [ 0 -eq $imod ]
    then
        echo -e "$sline$cEnd"
        sline="$i+ "
        while [ 5 -gt ${#sline} ]
        do
            sline="$sline "
        done
    fi

    if [ 10 -gt $imod ]
    then
        sline="$sline\e[48;5;$i""m  $imod"
    else
        sline="$sline\e[48;5;$i""m $imod"
    fi
done

echo -e "$sline$cEnd"

c1='\e[48;5;21m'
c2='\e[48;5;27m'
c3='\e[48;5;33m'
c4='\e[48;5;39m'
c5='\e[48;5;45m'
c6='\e[48;5;51m'
c7='\e[48;5;7m'

echo -e "$c1  $c2    $c3      $c4        $c5          $c6            $c7              $cEnd"
