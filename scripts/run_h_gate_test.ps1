$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$out  = Join-Path $root 'h_gate_test'

Write-Host "[BUILD] iverilog -> $out"
& iverilog -o $out "$root\tb\H_Gate_tb.v" "$root\src\H_Gate.v" "$root\src\FixedPoint_Add.v" "$root\src\FixedPoint_Multiply.v"

Write-Host "[RUN ] vvp $out"
& vvp $out