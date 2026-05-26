# Build script to generate web/index.html from web/index.html.template
# This replaces environment variables from .env file
#
# Usage: .\scripts\build-web-index.ps1

param(
    [string]$EnvFile = ".env"
)

# Get the script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
$envPath = Join-Path -Path $projectRoot -ChildPath $EnvFile
$envExamplePath = Join-Path -Path $projectRoot -ChildPath ".env.example"
$webDir = Join-Path -Path $projectRoot -ChildPath "web"
$templatePath = Join-Path -Path $webDir -ChildPath "index.html.template"
$outputPath = Join-Path -Path $webDir -ChildPath "index.html"

# Load environment variables
$envVars = @{}

if (Test-Path $envPath) {
    Write-Host "📂 Loading $EnvFile" -ForegroundColor Green
    foreach ($line in Get-Content $envPath) {
        if ($line -and -not $line.StartsWith("#")) {
            $parts = $line -split "=", 2
            if ($parts.Count -eq 2) {
                $envVars[$parts[0].Trim()] = $parts[1].Trim()
            }
        }
    }
}
elseif (Test-Path $envExamplePath) {
    Write-Host "⚠️  .env file not found. Using .env.example" -ForegroundColor Yellow
    foreach ($line in Get-Content $envExamplePath) {
        if ($line -and -not $line.StartsWith("#")) {
            $parts = $line -split "=", 2
            if ($parts.Count -eq 2) {
                $envVars[$parts[0].Trim()] = $parts[1].Trim()
            }
        }
    }
}
else {
    Write-Host "❌ Neither .env nor .env.example found!" -ForegroundColor Red
    exit 1
}

# Check template exists
if (-not (Test-Path $templatePath)) {
    Write-Host "❌ Template file not found: $templatePath" -ForegroundColor Red
    exit 1
}

# Read template
$htmlContent = Get-Content $templatePath -Raw

# Replace variables
foreach ($key in $envVars.Keys) {
    $placeholder = "{{$key}}"
    $htmlContent = $htmlContent -replace [regex]::Escape($placeholder), $envVars[$key]
}

# Write output
Set-Content -Path $outputPath -Value $htmlContent -Encoding UTF8 -NoNewline
Write-Host "✅ Generated: $outputPath" -ForegroundColor Green
