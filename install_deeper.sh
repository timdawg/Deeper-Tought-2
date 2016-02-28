#!/bin/sh

echo "Deeper Thought 2 Install Script\n"

# Make sure user is root
if [ "$(id -u)" != "0" ]; then
	echo "Access denied: Must be root"
	exit 1
fi

is_running() {
	testrun=$(ps -ef | grep "/usr/bin/deeper" | grep -v "grep" | grep -v "SCREEN" | wc -l)
	if [ $testrun -eq "0" ];
	then
			return 1
	else
			return 0
	fi
}

if (is_running); then
	/etc/init.d/deeper stop
	sleep 2
fi

make
cp deeper /usr/bin/
cp deeper.init /etc/init.d/deeper

case "$1" in
 	"--no-autostart")
		echo "Deeper Thought auto-start was not changed."
		echo "PiDP-8 simulator auto-start was not changed."
		;;
 	"--restore-pidp8")
		echo "Disabling auto-start for Deeper Thought..."
		update-rc.d deeper remove
		echo "Enabling auto-start for PiDP-8 simulator..."
		update-rc.d pidp8 default
		;;
	*)
		echo "Disabling auto-start for PiDP-8 simulator..."
		update-rc.d pidp8 remove
		echo "Enabling auto-start for Deeper Thought..."
		update-rc.d deeper defaults
		;;
esac

echo "\nTo run Deeper Thought as a daemon in the background:"
/etc/init.d/deeper help

echo "\nTo run Deeper Thought in the shell window and see its output run:"
echo "	sudo /usr/bin/deeper"

