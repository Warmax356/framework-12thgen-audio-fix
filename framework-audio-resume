#!/sh
# /lib/systemd/system-sleep/framework-audio-resume
# Automatically triggers the audio hardware re-probe upon system wake up

case "$1" in
    post)
        /usr/local/bin/framework-audio-fix.sh
        ;;
esac
