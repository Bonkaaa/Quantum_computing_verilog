// Module calculating measurement probabilities of a qubit
// Input: Qubit state (alpha, beta)
// Output: Measurement probabilities P(0) and P(1)

module Measurement(
    input wire signed [15:0] alpha_re, // Real part of alpha
    input wire signed [15:0] alpha_im, // Imaginary part of alpha
    input wire signed [15:0] beta_re,  // Real part of beta
    input wire signed [15:0] beta_im,  // Imaginary part of beta

    output signed [31:0] prob_0, // Probability of measuring |0>
    output signed [31:0] prob_1  // Probability of measuring |1>
);

    // Squared real and imaginary parts for |0>
    wire signed [31:0] alpha_re_sq = alpha_re * alpha_re;
    wire signed [31:0] alpha_im_sq = alpha_im * alpha_im;

    // Squared real and imaginary parts for |1>
    wire signed [31:0] beta_re_sq  = beta_re * beta_re;
    wire signed [31:0] beta_im_sq  = beta_im * beta_im;

    // Convert back to Q1.14
    wire signed [31:0] alpha_re_sq_q14 = alpha_re_sq >>> 14;
    wire signed [31:0] alpha_im_sq_q14 = alpha_im_sq >>> 14;
    wire signed [31:0] beta_re_sq_q14  = beta_re_sq  >>> 14;
    wire signed [31:0] beta_im_sq_q14  = beta_im_sq  >>> 14;

    // Calculate probabilities
    assign prob_0 = alpha_re_sq_q14 + alpha_im_sq_q14; // P(0) = |alpha|^2
    assign prob_1 = beta_re_sq_q14  + beta_im_sq_q14;  // P(1) = |beta|^2

endmodule