#/bin/sh
if [ $# -gt 1 ]
then
    killall jackd 2> /dev/null && sleep 2
    jackd "$@" && sleep 2
fi
pactl load-module module-jack-sink channels=2
pactl load-module module-jack-source channels=2
pacmd set-default-sink jack_out
pacmd set-default-source jack_in
