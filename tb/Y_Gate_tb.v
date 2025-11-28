// Testbench for Y_Gate

`timescale 1ns / 1ps

module Y_Gate_tb;

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

    // Instantiate the Y_Gate module
    Y_Gate dut (
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
        $display("Starting Y Gate Testbench...");
        reset = 1;

        // Initial State
        tb_alpha_in_re <= FP_ZERO;  
        tb_alpha_in_im <= FP_ZERO;
        tb_beta_in_re  <= FP_ZERO;
        tb_beta_in_im  <= FP_ZERO;
        #10;

        $display("-------------------------------");

        // Test Case 1: Apply Y gate to |0> state
        tb_alpha_in_re <= FP_ONE;
        tb_alpha_in_im <= FP_ZERO;
        tb_beta_in_re  <= FP_ZERO;
        tb_beta_in_im  <= FP_ZERO;
        #10;
        $display("Test Case 1: Input |0> state");
        $display("Output Alpha: %h + %hi", tb_alpha_out_re, tb_alpha_out_im);
        $display("Output Beta:  %h + %hi", tb_beta_out_re, tb_beta_out_im);

        if (tb_alpha_out_re == FP_ZERO && tb_alpha_out_im == FP_ZERO &&
            tb_beta_out_re == FP_ZERO && tb_beta_out_im == FP_ONE) begin
            $display("  Test Case 1 Passed!");
        end else begin
            $display("  Test Case 1 Failed!");
        end
        // Expected Output: i|1> state

        $display("-------------------------------");

        // Test Case 2: Apply Y gate to |1> state
        tb_alpha_in_re <= FP_ZERO;
        tb_alpha_in_im <= FP_ZERO;
        tb_beta_in_re  <= FP_ONE;
        tb_beta_in_im  <= FP_ZERO;
        #10;
        $display("Test Case 2: Input |1> state");
        $display("Output Alpha: %h + %hi", tb_alpha_out_re, tb_alpha_out_im);
        $display("Output Beta:  %h + %hi", tb_beta_out_re, tb_beta_out_im);
        // Expected Output: -i|0> state
        if (tb_alpha_out_re == FP_ZERO && tb_alpha_out_im == -FP_ONE &&
            tb_beta_out_re == FP_ZERO && tb_beta_out_im == FP_ZERO) begin
            $display("  Test Case 2 Passed!");
        end else begin
            $display("  Test Case 2 Failed!");
        end

        $display("-------------------------------");

        // Test Case 3: Apply Y gate to superposition state
        tb_alpha_in_re <= FP_A_RE;
        tb_alpha_in_im <= FP_A_IM;
        tb_beta_in_re  <= FP_B_RE;
        tb_beta_in_im  <= FP_B_IM;
        #10;
        $display("Test Case 3: Input Superposition state");
        $display("Output Alpha: %h + %hi", tb_alpha_out_re, tb_alpha_out_im);
        $display("Output Beta:  %h + %hi", tb_beta_out_re, tb_beta_out_im);
        // Expected Output: Calculated based on Y gate transformation
        if (tb_alpha_out_re == FP_B_IM && tb_alpha_out_im == -FP_B_RE &&
            tb_beta_out_re == -FP_A_IM && tb_beta_out_im == FP_A_RE) begin
            $display("  Test Case 3 Passed!");
        end else begin
            $display("  Test Case 3 Failed!");
        end

        $display("-------------------------------");


        $display("Y Gate Testbench Completed.");
        $finish;
    end
endmodule

// Run cmd: powershell -ExecutionPolicy Bypass -File .\scripts\run_y_gate_test.ps1