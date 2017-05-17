Windows debug tools
==========================

This section of the repository contains tools for connection and security details debugging to be used with Windows platforms.

In order to perform such diagnostics, the user only has to run the `Ssl-Diagnostic.ps1` PowerShell script.

The script accepts a single parameter `-RemoteHost`  the hostname to perform diagnostics for.

From PS console:
```ps1
PS > .\Ssl-Diagnostic.ps1 -RemoteHost sample-host.com
```

The following commands are executed:
```ps1
# Test TCP connectivity and display detailed results
Test-NetConnection $RemoteHost -Port 443 -InformationLevel "Detailed"

# Test the response of a computer to 443 TCP port
$TestPortConnection = Test-TCPPortConnection -ComputerName $RemoteHost -Port 443

# Runs a traceroute and returns the result.
$TestRoute = Invoke-Traceroute -Destination $RemoteHost 

# Diagnose ssl connectivity 
$TestTLS = Test-ServerSSLSupport -HostName $RemoteHost
```
> :information_source: windows doesn't have a good TCP tracing solution,
> all `tracert/tracetcp` cannot reach final endpoint, even they used TCP SYN for tracerouting.
> PS function `Invoke-Traceroute` returns the same result.
