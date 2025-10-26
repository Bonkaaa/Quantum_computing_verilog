// Qubit_State.v
// MÔ TẢ:
// Thanh ghi trạng thái (State Register) để lưu trữ trạng thái của MỘT qubit.
// Trạng thái được biểu diễn bằng hai số phức:
// alpha (alpha_re + i * alpha_im) -> biên độ của |0>
// beta  (beta_re  + i * beta_im)  -> biên độ của |1>
//
// SỬ DỤNG:
// Module này sử dụng logic tuần tự (sequential) và cần clock.
// Nó LƯU TRỮ trạng thái hiện tại.
//
// ĐỊNH DẠNG:
// Sử dụng số dấu chấm cố định (Fixed-Point) 16-bit (Giả định 8-bit thập phân).


module Qubit_State (
    input wire clk,
    input wire reset,

    // Update state
    input wire update_en

    // New state
    input wire [15:0] new_alpha_re, // New real part of alpha
    input wire [15:0] new_alpha_im, // New imaginary part of alpha
    input wire [15:0] new_beta_re,  // New real part of beta
    input wire [15:0] new_beta_im,  // New imaginary part of beta

    // Current state outputs
    output reg [15:0] alpha_re, // Real part of alpha
    output reg [15:0] alpha_im, // Imaginary part of alpha
    output reg [15:0] beta_re,  // Real part of beta
    output reg [15:0] beta_im   // Imaginary part of beta
);

    // Fixed-point constants (8-bit decimal)
    localparam FP_ZERO = 16'h0000; // Fixed-point representation of 0.0
    localparam FP_ONE  = 16'h0100; // Fixed-point representation of 1.0

    alawys @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, initialize to |0> state
            alpha_re <= FP_ONE;  // alpha = 1 + 0i
            alpha_im <= FP_ZERO;
            beta_re  <= FP_ZERO; // beta  = 0 + 0i
            beta_im  <= FP_ZERO;
        end else if (update_en) begin
            // Update state with new values
            alpha_re <= new_alpha_re;
            alpha_im <= new_alpha_im;
            beta_re  <= new_beta_re;
            beta_im  <= new_beta_im;
        end
        // Otherwise, retain current state
    end

endmodule