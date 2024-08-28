FROM mcr.microsoft.com/windows/servercore:ltsc2022

EXPOSE 11434

ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODELS='C:\models'

COPY ./res C:/res
COPY ./ollama-windows-amd64 C:/app

RUN powershell -command "takeown /F C:\res /R /D Y /A 1> $null" ; \
    powershell -command "takeown /F C:\app /R /D Y 1> $null" ; \
    Copy-Item -Force 'C:\res\nvdll\*' 'C:\Windows\System32\' ; \
    Import-Certificate -FilePath C:\res\cacert.sst -CertStoreLocation 'Cert:\LocalMachine\Root' ; \
    Remove-Item -Recurse -Force C:\res

WORKDIR C:/app
ENTRYPOINT ollama.exe serve
