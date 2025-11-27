// Module for Y Gate (Pauli-Y Gate)
// Input: Qubit state (alpha, beta)
// Output: Transformed qubit state after applying Y gate
// Matrix: Y = [[0, -i], [i, 0]]
// Formula:
// |psi_out> = Y * |psi_in>
// alpha_out = -i * beta
// beta_out  =  i * alpha

module Y_Gate (
    input wire [15:0] alpha_re, // Real part of alpha
    input wire [15:0] alpha_im, // Imaginary part of alpha
    input wire [15:0] beta_re,  // Real part of beta
    input wire [15:0] beta_im,  // Imaginary part of beta

    output wire [15:0] out_alpha_re, // Output real part of alpha
    output wire [15:0] out_alpha_im, // Output imaginary part of alpha
    output wire [15:0] out_beta_re,  // Output real part of beta
    output wire [15:0] out_beta_im   // Output imaginary part of beta
);

    // Y gate applies a phase shift of ±90 degrees (multiplication by ±i)
    // |0> -> i|1>  => alpha_out = -i * beta
    assign out_alpha_re = beta_im;      // Real part = Old imaginary part
    assign out_alpha_im = -beta_re;     // Imaginary part = - Old real part

    // |1> -> -i|0> => beta_out  = i * alpha
    assign out_beta_re  = -alpha_im;    // real part = - Old imaginary part
    assign out_beta_im  = alpha_re;     // imaginary part = Old real part

endmodule

// Giải thích cho đoạn mã trên:
// 1. Cổng Y (Pauli-Y) áp dụng một pha ±90 độ cho trạng thái qubit
// 2. Biên độ alpha (|0>) được nhân với i và beta (|1>) được nhân với -i
// 3. Kết quả là trạng thái mới của qubit sau khi áp dụng cổng Y