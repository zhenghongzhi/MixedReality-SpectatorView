function DownloadNuGetPackage
{ 
  param(
    $PackageName,
    $Version,
    $IntermediateFolder,
    $OutputFolder
  )

  $nugetFile = "$IntermediateFolder\$PackageName.$Version.nupkg"
  $zipFile = "$IntermediateFolder\$PackageName.$Version.zip"
  $zipOutputFolder = "$IntermediateFolder\$PackageName.$Version"

  $url = "https://www.nuget.org/api/v2/package/$PackageName/$Version"
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $wc = New-Object System.Net.WebClient
  $wc.DownloadFile($url, $nugetFile)
  Copy-Item -Path $nugetFile -Destination $zipFile -Force
  Expand-Archive -Path $zipFile -DestinationPath $zipOutputFolder -Force

  if (Test-Path -Path "$zipOutputFolder\Unity")
  {
    New-Item -Path "$OutputFolder\$PackageName.$Version\Unity" -ItemType Directory
    Copy-Item -Path "$zipOutputFolder\Unity\*" -Destination "$OutputFolder\$PackageName.$Version\Unity" -Recurse
  }

  if (Test-Path -Path "$zipOutputFolder\lib\net46")
  {
    New-Item -Path "$OutputFolder\$PackageName.$Version\lib\net46" -ItemType Directory
    Copy-Item -Path "$zipOutputFolder\lib\net46\*" -Destination "$OutputFolder\$PackageName.$Version\lib\net46" -Recurse
  }
}

function DownloadQRCodePlugin
{
  $mainFolder = "$PSScriptRoot\..\..\external\MixedReality-QRCodePlugin\"
  $contentFolder = "$mainFolder\UnityFiles\"

  Remove-Item -Path "$mainFolder\*Microsoft.*" -Recurse
  Remove-Item -Path "$mainFolder\UnityFiles\*" -Recurse
  DownloadNuGetPackage -PackageName "Microsoft.MixedReality.QR" -Version "0.5.2092" -IntermediateFolder $mainFolder -OutputFolder "$contentFolder"
  DownloadNuGetPackage -PackageName "Microsoft.VCRTForwarders" -Version "140.1.0.5" -IntermediateFolder $mainFolder -OutputFolder "$contentFolder"
}
