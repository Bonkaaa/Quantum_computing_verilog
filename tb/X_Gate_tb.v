// Testbench for X Gate

`timescale 1ns / 1ps

module X_Gate_tb;

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

    // Instantiate the X_Gate module
    X_Gate dut (
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
        $display("Starting X Gate Testbench...");
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

        #10;

        // Expected Output: |1> state
        $display("  INPUT:  alpha = %h + %hi, beta = %h + %hi", tb_alpha_in_re, tb_alpha_in_im, tb_beta_in_re, tb_beta_in_im);
        $display("  OUTPUT: alpha = %h + %hi, beta = %h + %hi", tb_alpha_out_re, tb_alpha_out_im, tb_beta_out_re, tb_beta_out_im);

        if (tb_alpha_out_re == FP_ZERO && tb_beta_out_re  == FP_ONE) begin
            $display("  PASS: |0> transformed to |1>");
        end else begin
            $display("  FAIL: Unexpected output for |0> input");
        end

        // Test Case 2: Input |1> state
        $display("Test Case 2: Input |1> state");
        tb_alpha_in_re <= FP_ZERO;
        tb_alpha_in_im <= FP_ZERO;   // FIX: was FP_ONE
        tb_beta_in_re  <= FP_ONE;    // FIX: drive |1>
        tb_beta_in_im  <= FP_ZERO;

        #10;

        // Expected Output: |0> state
        $display("  INPUT:  alpha = %h + %hi, beta = %h + %hi", tb_alpha_in_re, tb_alpha_in_im, tb_beta_in_re, tb_beta_in_im);
        $display("  OUTPUT: alpha = %h + %hi, beta = %h + %hi", tb_alpha_out_re, tb_alpha_out_im, tb_beta_out_re, tb_beta_out_im);

        if (tb_alpha_out_re == FP_ONE && tb_beta_out_re  == FP_ZERO &&
            tb_alpha_out_im == FP_ZERO && tb_beta_out_im == FP_ZERO) begin
            $display("  PASS: |1> transformed to |0>");
        end else begin
            $display("  FAIL: Unexpected output for |1> input");
        end

        // Test Case 3: Input complex state
        $display("Test Case 3: Input complex state");
        tb_alpha_in_re <= FP_A_RE;
        tb_alpha_in_im <= FP_A_IM;
        tb_beta_in_re  <= FP_B_RE;
        tb_beta_in_im  <= FP_B_IM;

        #10;

        // Expected Output: Swapped amplitudes
        $display("  INPUT:  alpha = %h + %hi, beta = %h + %hi", tb_alpha_in_re, tb_alpha_in_im, tb_beta_in_re, tb_beta_in_im);
        $display("  OUTPUT: alpha = %h + %hi, beta = %h + %hi", tb_alpha_out_re, tb_alpha_out_im, tb_beta_out_re, tb_beta_out_im);

        if (tb_alpha_out_re == FP_B_RE && tb_alpha_out_im == FP_B_IM &&
            tb_beta_out_re  == FP_A_RE && tb_beta_out_im  == FP_A_IM) begin
            $display("  PASS: Complex state amplitudes swapped correctly");
        end else begin
            $display("  FAIL: Unexpected output for complex input");
        end

        // End of test
        #10;
        $display("X Gate Testbench completed.");
        $finish;
    end

endmodule

// Giải thích cho đoạn mã trên:
// 1. Tạo một testbench để kiểm tra chức năng của cổng X (Pauli-X)
// 2. Định nghĩa các hằng số cố định cho các trạng thái qubit trong định dạng Q8.8
// 3. Tạo tín hiệu clock và reset
// 4. Định nghĩa các tín hiệu đầu vào và đầu ra cho trạng thái qubit
// 5. Tạo các trường hợp kiểm tra khác nhau bao gồm |0>, |1> và trạng thái phức
// 6. So sánh kết quả đầu ra với kết quả mong đợi và hiển thị thông báo PASS/FAIL tương ứng
// 7. Kết thúc quá trình kiểm tra sau khi hoàn thành tất cả các trường hợp kiểm tra

// Run cmd: powershell -ExecutionPolicy Bypass -File .\scripts\run_x_gate_tb.ps1