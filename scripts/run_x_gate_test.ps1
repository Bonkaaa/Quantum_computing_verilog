$ErrorActionPreference = 'Stop'

# Resolve paths
$root = Split-Path -Parent $PSScriptRoot
$out  = Join-Path $root 'x_gate_test'
$tb   = Join-Path $root 'tb\X_Gate_tb.v'
$srcs = @(
  (Join-Path $root 'src\X_Gate.v')
)

# Locate tools (PATH or default install dir)
function Find-Tool([string]$name, [string]$fallback) {
  $cmd = Get-Command $name -ErrorAction SilentlyContinue
  if ($null -ne $cmd) { return $cmd.Source }
  if (Test-Path $fallback) { return $fallback }
  throw "$name not found in PATH or at $fallback"
}

$iverilog = Find-Tool 'iverilog' 'C:\iverilog\bin\iverilog.exe'
$vvp      = Find-Tool 'vvp'      'C:\iverilog\bin\vvp.exe'

Write-Host "[BUILD] iverilog -> $out"
& "$iverilog" -o "$out" "$tb" $srcs

Write-Host "[RUN  ] vvp $out"
& "$vvp" "$out"