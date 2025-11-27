# Build and run the CNOT testbench (Icarus Verilog)
$repoRoot = Resolve-Path "$PSScriptRoot\.."

$tb = Join-Path $repoRoot "tb\CNOT_tb.v"
$sources = @(
    (Join-Path $repoRoot "src\CNOT_Gate.v"),
    (Join-Path $repoRoot "src\FixedPoint_Add.v"),
    (Join-Path $repoRoot "src\FixedPoint_Multiply.v")
)
$outExe = Join-Path $repoRoot "cnot_test"
$vcdFile = Join-Path $repoRoot "cnot_tb.vcd"

# Check tools
if (-not (Get-Command iverilog -ErrorAction SilentlyContinue)) {
    Write-Error "iverilog not found. Install Icarus Verilog and add it to PATH."
    exit 1
}
if (-not (Get-Command vvp -ErrorAction SilentlyContinue)) {
    Write-Error "vvp not found. Install Icarus Verilog and add it to PATH."
    exit 1
}

# Build
$cmd = @("iverilog", "-g2012", "-o", $outExe, $tb) + $sources
Write-Output "Running: $($cmd -join ' ')"

# create full argument list and pass it as a single parameter to Start-Process
$argList = @("-g2012", "-o", $outExe, $tb) + $sources
$proc = Start-Process -FilePath "iverilog" -ArgumentList $argList -NoNewWindow -Wait -PassThru
if ($proc.ExitCode -ne 0) {
    Write-Error "iverilog failed with exit code $($proc.ExitCode)."
    exit $proc.ExitCode
}

# Run simulation
Write-Output "Running simulation..."
$vvpProc = Start-Process -FilePath vvp -ArgumentList $outExe -NoNewWindow -Wait -PassThru
if ($vvpProc.ExitCode -ne 0) {
    Write-Error "vvp failed with exit code $($vvpProc.ExitCode)."
    exit $vvpProc.ExitCode
}

Write-Output "Simulation finished. VCD (if generated): $vcdFile"