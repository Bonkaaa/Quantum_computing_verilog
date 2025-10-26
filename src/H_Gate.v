// Module for Hadamard Gate
// Input: Qubit state (alpha, beta)
// Output: Transformed qubit state after applying Hadamard gate
// Formula:
// |0> -> (|0> + |1>)/sqrt(2) => alpha_out = (alpha + beta)/sqrt(2)
// |1> -> (|0> - |1>)/sqrt(2) => beta_out  = (alpha - beta)/sqrt(2)

module H_Gate (
    input wire [15:0] alpha_re, // Real part of alpha
    input wire [15:0] alpha_im, // Imaginary part of alpha
    input wire [15:0] beta_re,  // Real part of beta
    input wire [15:0] beta_im,  // Imaginary part of beta

    output wire [15:0] out_alpha_re, // Output real part of alpha
    output wire [15:0] out_alpha_im, // Output imaginary part of alpha
    output wire [15:0] out_beta_re,  // Output real part of beta
    output wire [15:0] out_beta_im   // Output imaginary part of beta
);

    // Fixed-point constant for 1/sqrt(2) in Q8.8 format
    localparam FP_INV_SQRT2 = 16'h00B5; // Approx. 0.7071 in Q8.8

    // Intermediate signals

    // Sum and Difference of amplitudes
    wire [15:0] sum_re;
    wire [15:0] sum_im;

    wire [15:0] diff_re;
    wire [15:0] diff_im;

    // Stage 1: Perform addition and subtraction

    // sum = alpha + beta
    FixedPoint_Add add_sum_re (
        .A(alpha_re),
        .B(beta_re),
        .sub_en(1'b1), // Addition
        .Sum(sum_re)
    );
    FixedPoint_Add add_sum_im (
        .A(alpha_im),
        .B(beta_im),
        .sub_en(1'b1), // Addition
        .Sum(sum_im)
    );

    // diff = alpha - beta
    FixedPoint_Add add_diff_re (
        .A(alpha_re),
        .B(beta_re),
        .sub_en(1'b0), // Subtraction
        .Sum(diff_re)
    );
    FixedPoint_Add add_diff_im (
        .A(alpha_im),
        .B(beta_im),
        .sub_en(1'b0), // Subtraction
        .Sum(diff_im)
    );

    // Stage 2: Multiply by 1/sqrt(2)

    // out_alpha = sum / sqrt(2)
    FixedPoint_Multiply mult_alpha_re (
        .A(sum_re),
        .B(FP_INV_SQRT2),
        .result(out_alpha_re)
    );
    FixedPoint_Multiply mult_alpha_im (
        .A(sum_im),
        .B(FP_INV_SQRT2),
        .result(out_alpha_im)
    );

    // out_beta = diff / sqrt(2)
    FixedPoint_Multiply mult_beta_re (
        .A(diff_re),
        .B(FP_INV_SQRT2),
        .result(out_beta_re)
    );
    FixedPoint_Multiply mult_beta_im (
        .A(diff_im),
        .B(FP_INV_SQRT2),
        .result(out_beta_im)
    );

endmodule

// Giải thích cho đoạn mã trên:
// 1. Định nghĩa hằng số cố định cho 1/sqrt(2) trong định dạng Q8.8
// 2. Sử dụng module FixedPoint_Add để tính tổng và hiệu của các biên độ alpha và beta
// 3. Sử dụng module FixedPoint_Multiply để nhân kết quả với 1/sqrt(2)
// 4. Kết quả cuối cùng là trạng thái mới của qubit sau khi áp dụng cổng Hadamard



    