FROM mcr.microsoft.com/windows/servercore/iis

RUN powershell -NoProfile -Command Remove-Item -Recurse C:\inetpub\wwwroot\*

WORKDIR /inetpub/wwwroot

COPY content/ .
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#Copy installers
RUN New-Item -Path 'c:\tools' -ItemType Directory

RUN (New-Object System.Net.WebClient).DownloadFile('https://github.com/prometheus-community/windows_exporter/releases/download/v0.16.0/windows_exporter-0.16.0-amd64.msi', 'c:\tools\windows_exporter-0.16.0-amd64.msi') ;\
    Start-Process 'msiexec' -ArgumentList '/i c:\tools\windows_exporter-0.16.0-amd64.msi /quiet /qn /norestart /log c:\tools\installAuth.log'; \
    Start-Sleep -s 30 ;\
    Remove-Item c:\tools\*.msi -force
    