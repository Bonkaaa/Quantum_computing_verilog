// Testbench for Hadamard Gate

`timescale 1ns / 1ps

module H_Gate_tb;

    // Constants for fixed-point representation
    localparam FP_ZERO = 16'h0000; // Fixed-point representation of 0.0
    localparam FP_ONE = 16'h0100; // Fixed-point representation of 1.0

    // Expected fixed-point constant for 1/sqrt(2)
    localparam FP_SQRT_HALF_POS = 16'h00B5; //  0.707 (181 / 256)
    localparam FP_SQRT_HALF_NEG = 16'hFF4B; // -0.707 (-181 / 256)

    reg clk;
    reg reset;

    // Input qubit state
    reg signed [15:0] tb_alpha_in_re;
    reg signed [15:0] tb_alpha_in_im;
    reg signed [15:0] tb_beta_in_re;
    reg signed [15:0] tb_beta_in_im;

    // Output qubit state
    wire signed [15:0] tb_alpha_out_re;
    wire signed [15:0] tb_alpha_out_im;
    wire signed [15:0] tb_beta_out_re;
    wire signed [15:0] tb_beta_out_im;

    // Instantiate the H_Gate module
    H_Gate dut (
        .alpha_re(tb_alpha_in_re),
        .alpha_im(tb_alpha_in_im),
        .beta_re(tb_beta_in_re),
        .beta_im(tb_beta_in_im),

        .out_alpha_re(tb_alpha_out_re),
        .out_alpha_im(tb_alpha_out_im),
        .out_beta_re(tb_beta_out_re),
        .out_beta_im(tb_beta_out_im)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        $display("Starting Hadamard Gate Testbench...");
        reset = 1;

        // Initial State
        tb_alpha_in_re <= FP_ZERO;  
        tb_alpha_in_im <= FP_ZERO;
        tb_beta_in_re  <= FP_ZERO;
        tb_beta_in_im  <= FP_ZERO;
        #10 reset = 0;

        // Test Case 1: Input |0> state
        $display("Test Case 1: Input |0> state");
        tb_alpha_in_re <= FP_ONE;  // |0> state
        tb_alpha_in_im <= FP_ZERO;
        tb_beta_in_re  <= FP_ZERO;
        tb_beta_in_im  <= FP_ZERO;
        #10;

        // Expected Output: (|0> + |1>)/sqrt(2)
        $display("  INPUT:  alpha = %h + %hi, beta = %h + %hi", tb_alpha_in_re, tb_alpha_in_im, tb_beta_in_re, tb_beta_in_im);
        $display("  OUTPUT: alpha = %h + %hi, beta = %h + %hi", tb_alpha_out_re, tb_alpha_out_im, tb_beta_out_re, tb_beta_out_im);

        if (tb_alpha_out_re == FP_SQRT_HALF_POS && tb_beta_out_re  == FP_SQRT_HALF_POS) begin
            $display("   [PASS] Test H|0> passed!");
        end else begin
            $display("  [FAIL] Test H|0> failed!");
        end

        // Test Case 2: Input |1> state
        $display("Test Case 2: Input |1> state");
        tb_alpha_in_re <= FP_ZERO;
        tb_alpha_in_im <= FP_ZERO;
        tb_beta_in_re  <= FP_ONE;  // |1> state
        tb_beta_in_im  <= FP_ZERO;

        #10;

        // Expected Output: (|0> - |1>)/sqrt(2)
        $display("  INPUT:  alpha = %h + %hi, beta = %h + %hi", tb_alpha_in_re, tb_alpha_in_im, tb_beta_in_re, tb_beta_in_im);
        $display("  OUTPUT: alpha = %h + %hi, beta = %h + %hi", tb_alpha_out_re, tb_alpha_out_im, tb_beta_out_re, tb_beta_out_im);

        if (tb_alpha_out_re == FP_SQRT_HALF_POS && tb_beta_out_re  == FP_SQRT_HALF_NEG) begin
            $display("  [PASS] Test H|1> passed!");
        end else begin
            $display("  [FAIL] Test H|1> failed! Expected beta_re: %h", FP_SQRT_HALF_NEG);
        end

        // End
        #10;
        $display("Hadamard Gate Testbench Completed.");
        $finish;
    end

endmodule

// Giải thích cho đoạn mã trên:
// 1. Tạo một testbench để kiểm tra chức năng của cổng Hadamard
// 2. Định nghĩa các hằng số cố định cho 0.0, 1.0 và 1/sqrt(2) trong định dạng Q8.8
// 3. Tạo tín hiệu clock và reset
// 4. Định nghĩa các tín hiệu đầu vào và đầu ra cho trạng thái qubit
// 5. Khởi tạo module H_Gate và kết nối các tín hiệu
// 6. Tạo chuỗi kiểm tra với hai trường hợp: đầu vào |0> và |1>
// 7. So sánh kết quả đầu ra với giá trị mong đợi và in kết quả kiểm tra
// 8. Kết thúc testbench sau khi hoàn thành các kiểm tra

// Run cmd: powershell -ExecutionPolicy Bypass -File .\scripts\run_h_gate_tb.ps1