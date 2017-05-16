Linux and OS X debug tools
==========================

This section of the repository contains tools for connection and security details debugging to be used with Linux or Mac OS platforms.

In order to perform such diagnostics, the user only has to run the `network-diagnostic.sh` shell script, preferably using root permissions.

The script accepts a single parameter -- the hostname to perform diagnostics for.

```bash
#> ./network-diagnostic.sh sample-host.com
```

The following commands are executed:
* traceroute -- a standard traceroute routine to determine connectivity between the client and the server.  
:warning: The command requires root privilege because it performs a TCP traceroute through port 443.
* netcat -- the `nc` command is uesd to verify that a connection between the client and the server can be successfully established.
* SSL/TLS diagnostics -- the `java` class coming along with the bash script tries to create a connection between the client and the server using differed TLS protocol versions: 1.0, 1.1 and 1.2.  
The `java` class is first compiled (requires `javac` available), then executed and outputs the diagnostics result in the same output file as the bash script commands.  
:warning: Since Java 8, TLS 1.0 is **not** supported therefore a proper message would be printed in the output log.  
:warning: In case no java installation is present, a `curl` call will be used. It prints similar connection details, however, it's only a fallback option which doesn't provide greater details about establishing the client-server connection.

