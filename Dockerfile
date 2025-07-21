FROM mcr.microsoft.com/windows/servercore:ltsc2022

WORKDIR /workspace

COPY Retry-Command.ps1 /
COPY install_texlive.ps1 /
COPY texlive.profile /

# Download & install TeXLive
RUN powershell -File C:\install_texlive.ps1

# Check if we can run pdflatex
RUN pdflatex -help
