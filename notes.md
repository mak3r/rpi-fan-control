
```
apt-get install gnupg
curl -sfL http://archive.raspberrypi.org/debian/raspberrypi.gpg.key | apt-key add -
apt-get update
apt-get install -y libraspberrypi-bin
```

`vcgencmd measure_temp`

`/etc/apt/sources.list.d/raspi.list`
```
cat <<- EOF > /etc/apt/sources.list.d/raspi.list
deb http://archive.raspberrypi.org/debian/ jessie main ui
# Uncomment line below then 'apt-get update' to enable 'apt-get source'
#deb-src http://archive.raspberrypi.org/debian/ jessie main ui
EOF
```

```
PIN=$1
TEMP_ON=$2
TEMP_OFF=$3
SLEEP=$4

gpio mode $PIN out

function temperature {
    __t=$1
    t=$(vcgencmd measure_temp | cut -d '=' -f 2 | cut -d "'" -f 1)
    eval $__t="'$t'"
}

while true; do
  vcgencmd measure_temp; 
  temperature temp
  if (( $(echo "$temp >= $TEMP_ON" | bc -l) )) ; then 
    gpio write $PIN 1; 
  elif (( $(echo "$temp <= $TEMP_OFF" | bc -l) )) ; then
    gpio write $PIN 0; 
  fi; 
  sleep $SLEEP; 
done
```

## test this image
docker run --entrypoint /bin/bash -it --rm --privileged --mount type=bind,source=/dev/gpiomem,target=/dev/gpiomem mak3r/rpi-fan-control:testing

## always run this image
docker run -d --restart unless-stopped --privileged --mount type=bind,source=/dev/gpiomem,target=/dev/gpiomem mak3r/rpi-fan-control:testing

# Feature enhancements
Use load average as a means to control fan operation in addition to the other variables

### Research content
https://howchoo.com/g/ote2mjkzzta/control-raspberry-pi-fan-temperature-python
https://www.raspberrypi.org/forums/viewtopic.php?t=172985
https://askubuntu.com/questions/291035/how-to-add-a-gpg-key-to-the-apt-sources-keyring
