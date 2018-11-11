param(
    [parameter(mandatory=$true)]
    [pscredential]$VmCreds,
    [parameter(Mandatory=$true)]
    [string]$VmIp,
    [parameter(Mandatory=$true)]
    [string]$ScriptPath
)

# Start the ssh session and get a stream going
$VmSession = New-SSHSession -ComputerName $VmIp -Credential $VmCreds
$VmSshStream = $VmSession.Session.CreateShellStream("PS-SSH", 0, 0, 0, 0, 1000)

# Switch to root to avoid permission headaches
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $VmSshStream -Command "sudo su -" -ExpectString "[sudo] password for $($VmCreds.UserName):" -SecureAction $VmCreds.Password

Start-Sleep -Seconds 2
Write-Output $VmSshStream.Read()
Get-Content $ScriptPath | ForEach-Object {
    $VmSshStream.WriteLine($_)

    # Print the output until we see root so we can do the next command
    do {
        Start-Sleep -Seconds 1
        $sshOutput = $VmSshStream.Read()
        Write-Output $sshOutput
    } until ($sshOutput.contains("root"))
}