FROM mcr.microsoft.com/powershell:latest

RUN pwsh -c "Install-Module Az -Scope AllUsers -Acceptlicense -Force"

COPY entry.ps1 /entry.ps1

ENTRYPOINT ["pwsh", "-File", "/entry.ps1"]