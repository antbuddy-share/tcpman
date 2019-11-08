#!/bin/bash


DIR="$(cd "$(dirname "$1")" && pwd)"
alias tcpman=$DIR/tcpdump.sh
. $DIR/.bash_completion
