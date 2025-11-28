// Testbench for measurement module

`timescale 1ns / 1ps

module Measurement_tb;
    // Constants for fixed-point representation
    localparam FP_ZERO = 16'h0000; // Fixed-point representation of 0.0
    localparam FP_ONE = 16'h0100; // Fixed-point representation of 1.0

    // Test input qubit state
    localparam FP_A_RE = 16'h00B5; 
    localparam FP_A_IM = 16'h0000;
    localparam FP_B_RE = 16'h00B5;
    localparam FP_B_IM = 16'h0000;

    // Clock and reset
    reg clk;
    reg reset;

    // Input 
    reg signed [15:0] tb_alpha_in_re;
    reg signed [15:0] tb_alpha_in_im;
    reg signed [15:0] tb_beta_in_re;
    reg signed [15:0] tb_beta_in_im;

    // Output
    wire signed [31:0] p0, p1;

    // Instantiate the Measurement module
    Measurement dut (
        .alpha_re(tb_alpha_in_re),
        .alpha_im(tb_alpha_in_im),
        .beta_re(tb_beta_in_re),
        .beta_im(tb_beta_in_im),

        .prob_0(p0),
        .prob_1(p1)
    );

    initial begin
        $display("Starting Measurement Testbench...");
        
        // Initial State: 1/sqrt(2) |0> + 1/sqrt(2) |1>
        tb_alpha_in_re = FP_A_RE;  
        tb_alpha_in_im = FP_A_IM;
        tb_beta_in_re  = FP_B_RE;
        tb_beta_in_im  = FP_B_IM;

        #10; // Wait for logic to settle

        $display("--------------------------------------------------");
        $display("Input Hex: alpha = %h + %hi, beta = %h + %hi",
                 tb_alpha_in_re, tb_alpha_in_im,
                 tb_beta_in_re, tb_beta_in_im);
        
        // SỬA: Dùng %f cho số thực và dùng đúng tên biến p0, p1
        $display("Output Raw (Q1.14): P(0) = %d, P(1) = %d", p0, p1);
        $display("Output Real       : P(0) = %f, P(1) = %f", 
                 $itor(p0)/256.0, 
                 $itor(p1)/256.0);
        $display("--------------------------------------------------");

        // Kiểm tra tổng xác suất (nên gần bằng 1.0)
        if (p0 + p1 > 250 && p0 + p1 < 260) 
            $display("TEST PASSED: Total probability is approx 1.0");
        else
            $display("TEST FAILED: Total probability is %f", $itor(p0 + p1)/256.0);

        $finish;
    end

endmodule

// Run cmd: powershell -ExecutionPolicy Bypass -File .\scripts\run_measurement_test.ps1