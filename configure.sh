#!/bin/bash

set -e

if [ -z "$1" ];then
  cat <<EOF
Configure mouseaccel manager script for the user

  USAGE: $0 <action>

  ACTIONS:
    install <device search term>
    status
    deinstall
EOF
  exit 0
fi

SCRIPT_FILENAME="/home/$USER/bin/disable_mouse_accel.sh"

function install {
  echo -e "Install started for $SEARCH"
  echo -e ""
  # echo -e "List of peripherals"
  # echo -e ""
  # xinput list --name-only

  if [ "$SEARCH" = "" ]; then
    echo "A search term must be defined"
    exit 1
  fi

  ids=$(xinput --list | awk -v search="$SEARCH" \
      '$0 ~ search {match($0, /id=[0-9]+/);\
                    if (RSTART) \
                      print substr($0, RSTART+3, RLENGTH-3)\
                   }'\
       )

  # echo -e ""
  # read -p "What's the device to manage? " DEVICE
  # echo ""
  echo "Device ids selected $ids"
  echo ""
  [ ! -d ~/bin ] && mkdir ~/bin
  cat <<EOF > $SCRIPT_FILENAME
#!/bin/bash

#wait for the desktop to settle
echo "Configure mouse"
echo ""
sleep 5
# turn off mouse acceleration
$(for i in $ids
do
    echo "xinput set-prop $i 'Device Accel Profile' -1"
    echo "xinput set-prop $i 'Device Accel Constant Deceleration' 2.5"
    echo "xinput set-prop $i 'Device Accel Adaptive Deceleration' 2.5"
    echo "xinput set-prop $i 'Device Accel Velocity Scaling' 1.0"
done
)
EOF
  chmod +x $SCRIPT_FILENAME
  echo "Script is installed in $SCRIPT_FILENAME"
}

function status {
  echo "Status:"
  echo ""

  if [ -f $SCRIPT_FILENAME ];then
    echo "mouseaccel manager script is installed"
  else
    echo "mouseaccel manager script is not installed"
  fi

  echo ""
  xinput list

  if [ "$SEARCH" != "" ]; then
    ids=$(xinput --list | awk -v search="$SEARCH" \
        '$0 ~ search {match($0, /id=[0-9]+/);\
                      if (RSTART) \
                        print substr($0, RSTART+3, RLENGTH-3)\
                     }'\
         )
     for i in $ids;do
       xinput list-props $i
     done
 fi

}

function deinstall {
  echo "Deinstall:"
  echo ""

  if [ -f $SCRIPT_FILENAME ];then
    rm $SCRIPT_FILENAME
  else
    echo "mouseaccel manager script is not installed"
    exit 1
  fi
}

SEARCH=$2
case "$1" in
  install)
    install
    ;;
  status)
    status
    ;;
  deinstall)
    deinstall
    ;;
  *)
    echo $"Usage: $0 {install|status|deinstall}"
    exit 1
esac

set +e
