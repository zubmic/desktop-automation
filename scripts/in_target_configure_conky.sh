#!/bin/bash
### Configures conky
conky_left_conf="/home/$username/.config/conky/conky-left.conf"
conky_right_conf="/home/$username/.config/conky/conky-right.conf"

# Configs
mkdir /home/$username/.config/conky
cp $configs_dir/conky/conky-left.conf /home/$username/.config/conky/
cp $configs_dir/conky/conky-right.conf /home/$username/.config/conky/

# Write the path to spool mail
sed -i "s/MAIL/\/var\/spool\/mail\/$username/" $conky_left_conf

# Fill CPU info
cpus=$(lscpu | grep "^CPU(s):" | awk '{ print $2 }')
cpus_list=""

for core in $(eval echo "{0..$cpus}"); do
    cpus_list+="\${goto 24}\${color1}CPU $core: \${freq_g} Ghz \${alignr}\${color2}\${cpu cpu$core}% \${color1}\${cpubar cpu$core 4, 124}\n"
done

sed -i "s/-- cpu_avg_samples = CPUS,/cpu_avg_samples = $cpus,/" $conky_right_conf
sed -i "s/CPUSLIST/$cpus_list/" $conky_right_conf

# Configure network interface
interface_name=$(ip -o -4 route show to default | awk '{ print $5 }')
sed -i "s/INTERFACE_NAME/$interface_name/g" $conky_left_conf

# Install Roboto Nerd Font
wget -q https://github.com/AguilarLagunasArturo/conky-themes/blob/main/fonts/Roboto%20Mono%20Nerd%20Font%20Complete.ttf?raw=true -P /usr/share/fonts
fc-cache -f -v

# Autostart Conky panes
mkdir /home/$username/.config/autostart
cp /usr/share/applications/conky.desktop /home/$username/.config/autostart/conky-left.desktop
cp /usr/share/applications/conky.desktop /home/$username/.config/autostart/conky-right.desktop

sed -i "s/Exec=conky --daemonize --pause=1/Exec=\/usr\/bin\/conky --daemonize --pause=5 --config=\/home\/$username\/.config\/conky\/conky-left.conf/" /home/$username/.config/autostart/conky-left.desktop
sed -i "s/Exec=conky --daemonize --pause=1/Exec=\/usr\/bin\/conky --daemonize --pause=5 --config=\/home\/$username\/.config\/conky\/conky-right.conf/" /home/$username/.config/autostart/conky-right.desktop

chown -R $username:$username /home/$username/.config/