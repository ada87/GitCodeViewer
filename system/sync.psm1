Set-StrictMode -Version Latest

function Test-GitCommand {
    return $null -ne (Get-Command git -ErrorAction SilentlyContinue)
}

function Resolve-RepoPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Workspace,
        [Parameter(Mandatory)][string] $Name
    )

    return Join-Path $Workspace $Name
}

function Get-RepoState {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string] $Path)

    if (-not (Test-Path (Join-Path $Path '.git'))) {
        return [pscustomobject]@{
            Path = $Path
            Branch = $null
            Ahead = 0
            Behind = 0
            Dirty = $false
            Missing = $true
        }
    }

    $branch = (git -C $Path rev-parse --abbrev-ref HEAD).Trim()
    $status = git -C $Path status --short --branch
    $dirty = ($status | Select-Object -Skip 1 | Measure-Object).Count -gt 0
    $ahead = 0
    $behind = 0

    if ($status[0] -match 'ahead (\d+)') { $ahead = [int]$Matches[1] }
    if ($status[0] -match 'behind (\d+)') { $behind = [int]$Matches[1] }

    return [pscustomobject]@{
        Path = $Path
        Branch = $branch
        Ahead = $ahead
        Behind = $behind
        Dirty = $dirty
        Missing = $false
    }
}

function Get-RepoSummary {
    [CmdletBinding()]
    param([Parameter(Mandatory)][object[]] $InputObject)

    $missing = @($InputObject | Where-Object Missing).Count
    $dirty = @($InputObject | Where-Object Dirty).Count
    $ahead = ($InputObject | Measure-Object -Property Ahead -Sum).Sum
    $behind = ($InputObject | Measure-Object -Property Behind -Sum).Sum

    [pscustomobject]@{
        Count = $InputObject.Count
        Missing = $missing
        Dirty = $dirty
        Ahead = $ahead
        Behind = $behind
    }
}

function Invoke-RepoFetch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Path,
        [string] $Remote = 'origin'
    )

    if (-not (Test-Path (Join-Path $Path '.git'))) {
        return $false
    }

    git -C $Path fetch $Remote --prune | Out-Null
    return $LASTEXITCODE -eq 0
}

function Sync-RepoSet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Workspace,
        [Parameter(Mandatory)][string[]] $Repositories,
        [switch] $FetchOnly
    )

    if (-not (Test-GitCommand)) {
        throw 'git is not available on PATH'
    }

    $results = New-Object System.Collections.Generic.List[object]

    foreach ($name in $Repositories) {
        $path = Resolve-RepoPath -Workspace $Workspace -Name $name
        $state = Get-RepoState -Path $path

        if (-not $state.Missing -and $FetchOnly) {
            [void](Invoke-RepoFetch -Path $path)
            $state = Get-RepoState -Path $path
        }

        $results.Add([pscustomobject]@{
            Name = $name
            Path = $path
            Branch = $state.Branch
            Ahead = $state.Ahead
            Behind = $state.Behind
            Dirty = $state.Dirty
            Missing = $state.Missing
        })
    }

    return $results
}

function Write-SyncReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object[]] $InputObject,
        [Parameter(Mandatory)][string] $Path
    )

    $lines = @('# Repo Sync Report', '')
    $summary = Get-RepoSummary -InputObject $InputObject
    $lines += "- repos: $($summary.Count)"
    $lines += "- dirty: $($summary.Dirty)"
    $lines += "- missing: $($summary.Missing)"
    $lines += "- ahead: $($summary.Ahead)"
    $lines += "- behind: $($summary.Behind)"
    $lines += ''

    foreach ($row in $InputObject) {
        $branch = if ($row.Branch) { $row.Branch } else { 'n/a' }
        $state = if ($row.Missing) { 'missing' } elseif ($row.Dirty) { 'dirty' } else { 'clean' }
        $lines += "- $($row.Name): $branch, $state, +$($row.Ahead)/-$($row.Behind)"
    }

    Set-Content -Path $Path -Value $lines
    return $Path
}

Export-ModuleMember -Function Get-RepoState, Get-RepoSummary, Invoke-RepoFetch, Sync-RepoSet, Write-SyncReport
