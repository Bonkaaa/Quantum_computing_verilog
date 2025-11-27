// Module for Z Gate (Pauli-Z Gate)
// Input: Qubit state (alpha, beta)
// Output: Transformed qubit state after applying Z gate
// Matrix: Z = [[1, 0], [0, -1]]
// Formula:
// |0> -> |0> => alpha_out = alpha
// |1> -> -|1> => beta_out  = -beta

module Z_Gate (
    input wire [15:0] alpha_re, // Real part of alpha
    input wire [15:0] alpha_im, // Imaginary part of alpha
    input wire [15:0] beta_re,  // Real part of beta
    input wire [15:0] beta_im,  // Imaginary part of beta

    output wire [15:0] out_alpha_re, // Output real part of alpha
    output wire [15:0] out_alpha_im, // Output imaginary part of alpha
    output wire [15:0] out_beta_re,  // Output real part of beta
    output wire [15:0] out_beta_im   // Output imaginary part of beta
);

    // Z gate leaves alpha unchanged and negates beta
    assign out_alpha_re = alpha_re;
    assign out_alpha_im = alpha_im;
    assign out_beta_re  = -beta_re;
    assign out_beta_im  = -beta_im;

endmodule

// Giải thích cho đoạn mã trên:
// 1. Cổng Z (Pauli-Z) áp dụng một pha 180 độ cho trạng thái |1> của qubit
// 2. Biên độ alpha (|0>) không thay đổi, trong khi biên độ beta (|1>) bị đảo dấu
// 3. Kết quả là trạng thái mới của qubit sau khi áp dụng cổng Z
