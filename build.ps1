# Download Ollama

.\wget --no-hsts -q "https://github.com/ollama/ollama/releases/download/$env:GH_CI_TAG/ollama-windows-amd64.zip" -O .\ollama-windows-amd64.zip
Expand-Archive -Path .\ollama-windows-amd64.zip -DestinationPath .\build\ollama-windows-amd64



# Download driver

git clone https://github.com/Eisaichen/nvidia-driver-docker .\build\nvdll
Remove-Item -Path ".\build\nvdll\.git" -Recurse -Force



# Build ltsc2022

if ($env:GH_CI_LATEST -eq "true") {
    docker build --isolation hyperv --no-cache --pull -t eisai/ollama:latest -t eisai/ollama:$env:GH_CI_TAG .\build
} else {
    docker build --isolation hyperv --no-cache --pull -t eisai/ollama:$env:GH_CI_TAG .\build
}

# Push
if ($env:GH_CI_PUSH -eq "true") {
    docker push eisai/ollama -a
}

# Clean up
docker system prune --all -f



# Build ltsc2025

$i=Get-Content -Path .\build\Dockerfile
Set-Content -Path .\build\Dockerfile -Value $($i.replace("FROM mcr.microsoft.com/windows/servercore:ltsc2022","FROM mcr.microsoft.com/windows/servercore:ltsc2025"))

if ($env:GH_CI_LATEST -eq "true") {
    docker build --isolation hyperv --no-cache --pull -t eisai/ollama:ltsc2025 -t eisai/ollama:$env:GH_CI_TAG-ltsc2025 .\build
} else {
    docker build --isolation hyperv --no-cache --pull -t eisai/ollama:$env:GH_CI_TAG-ltsc2025 .\build
}

# Push
if ($env:GH_CI_PUSH -eq "true") {
    docker push eisai/ollama -a
}
