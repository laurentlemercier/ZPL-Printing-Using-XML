<h1>ZPL printing using XML</h1>
<h2>What it should do</h2>
<p>A script should transform an XML file (trigger XML) generated by a random software-package to an XML format used by a ZPL XML enabled printer.</p>
<p>There is also an ini.xml file available which contains printer and format information based on the location ID. When the location ID is contained in the trigger XML file the resulting XML can be send to the printer</p>
<h2>How it works</h2>
<p>There are two scripts in the repository. Simulate-Printer.ps1 accepts an IP address (defaults to IP of the localhost) and portnumber (defaults to 8100). When called it waits for a connection from a TCP client. 
When connected and data was received, it prints the data to the console and closes. This script is meant for testing when no printer is available.</p><p>
Start-Printing.ps1 accepts an XML file to transform and an XSLT transformation file. First step is transforming the XML file using the XSLT script adding printer address/portnumber and labelformat extracted from the ini.xml file.
It uses this ip address/portnumber to establish a connection to the printer/simulation and sends the resulting XML content using TCP protocol</p>
<p>The example.txt file contains the ZPL code for a label. To use this You can paste this code in the webinterface zpl designer of a Zebra printer (I used this with a ZM400 Zebra printer)</p>