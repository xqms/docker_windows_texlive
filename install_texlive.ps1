$ErrorActionPreference = "Stop"

. C:\Retry-Command.ps1

# Download software
Retry-Command -TimeoutInSecs 2 -Verbose -ScriptBlock {
    wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl.zip -OutFile C:\installer.zip
}

# Extract
Expand-Archive -Path c:\installer.zip -DestinationPath c:\

# Figure out the name
$Installer=(Get-Item C:\install-tl-*)

# Install Software
& $Installer\install-tl-windows --profile=C:\texlive.profile
if($lastexitcode -ne '0')
{
    throw "Failed to install TeXLive"
}

# Remove unneeded files
Remove-Item c:\installer.zip
Remove-Item $Installer -Force -Recurse

# Reload PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Install additional packages
& tlmgr install xstring preview adjustbox etexcmds catchfile ltxcmds infwarerr ifplatform pgfopts letltxmacro filemod collectbox ifoddpage varwidth standalone
if($lastexitcode -ne '0')
{
    throw "Failed to install packages"
}
