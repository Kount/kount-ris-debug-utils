#!/bin/bash

function javaDiagnostics {
  javac SslDiagnostic.java 2>&1 >> $logfile
  java SslDiagnostic 2>&1 >> $logfile
}

function usage {
  echo "error: missing parameter"
  echo "usage:"
  echo "  $> network-diagnostic.sh <kount-ris-host>"
  echo "example:"
  echo "  $> network-diagnostic.sh risk.test.kount.net"
}

function troute {
  echo "Running traceroute to $kountHost ..." >> $logfile
  echo "" >> $logfile
  sudo traceroute -nTp 443 $kountHost >> $logfile
  echo "" >> $logfile
}

function netcat {
  echo "Trying to connect to $kountHost at port 443 ..." >> $logfile
  nc -zvw2 $kountHost 443 &>> $logfile
  echo "" >> $logfile
}

function tlsssl {
  echo "TLS/SSL diagnostics ..." >> $logfile
  echo "" >> $logfile

  if type -p java ; then
    echo "  Java executable found in PATH" >> $logfile
    javaDiagnostics
  elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]]; then
    echo "  Java executable found in $JAVA_HOME" >> $logfile
    javaDiagnostics
  else
    echo "No java installation is available, using curl fallback ..." >> $logfile
    echo "" >> $logfile
    curl -vvv --trace-time "https://$kountHost" 2>> $logfile
  fi
}

function resetlog {
  echo -n "" > $logfile
}

if [ -z "$1" ]; then
    usage ;
    exit ;
fi

logfile="network-diagnostic.log"
kountHost=$1

resetlog
troute
netcat
tlsssl

