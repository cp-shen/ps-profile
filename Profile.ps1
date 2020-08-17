# enable fzf integration
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# enable vcvars64
cmd.exe /c "call `"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat`" && set > %temp%\vcvars.txt"
Get-Content "$env:temp\vcvars.txt" | Foreach-Object {
  if ($_ -match "^(.*?)=(.*)$") {
    Set-Content "env:\$($matches[1])" $matches[2]
  }
}