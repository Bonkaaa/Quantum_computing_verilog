// Testbench for circuit

`timescale 1ns / 1ps

module Circuit_tb;

    initial begin
    $dumpfile("circuit_tb.vcd");
    $dumpvars(0, Circuit_tb);
    end


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

    // Wires for measurement probabilities
    wire signed [31:0] p00, p01, p10, p11;

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
        .final_c11_im(c11_im),

        .prob_00(p00),
        .prob_01(p01),
        .prob_10(p10),
        .prob_11(p11)
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
        repeat (2) @(posedge clk);
        reset = 0;

        $display("-------------------------------");

        $display("Idle State: ", $time);
        $display("   c00=(%h,%h), c01=(%h,%h), c10=(%h,%h), c11=(%h,%h)",
                 c00_re, c00_im, c01_re, c01_im, c10_re, c10_im, c11_re, c11_im); 
             
        // Check initial state |00>
        if (c00_re != FP_ONE || c01_re != FP_ZERO || c10_re != FP_ZERO || c11_re != FP_ZERO)
            $display("[FAIL] Initial state incorrect");

        #10;

        $display("-------------------------------");

        // Start the circuit
        start = 1;
        @(posedge clk);
        start = 0;

        // Clock Cycle 1 (Apply Hadamard)
        @(posedge clk); 
        #1;

        // FSM now in S_HADAMARD, registers updated after Hadamard
        $display("\n@ T=%0t: After H-gate (Immediate State)", $time);
        $display("   c00=(%h,%h), c01=(%h,%h), c10=(%h,%h), c11=(%h,%h)",
                 c00_re, c00_im, c01_re, c01_im, c10_re, c10_im, c11_re, c11_im);
        $display("%h %h %h %h %h %h %h %h",
         c00_re, c00_im, c01_re, c01_im, c10_re, c10_im, c11_re, c11_im);
                 
        // Expected: (1/sqrt(2)) * (|00> + |10>)
        if (c00_re != FP_SQRT_HALF_POS || c01_re != FP_ZERO || c10_re != FP_SQRT_HALF_POS || c11_re != FP_ZERO)
            $display("   [FAIL] H-Gate state incorrect");
        else
            $display("   [CHECK] H-Gate applied correctly");

        $display("-------------------------------");
            
        // Clock Cycle 2 (Apply CNOT)
        @(posedge clk);
        @(posedge clk); 
        #1;
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

        @(posedge clk); 
        // FSM now in S_DONE

        $display("-------------------------------");
        $display("\n@ T=%0t: MEASUREMENT RESULTS (Bell State)", $time);

        // --- MỚI: Hiển thị xác suất ---
        $display("Probabilities (Scale 256 = 1.0):");
        
        // In giá trị thô (Raw Integer)
        $display(" Raw Values: P00=%d, P01=%d, P10=%d, P11=%d", p00, p01, p10, p11);

        // In giá trị thực (Real Float) - Chia cho 256.0
        $display(" Real P(00): %f  (Expected ~0.5)", $itor(p00)/256.0); 
        $display(" Real P(01): %f  (Expected 0.0)",  $itor(p01)/256.0);
        $display(" Real P(10): %f  (Expected 0.0)",  $itor(p10)/256.0);
        $display(" Real P(11): %f  (Expected ~0.5)", $itor(p11)/256.0);

        $display("-------------------------------");

        // Logic kiểm tra cuối cùng: Tổng xác suất ~ 1.0 và đúng trạng thái Bell
        // Bell state chuẩn: P(00) ~ 0.5, P(11) ~ 0.5, còn lại = 0
        if ((p00 + p11 > 250) && (p01 + p10 < 5)) begin
            $display("[SUCCESS] Bell State Measurement Verified!");
            $display("          System implies Entanglement (|00> + |11>).");
        end else begin
            $display("[FAILURE] Measurement incorrect. Total Prob: %f", $itor(p00+p01+p10+p11)/256.0);
        end

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

// Run cmd: powershell -ExecutionPolicy Bypass -File .\scripts\run_circuit_test.ps1

