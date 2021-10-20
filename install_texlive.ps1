$ErrorActionPreference = "Stop"

. C:\Retry-Command.ps1

# Download software
Retry-Command -TimeoutInSecs 2 -Verbose -ScriptBlock {
    wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-windows.exe -OutFile C:\install-tl-windows.exe
}

# Install Software
& C:\install-tl-windows.exe --profile=C:\texlive.profile
if($lastexitcode -ne '0')
{
    throw "Failed to install TeXLive"
}

# Remove unneeded files
Remove-Item c:\install-tl-windows.exe

# Reload PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Install additional packages
& tlmgr install xstring preview adjustbox etexcmds catchfile ltxcmds infwarerr ifplatform pgfopts letltxmacro filemod
if($lastexitcode -ne '0')
{
    throw "Failed to install packages"
}
