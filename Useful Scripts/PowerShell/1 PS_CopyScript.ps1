$computers = Get-Content "C:\sqlserverlist.txt"
$fileToCopy = "C:\tmp\<patchfilename>.exe"
ForEach($computer in $Computers){
    Copy-Item -Path $fileToCopy -Destination "\\$computer\D$\"
}