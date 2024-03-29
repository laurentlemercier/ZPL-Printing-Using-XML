function Simulate-Printer
{
    Param
    (
        [string]$ipAddress = $false,
        [string]$port = "8100"
    )
    
    Begin
    {
        if($ipAddress -eq $false)
        {
            $HostName = [System.Net.Dns]::GetHostName()
            $iPAddress = [System.Net.Dns]::GetHostByName($HostName).AddressList[0].IPAddressToString
        }
        "Simulating printer on $ipAddress:$port"
    }
    Process
    {
        $ipAddress = [system.net.IPAddress]::Parse($ipAddress) 
        $TcpListener = New-Object System.Net.Sockets.TcpListener($ipAddress, $port)
        $TcpListener.Start()
        $TcpListener.Client
        "Started listening on $ipAddress:$port"

        $TcpClient = $TcpListener.AcceptTcpClient();
        $stream = $TcpClient.GetStream()     
        $data=@()
        while(!$stream.dataAvailable)
        {
            "Waiting for data..."
            Start-Sleep -s 1
            if($stream.dataAvailable)
            {
                Break
            }
        }
        while($stream.dataAvailable)
        {
            $data+=$Stream.ReadByte()
            if(!$stream.dataAvailable)
            {
                Break
            }
        }
        
    }
    End
    {
        "Simulation ended"
        $TcpListener.Stop()
        $message = [System.Text.Encoding]::UTF8.GetString($data)
        $message
    }
}
Simulate-Printer