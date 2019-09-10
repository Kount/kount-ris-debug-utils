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
  echo  $(java -version 2>&1) | grep "java version" | awk '{ print substr($3, 2, length($3)-2); }'
  echo  $(java -version 2>&1) | grep "java version" | awk '{ print substr($3, 2, length($3)-2); }' >> $logfile
}

function getdotnetinfo(){
 echo -n "" >> $logfile
 echo "-------------------------------------------" >> $logfile
 echo "Version required for .NET SDK 2.0.0 or higher" >> $logfile
 echo "Current Version is :" >> $logfile
 var0=$(dotnet --version)
if [ ${#var0} -ge 1 ]; then echo $var0 >> $logfile ; 
else echo ".Net version is not found" >> $logfile
fi
 }
 function getjavainfo(){

 echo -n "" >> $logfile

 echo "-------------------------------------------" >> $logfile
 echo "Version required for JAVA SDK 1.6.0 or higher" >> $logfile
 echo "Current Version is :" >> $logfile
 var=$(java -version 2>&1 | awk -F '"' 'NR==1 {print $2}')
 if [ ${#var} -ge 1 ]; then echo $var >> $logfile ; 
else echo "JAVA version is not found" >> $logfile
fi
}
function getphpinfo(){
  echo "-------------------------------------------" >> $logfile
  echo "Version required for PHP SDK 5.0.0 or higher" >> $logfile
  echo "Current Version is :" >> $logfile
  var1=$(php --version)
  if [ ${#var1} -ge 1 ]; then echo $var1 >> $logfile ; 
else echo "PHP version is not found" >> $logfile
fi
}
function getrubyinfo(){
  echo "-------------------------------------------" >> $logfile
  echo "Version required for RUBY SDK 2.0.0 or higher" >> $logfile
  echo "Current Version is :" >> $logfile
  var2=$(ruby --version)
 if [ ${#var2} -ge 1 ]; then echo $var2 >> $logfile ; 
else echo "RUBY version is not found" >> $logfile
fi
}
function getpythoninfo(){
  echo "-------------------------------------------" >> $logfile
  echo "Version required for PYTHON SDK 2.0.0 or higher" >> $logfile
  echo "Current Version is :" >> $logfile
  var3=$(python --version)
 if [ ${#var3} -ge 1 ]; then echo $var3 >> $logfile ; 
else echo "PYTHON version is not found" >> $logfile
fi

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
getdotnetinfo
getjavainfo
getphpinfo
getrubyinfo
getpythoninfo







