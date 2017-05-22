$startID = 2147489653;$endID = 2147489654
$log = Get-EventLog system -InstanceId $startID,$endID `
  -After ((Get-Date).AddDays(-32))
$StartObj = $log | ?{$_.InstanceId -eq $startID} | select timewritten | 
  sort timewritten | group {($_.TimeWritten).day} | %{
    $startTime = (@($_.group)[0]).TimeWritten
    New-Object PsObject -Property @{Date=$startTime.ToString("yyyy.MM.dd")
                  StartUp=$startTime.ToString("HH:mm:ss")}
} 
$EndObj = $log | ?{$_.InstanceId -eq $endID} | select timewritten |
  sort timewritten | group {($_.TimeWritten).day} | %{
    $endTime = (@($_.group)[-1]).TimeWritten 
    New-Object PsObject -Property @{Date=$endTime.ToString("yyyy.MM.dd")
                  ShutDown=$endTime.ToString("HH:mm:ss")}
}

$list = $StartObj+$EndObj | sort Date | group Date | %{
  $outObj = 1 | select Date,StartUp,ShutDown
  $outObj.Date = $_.name

  $_ | select -ExpandProperty group | %{
    if($_.StartUp){$outObj.StartUp = $_.StartUp}
    if($_.ShutDown){$outObj.ShutDown = $_.ShutDown}
  }
  $outObj
}
$list | ft -AutoSize
Read-Host please Enter
