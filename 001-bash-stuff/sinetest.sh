#!/bin/bash
# sinetest.sh

host_target="$1"
if [[ ${host_target} = https* ]]; then
        endpoint=${host_target}
elif [[ ${host_target} = http:* ]]; then
        endpoint=${host_target}
else
        endpoint="http://${host_target}"
fi

vref=5
amplitude=20
horiz_t=3
horiz_start=2
vert_start=2
angle_start=0
angle=$angle_start
angle_shift=90
step_angle=12
centreline=0
vpp=$((2*amplitude))
PI=3.14159
title_posx=$((vref+vpp+2))
horiz_plot=$horiz_start
vert_plot=$vert_start
clear
# Do a single cycle, quantised graph.
while [ $angle -le 360 ]
do
        # Create each floating point value...
        # CygWin now catered for... ;o)
        vert_plot=$(awk "BEGIN{ printf \"%.12f\", ((sin(($angle-$angle_shift)*($PI/180))*$amplitude)+$centreline)}")
        #vert_plot=$(bc -l <<< "{print ((s($angle*($PI/180))*$amplitude)+$centreline)}")
        # Truncate the floating point value to an integer then invert the plot to suit the x y co-ordinates inside a terminal...
        vert_plot=$(((amplitude+1)-${vert_plot/.*}))
        # Plot the point(s) and print the angle at that point...
        vert_pos=$(( (2*amplitude)-(vert_plot-vref) ))
        delay_t=$( awk "BEGIN {print $horiz_t/$vert_pos}")
        for vert_bar in $(seq 0 $vert_pos); do
                #printf "\x1B["$(( (vpp+vref)-vert_bar ))";"$horiz_plot"f*"
                #printf "\x1B["$((title_posx))";1fAngle is $angle degrees... x: $horiz_plot, y: $vert_plot, bar: $vert_bar, delay: $delay_t"
                echo -n "$(date +'%F %T.%3N') | ${endpoint} | "
                curl -s ${host_target} -o /dev/null -w "| con_t: %{time_connect}, total_t: %{time_total}, RC: %{http_code}" | tr '\n' ' '
                echo ""
                sleep $delay_t
        done
        #sleep 1
        # Increment values...
        angle=$(( angle+step_angle ))
        horiz_plot=$(( horiz_plot+1 ))
        horiz_max=$(stty size | cut -d' ' -f2)
        if [[ $horiz_plot -ge $horiz_max ]];
        then
                horiz_plot=$horiz_start
                clear
        fi
        if [[ $angle -eq 360 ]];
        then
                angle=$angle_start
        fi
done
#printf "\x1B["$((title_posx+1))";1fSinewave plotted as a quantised text mode graph.\n"
exit 0