$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$out  = Join-Path $root 'circuit_test'
$tb   = Join-Path $root 'tb\Circuit_tb.v'
$srcs = @(
  (Join-Path $root 'src\Quantum_Circuit.v'),
  (Join-Path $root 'src\FixedPoint_Add.v'),
  (Join-Path $root 'src\FixedPoint_Multiply.v')
)

function Find-Tool([string]$name, [string]$fallback) {
  $cmd = Get-Command $name -ErrorAction SilentlyContinue
  if ($null -ne $cmd) { return $cmd.Source }
  if (Test-Path $fallback) { return $fallback }
  throw "$name not found in PATH or at $fallback"
}

$iverilog = Find-Tool 'iverilog' 'C:\iverilog\bin\iverilog.exe'
$vvp      = Find-Tool 'vvp'      'C:\iverilog\bin\vvp.exe'

Write-Host "[BUILD] iverilog -g2012 -> $out"
& "$iverilog" -g2012 -o "$out" "$tb" $srcs

Write-Host "[RUN  ] vvp $out"
& "$vvp" "$out"