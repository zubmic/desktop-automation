#!/bin/bash
### Configure conky

source $(dirname $0)/config.sh

echo "**CONKY CONFIGURATION**"

echo "Set spool mail path"
sed -i "s/MAIL/\/var\/spool\/mail\/$username/" $conky_left_config

echo "List available CPUs"
cpus=$(lscpu | grep "^CPU(s):" | awk '{ print $2 }')
cpus_list=""

for core in $(eval echo "{0..$cpus}"); do
    cpus_list+="\${goto 24}\${color1}CPU $core: \${freq_g} Ghz \${alignr}\${color2}\${cpu cpu$core}% \${color1}\${cpubar cpu$core 4, 124}\n"
done

sed -i "s/-- cpu_avg_samples = CPUS,/cpu_avg_samples = $cpus,/" $conky_right_config
sed -i "s/CPUSLIST/$cpus_list/" $conky_right_config

echo "Set network interface name"
sed -i "s/INTERFACE_NAME/$conky_net_interface_name/g" $conky_left_config

echo "Install Roboto Nerd font"
wget -q https://github.com/AguilarLagunasArturo/conky-themes/blob/main/fonts/Roboto%20Mono%20Nerd%20Font%20Complete.ttf?raw=true -P /usr/share/fonts
fc-cache -f -v

echo "Autostart Conky"
cp -v /usr/share/applications/conky.desktop $conky_left_autostart
cp -v /usr/share/applications/conky.desktop $conky_right_autostart
sed -i "s|Exec=conky --daemonize --pause=1|Exec=/usr/bin/conky --daemonize --pause=5 --config=$conky_left_config|" $conky_left_autostart
sed -i "s|Exec=conky --daemonize --pause=1|Exec=/usr/bin/conky --daemonize --pause=6 --config=$conky_right_config|" $conky_right_autostart