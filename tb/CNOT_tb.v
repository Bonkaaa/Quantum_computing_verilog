// Testbench for CNOT gate

`timescale 1ns / 1ps

module CNOT_tb;

    // Constants for fixed-point representation
    localparam FP_ZERO = 16'h0000; // Fixed-point representation of 0.0
    localparam FP_ONE = 16'h0100; // Fixed-point representation of 1.0

    // Test input qubit states
    localparam FP_C00_RE = 16'h0080; //  0.5
    localparam FP_C00_IM = 16'hFF80; // -0.5 (two's complement)
    localparam FP_C01_RE = 16'h0040; //  0.25
    localparam FP_C01_IM = 16'h00C0; //  0.75
    localparam FP_C10_RE = 16'h00A0; //  0.625
    localparam FP_C10_IM = 16'hFF60; // -0.375
    localparam FP_C11_RE = 16'h0020; //  0.125
    localparam FP_C11_IM = 16'h0060; //  0.375

    // Clock and reset
    reg clk;
    reg reset;

    // Input qubit states
    reg signed [15:0] tb_c00_in_re;
    reg signed [15:0] tb_c00_in_im;
    reg signed [15:0] tb_c01_in_re;
    reg signed [15:0] tb_c01_in_im;
    reg signed [15:0] tb_c10_in_re;
    reg signed [15:0] tb_c10_in_im;
    reg signed [15:0] tb_c11_in_re;
    reg signed [15:0] tb_c11_in_im;

    // Output qubit states
    wire signed [15:0] tb_c00_out_re;
    wire signed [15:0] tb_c00_out_im;
    wire signed [15:0] tb_c01_out_re;
    wire signed [15:0] tb_c01_out_im;
    wire signed [15:0] tb_c10_out_re;
    wire signed [15:0] tb_c10_out_im;
    wire signed [15:0] tb_c11_out_re;
    wire signed [15:0] tb_c11_out_im;

    // Instantiate the CNOT_Gate module
    CNOT_Gate dut (
        .c00_in_re(tb_c00_in_re),
        .c00_in_im(tb_c00_in_im),
        .c01_in_re(tb_c01_in_re),
        .c01_in_im(tb_c01_in_im),
        .c10_in_re(tb_c10_in_re),
        .c10_in_im(tb_c10_in_im),
        .c11_in_re(tb_c11_in_re),
        .c11_in_im(tb_c11_in_im),

        .c00_out_re(tb_c00_out_re),
        .c00_out_im(tb_c00_out_im),
        .c01_out_re(tb_c01_out_re),
        .c01_out_im(tb_c01_out_im),
        .c10_out_re(tb_c10_out_re),
        .c10_out_im(tb_c10_out_im),
        .c11_out_re(tb_c11_out_re),
        .c11_out_im(tb_c11_out_im)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        $display("Starting CNOT Gate Testbench...");
        reset = 1;

        // Initial State
        tb_c00_in_re <= FP_ZERO;  
        tb_c00_in_im <= FP_ZERO;
        tb_c01_in_re <= FP_ZERO;  
        tb_c01_in_im <= FP_ZERO;
        tb_c10_in_re <= FP_ZERO;  
        tb_c10_in_im <= FP_ZERO;
        tb_c11_in_re <= FP_ZERO;  
        tb_c11_in_im <= FP_ZERO;
        #10 reset = 0;

        // Test Case 1: Input arbitrary state
        $display("Test Case 1: Input arbitrary state");
        tb_c00_in_re <= FP_C00_RE;  
        tb_c00_in_im <= FP_C00_IM;
        tb_c01_in_re <= FP_C01_RE;  
        tb_c01_in_im <= FP_C01_IM;
        tb_c10_in_re <= FP_C10_RE;  
        tb_c10_in_im <= FP_C10_IM;
        tb_c11_in_re <= FP_C11_RE;  
        tb_c11_in_im <= FP_C11_IM;
        #10;

        // Expected Output: CNOT operation
        $display("  INPUT:  c00 = %h + %hi, c01 = %h + %hi, c10 = %h + %hi, c11 = %h + %hi",
                 tb_c00_in_re, tb_c00_in_im, tb_c01_in_re, tb_c01_in_im,
                 tb_c10_in_re, tb_c10_in_im, tb_c11_in_re, tb_c11_in_im);
        $display("  OUTPUT: c00 = %h + %hi, c01 = %h + %hi, c10 = %h + %hi, c11 = %h + %hi",
                 tb_c00_out_re, tb_c00_out_im, tb_c01_out_re, tb_c01_out_im,
                 tb_c10_out_re, tb_c10_out_im, tb_c11_out_re, tb_c11_out_im);

        // Add more test cases as needed

        $display("CNOT Gate Testbench Completed.");
        $finish;
    end

endmodule

// Giải thích mã:
// 1. Định nghĩa các tham số cố định để biểu diễn số thực dưới dạng số nguyên có dấu với định dạng điểm cố định.
// 2. Tạo tín hiệu clock và reset.
// 3. Khởi tạo các trạng thái qubit đầu vào và đầu ra.
// 4. Tạo một chuỗi kiểm tra để áp dụng các trạng thái qubit đầu vào khác nhau và kiểm tra kết quả đầu ra sau khi áp dụng cổng CNOT.
// 5. In ra trạng thái đầu vào và đầu ra để kiểm tra tính đúng đắn của cổng CNOT.
// 6. Kết thúc quá trình kiểm tra sau khi hoàn thành tất cả các trường hợp kiểm tra.

// Run cmd: powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\run_cnot_test.ps1"