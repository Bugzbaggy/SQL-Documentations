$computers = Get-Content "C:\Temp\primary.txt"
ForEach($computer in $Computers){
    restart-computer -computername $computer -force
}