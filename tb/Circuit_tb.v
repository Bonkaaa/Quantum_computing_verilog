// Testbench for circuit

`timescale 1ns / 1ps

module Circuit_tb;

    // Constants for fixed-point representation
    localparam FP_ZERO = 16'h0000; // Fixed-point representation of 0.0
    localparam FP_ONE = 16'h0100; // Fixed-point representation of 1.0

    localparam FP_SQRT_HALF_POS = 16'h00B5; //  0.707 (181 / 256)

    reg clk;
    reg reset;
    reg start;

    // Output wires for final state
    wire signed [15:0] c00_re, c00_im, c01_re, c01_im,
                       c10_re, c10_im, c11_re, c11_im;

    // Instantiate the Quantum_Circuit module
    Quantum_Circuit dut (
        .clk(clk),
        .reset(reset),
        .start(start),

        .final_c00_re(c00_re),
        .final_c00_im(c00_im),
        .final_c01_re(c01_re),
        .final_c01_im(c01_im),
        .final_c10_re(c10_re),
        .final_c10_im(c10_im),
        .final_c11_re(c11_re),
        .final_c11_im(c11_im)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence

    initial begin
        $display("Starting Circuit Testbench...");
        reset = 1;
        start = 0;
        #15 reset = 0;

        $display("Idle State: ", $time);
        $display("   c00=(%h,%h), c01=(%h,%h), c10=(%h,%h), c11=(%h,%h)",
                 c00_re, c00_im, c01_re, c01_im, c10_re, c10_im, c11_re, c11_im); 
        
        // Check initial state |00>
        if (c00_re != FP_ONE || c10_re != FP_ZERO || c11_re != FP_ZERO)
            $display("[FAIL] Initial state incorrect");

        #10;

        // Start the circuit
        start = 1;
        @(posedge clk);

        // Clock Cycle 1 (Apply Hadamard)
        @(posedge clk); 
        // FSM now in S_HADAMARD, registers updated after Hadamard
        $display("\n@ T=%0t: After H-gate (Immediate State)", $time);
        $display("   c00=(%h,%h), c01=(%h,%h), c10=(%h,%h), c11=(%h,%h)",
                 c00_re, c00_im, c01_re, c01_im, c10_re, c10_im, c11_re, c11_im);
                 
        // Expected: (1/sqrt(2)) * (|00> + |10>)
        if (c00_re != FP_SQRT_HALF_POS || c10_re != FP_SQRT_HALF_POS || c11_re != FP_ZERO)
            $display("[FAIL] H-Gate state incorrect");
        else
            $display("   [CHECK] H-Gate applied correctly");
            
        // Clock Cycle 2 (Apply CNOT)
        @(posedge clk); 
        // FSM now in S_CNOT, registers updated after CNOT
        $display("\n@ T=%0t: After CNOT-Gate (Bell State)", $time);
        $display("   c00=(%h,%h), c01=(%h,%h), c10=(%h,%h), c11=(%h,%h)",
                 c00_re, c00_im, c01_re, c01_im, c10_re, c10_im, c11_re, c11_im);

        // Expected Bell State: (1/sqrt(2)) * (|00> + |11>)
        if (c00_re == FP_SQRT_HALF_POS && c00_im == FP_ZERO &&
            c01_re == FP_ZERO          && c01_im == FP_ZERO &&
            c10_re == FP_ZERO          && c10_im == FP_ZERO &&
            c11_re == FP_SQRT_HALF_POS && c11_im == FP_ZERO)
            $display("   [PASS] Initial Bell state created successfully!");
        else
            $display("   [FAIL] Bell state incorrect");

        // 5. Kết thúc
        #10;
        start = 0; // Tắt start
        $display("\n@ T=%0t: Testbench completed.", $time);
        $finish;

    end
    
endmodule


// Giải thích cho đoạn mã trên:
// 1. Tạo testbench cho mạch lượng tử sử dụng Verilog
// 2. Khởi tạo tín hiệu clock, reset và start
// 3. Kết nối mô-đun Quantum_Circuit với tín hiệu testbench
// 4. Tạo chuỗi kiểm tra để áp dụng cổng Hadamard và CNOT, kiểm tra trạng thái đầu ra
// 5. So sánh trạng thái đầu ra với trạng thái Bell mong đợi và in kết quả kiểm tra
// 6. Kết thúc

// Run cmd: powershell -ExecutionPolicy Bypass -File .\scripts\run_circuit_tb.ps1

