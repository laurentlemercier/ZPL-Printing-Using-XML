function Start-Printing
{
    Param
    (
        [String]$XmlPath,
        [string]$XslPath
    )
    "started"
    
    $CURRENT_WORKING_DIRECTORY = Convert-Path(".")
    
    if($XslPath.Length -eq 0 -or $XmlPath.Length -eq 0)
    {
        "wrong usage of function"
    }
    else
    {
        $XslPath = $CURRENT_WORKING_DIRECTORY+"\"+$XslPath
        $XmlPath = $CURRENT_WORKING_DIRECTORY+"\"+$XmlPath
        
        
        #create a memorystream to store the transformed XML sheet
        [System.IO.MemoryStream] $Stream = New-Object System.IO.MemoryStream
        
        #create a XMlReader for reading the XSL file
        [System.Xml.XmlReader] $Reader = [System.Xml.XmlReader]::Create($XslPath)
        
        #create a XMLWriter to write the resulting XML to the memory stream
        [System.Xml.XmlWriter] $Writer = [System.Xml.XmlWriter]::Create($stream)
        
        #XsltSettings.EnableDocumentFunction must be set to use System.Xml.Xsl.XslCompiledTransform.load
        [System.Xml.Xsl.XsltSettings] $Settings = New-Object System.Xml.Xsl.XsltSettings
        $Settings.EnableDocumentFunction = $True
        
        #XslUrlResolver is needed for System.Xml.Xsl.XslCompiledTransform.load
        #setting this parameter to null resulted in an error
        [System.Xml.XmlUrlResolver] $Resolver = New-Object System.Xml.XmlUrlResolver
        
        
        #XslCompiledTransformer is used for transforming the XML string
        [System.Xml.Xsl.XslCompiledTransform] $Transformer = New-Object System.Xml.Xsl.XslCompiledTransform
        #XSL is loaded and compiled by the transformer
        $Transformer.load($Reader,$Settings, $Resolver)
        #XML is read, transformed and written to our memory stream
        $Transformer.Transform($XmlPath,$Writer)
        
        #the position of the pointer of $Stream is set to the beginning
        $Stream.Seek(0,[System.IO.SeekOrigin]::Begin)
        #a streamreader is created for reading out our stream
        [System.IO.StreamReader] $StreamReader = New-Object System.IO.StreamReader $Stream
        $xml = $StreamReader.ReadToEnd()
        $xml
        #use the resulting xml from the previous step to print
        #get the ip address
        $Test = $xml -match "<variable name=.printerAddress.\>([0-9|\.]*)\<.variable\>"
        if($Test)
        {
            #ip address
            $Ip = $matches[1]
            $Address = [system.net.IPAddress]::Parse($Ip)
            
            #port number
            $Test = $xml -match "<variable name=.printerPort.\>([0-9|\.]*)\<.variable\>"
            if($Test)
            {
                [int]$port = $matches[1]
            }
            else
            {
                [int]$port = 9100
            }
            
            
            #open a connection to a printer
            #create IP socket
            $TcpClient = New-Object System.Net.Sockets.TCPClient
            $TcpClient.connect($Address, $Port)
            
            if($TcpClient.Connected)
            {
                #create a streamwriter
                $IOWriter = New-Object System.IO.StreamWriter($TcpClient.getStream())
                $xml
                $IOWriter.Write($xml)
                $IOWriter.Flush()
                $IOWriter.Close()
                $TcpClient.Close()
            }
            else
            {
                "Could not connect to ip $Ip"
            }
        }
        else
        {
            "Could not find the printers IP adres"
        } 
    }
}
