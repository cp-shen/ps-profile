$env:RUSTUP_DIST_SERVER="https://mirrors.tuna.tsinghua.edu.cn/rustup"
$env:VCPKG_DEFAULT_TRIPLET="x64-windows"

# enable git integratin
Import-Module posh-git

# enable fzf integration
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# shortcut for vcvars64
function load-vcvars64 {
  if (Test-Path -Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community") {
    cmd.exe /c "call `"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat`" && set > %temp%\vcvars.txt"
  }
  elseif (Test-Path -Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise") {
    cmd.exe /c "call `"C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvars64.bat`" && set > %temp%\vcvars.txt"
  }
  else {
    echo "vcvars64.bat not found."
    return
  }

  Get-Content "$env:temp\vcvars.txt" | Foreach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
      Set-Content "env:\$($matches[1])" $matches[2]
    }
  }
}

# shortcut function to make a symlink
function make-link ($target, $link) {
  New-Item -Path $link -ItemType SymbolicLink -Value $target
}

function reload-profile {
  @(
    $Profile.AllUsersAllHosts,
    $Profile.AllUsersCurrentHost,
    $Profile.CurrentUserAllHosts,
    $Profile.CurrentUserCurrentHost
  ) | % {
    if (Test-Path $_) {
      Write-Verbose "Running $_"
      . $_
    }
  }
}

function reload-lua ($target) {
  if (Test-Path -Path $target -PathType leaf -Filter "*.lua") {
    $fullPath = Resolve-Path $target
    echo "Running $fullPath"
    Start-Process -FilePath "CodeHelper.exe" -ArgumentList "reload", "127.0.0.1", "23191", "auto", $fullPath
  }
  else {
    echo "$target is not a lua file"
  }
}
