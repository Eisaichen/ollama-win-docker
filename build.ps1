.\wget --no-hsts -q "https://github.com/ollama/ollama/releases/download/$env:GH_CI_TAG/ollama-windows-amd64.zip" -O .\ollama-windows-amd64.zip
Expand-Archive -Path .\ollama-windows-amd64.zip -DestinationPath .\build\ollama-windows-amd64

docker pull mcr.microsoft.com/windows/servercore:ltsc2022
if ($env:GH_CI_PUSH -eq "true") {
    docker build --isolation hyperv --no-cache -t eisai/ollama:latest -t eisai/ollama:$env:GH_CI_TAG .\build
} else {
    docker build --isolation hyperv --no-cache -t eisai/ollama:$env:GH_CI_TAG .\build
}

if ($env:GH_CI_PUSH -eq "true") {
    docker push eisai/ollama -a
}
