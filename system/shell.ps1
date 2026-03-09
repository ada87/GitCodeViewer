# GitCode Viewer - Repository Sync Utilities

# ============ Configuration ============

$Config = @{
    MaxConcurrent = 3
    TimeoutSeconds = 30
    RetryCount = 2
}

# ============ Domain Models ============

function New-Repository {
    param(
        [string]$Id,
        [string]$Name,
        [string]$Url,
        [string]$Branch = "main",
        [long]$SizeBytes = 0
    )
    [PSCustomObject]@{
        Id         = $Id
        Name       = $Name
        Url        = $Url
        Branch     = $Branch
        LastSynced = $null
        SizeBytes  = $SizeBytes
        Status     = "Idle"
    }
}

# ============ Utility Functions ============

function Format-Bytes {
    param([long]$Bytes)
    switch ($Bytes) {
        { $_ -lt 1KB }  { return "$Bytes B" }
        { $_ -lt 1MB }  { return "$([math]::Round($_ / 1KB, 1)) KB" }
        { $_ -lt 1GB }  { return "$([math]::Round($_ / 1MB, 1)) MB" }
        default          { return "$([math]::Round($_ / 1GB, 2)) GB" }
    }
}

function Get-DisplayName {
    param([PSCustomObject]$Repo)
    $name = $Repo.Url.Split("/")[-1] -replace "\.git$", ""
    if ([string]::IsNullOrEmpty($name)) { $Repo.Name } else { $name }
}

# ============ Sync Functions ============

function Invoke-SyncRepository {
    param(
        [PSCustomObject]$Repo,
        [int]$RetryCount = $Config.RetryCount
    )

    $Repo.Status = "Syncing"
    Write-Host "[SYNC] $(Get-DisplayName $Repo) ..." -ForegroundColor Cyan

    for ($i = 0; $i -le $RetryCount; $i++) {
        try {
            Start-Sleep -Milliseconds 500

            $Repo.LastSynced = Get-Date
            $Repo.Status = "Done"
            $filesChanged = Get-Random -Minimum 1 -Maximum 50

            Write-Host "[OK]   $(Get-DisplayName $Repo): $filesChanged files changed" -ForegroundColor Green
            return [PSCustomObject]@{ Success = $true; Repo = $Repo; FilesChanged = $filesChanged }
        }
        catch {
            if ($i -eq $RetryCount) {
                $Repo.Status = "Failed"
                Write-Host "[ERR]  $(Get-DisplayName $Repo): $($_.Exception.Message)" -ForegroundColor Red
                return [PSCustomObject]@{ Success = $false; Repo = $Repo; Error = $_.Exception.Message }
            }
            Write-Host "[RETRY] $(Get-DisplayName $Repo) attempt $($i + 2)..." -ForegroundColor Yellow
        }
    }
}

function Invoke-SyncAll {
    param([PSCustomObject[]]$Repos)

    $results = @()
    $batches = for ($i = 0; $i -lt $Repos.Count; $i += $Config.MaxConcurrent) {
        , $Repos[$i..([math]::Min($i + $Config.MaxConcurrent - 1, $Repos.Count - 1))]
    }

    foreach ($batch in $batches) {
        $jobs = $batch | ForEach-Object {
            $repo = $_
            Start-Job -ScriptBlock { param($r) Start-Sleep -Milliseconds 500; $r } -ArgumentList $repo
        }
        $jobs | Wait-Job | Remove-Job
        $results += $batch | ForEach-Object { Invoke-SyncRepository $_ }
    }

    return $results
}

# ============ Main ============

$repos = @(
    New-Repository -Id "alpha" -Name "alpha" -Url "https://github.com/user/repo-alpha"
    New-Repository -Id "beta"  -Name "beta"  -Url "https://github.com/user/repo-beta"
    New-Repository -Id "gamma" -Name "gamma" -Url "https://github.com/user/repo-gamma"
)

Write-Host "Starting sync for $($repos.Count) repositories..." -ForegroundColor White
$results = Invoke-SyncAll -Repos $repos

$succeeded = ($results | Where-Object { $_.Success }).Count
$failed    = ($results | Where-Object { -not $_.Success }).Count
Write-Host "`nDone: $succeeded succeeded, $failed failed." -ForegroundColor White
