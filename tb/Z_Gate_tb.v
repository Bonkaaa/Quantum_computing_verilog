// Testbench for Z Gate

`timescale 1ns / 1ps

module Z_Gate_tb;

    // Constants for fixed-point representation
    localparam FP_ZERO = 16'h0000; // Fixed-point representation of 0.0
    localparam FP_ONE = 16'h0100; // Fixed-point representation of 1.0

    // Test input qubit state
    localparam FP_A_RE = 16'h0080; //  0.5
    localparam FP_A_IM = 16'hFF80; // -0.5 (số bù 2)
    localparam FP_B_RE = 16'h0040; //  0.25
    localparam FP_B_IM = 16'h00C0; //  0.75

    // Clock and reset
    reg clk;
    reg reset;

    // Input 
    reg signed [15:0] tb_alpha_in_re;
    reg signed [15:0] tb_alpha_in_im;
    reg signed [15:0] tb_beta_in_re;
    reg signed [15:0] tb_beta_in_im;

    // Output
    wire signed [15:0] tb_alpha_out_re;
    wire signed [15:0] tb_alpha_out_im;
    wire signed [15:0] tb_beta_out_re;
    wire signed [15:0] tb_beta_out_im;

    // Instantiate the Z_Gate module
    Z_Gate dut (
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
        $display("Starting Z Gate Testbench...");
        reset = 1;

        // Initial State
        tb_alpha_in_re <= FP_ZERO;  
        tb_alpha_in_im <= FP_ZERO;
        tb_beta_in_re  <= FP_ZERO;  
        tb_beta_in_im  <= FP_ZERO;
        #10;

        $display("-------------------------------");

        // Test Case 1: Input arbitrary state
        $display("Test Case 1: Input arbitrary state");
        tb_alpha_in_re <= FP_A_RE;
        tb_alpha_in_im <= FP_A_IM;
        tb_beta_in_re  <= FP_B_RE;
        tb_beta_in_im  <= FP_B_IM;
        #10;
        $display("  INPUT:  alpha = %h + %hi, beta = %h + %hi", 
                 tb_alpha_in_re, tb_alpha_in_im, tb_beta_in_re, tb_beta_in_im);
        $display("  OUTPUT: alpha = %h + %hi, beta = %h + %hi", 
                 tb_alpha_out_re, tb_alpha_out_im, tb_beta_out_re, tb_beta_out_im);
        if (tb_alpha_out_re == FP_A_RE && tb_alpha_out_im == FP_A_IM &&
            tb_beta_out_re  == -FP_B_RE && tb_beta_out_im  == -FP_B_IM) begin
            $display("  Test Case 1 Passed!");
        end else begin
            $display("  Test Case 1 Failed!");
        end

        $display("-------------------------------");

        // Add more test cases as needed
        $display("Z Gate Testbench Completed.");
        $finish;
    end
endmodule

// Run cmd: powershell -ExecutionPolicy Bypass -File .\scripts\run_z_gate_test.ps1