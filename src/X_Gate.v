// Module for X Gate (Pauli-X Gate)
// Input: Qubit state (alpha, beta)
// Output: Transformed qubit state after applying X gate
// Formula:
// |0> -> |1> => alpha_out = beta
// |1> -> |0> => beta_out  = alpha

module X_Gate (
    input wire [15:0] alpha_re, // Real part of alpha
    input wire [15:0] alpha_im, // Imaginary part of alpha
    input wire [15:0] beta_re,  // Real part of beta
    input wire [15:0] beta_im,  // Imaginary part of beta

    output wire [15:0] out_alpha_re, // Output real part of alpha
    output wire [15:0] out_alpha_im, // Output imaginary part of alpha
    output wire [15:0] out_beta_re,  // Output real part of beta
    output wire [15:0] out_beta_im   // Output imaginary part of beta
);

    // X gate simply swaps alpha and beta
    assign out_alpha_re = beta_re;
    assign out_alpha_im = beta_im;
    assign out_beta_re  = alpha_re;
    assign out_beta_im  = alpha_im;

endmodule

// Giải thích cho đoạn mã trên:
// 1. Cổng X (Pauli-X) hoán đổi trạng thái của qubit
// 2. Biên độ alpha (|0>) được gán giá trị của beta (|1>) và ngược lại
// 3. Kết quả là trạng thái mới của qubit sau khi áp dụng cổng X