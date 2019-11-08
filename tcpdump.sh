#!/bin/bash

myssh() {
  test=$1
  if [[ "$test" == "--test" ]]; then
    shift
  else
    test=""
  fi
  item="$1"
  callback="$2"
  command="${callback//NODE/$item}"
  command="ssh $item '$command'"
  echo "[Exec] $command"
  if [[ "$test" != "--test" ]] ; then
    eval $command
  else
    echo "--test"
    # ssh $item
  fi
}

test=$1
if [[ "$test" == "--test" ]]; then
  shift
else
  test=""
fi
item="$1"
id=$(date +"%Y-%m-%d_%H-%M-%S")
#  'cat /etc/network/interfaces' | grep iface | grep -v "iface lo" | head -n 1 | cut -d " " -f 2
myeth=$(myssh "$item" "cat /etc/network/interfaces" | grep iface | grep -v "iface lo" | head -n 1 | cut -d " " -f 2)
# echo $myeth
# callback="tcpdump $@"
localout=${2:-"/tmp/tcpdump.$id.pcap"}
if [[ "$myeth" != "" ]]; then
  myssh $test "$item" "sudo tcpdump -i $myeth -w /tmp/tcpdump.pcap"
  echo "Stopped tcpdump"
  rsync -razvP $item:/tmp/tcpdump.pcap $localout
  echo "File is downloaded to $localout"
else
  echo "Cannot load the ether from external server"
fi

# Kill all existed
myssh "$item" "sudo killall tcpdump"
