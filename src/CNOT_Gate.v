// Module for CNOT Gate (Controlled-NOT Gate)
// Input: Qubit states (control and target)
// Output: Transformed qubit states after applying CNOT gate
// Formula:
// If control qubit is |0> (alpha_c != 0), target qubit remains unchanged
// If control qubit is |1> (beta_c != 0), target qubit is flipped (X gate applied)

module CNOT_Gate (
    input wire signed [15:0] c00_in_re, // |00> Real part
    input wire signed [15:0] c00_in_im, // |00> Imaginary part
    input wire signed [15:0] c01_in_re, // |01> Real part
    input wire signed [15:0] c01_in_im, // |01> Imaginary part
    input wire signed [15:0] c10_in_re, // |10> Real part
    input wire signed [15:0] c10_in_im, // |10> Imaginary part
    input wire signed [15:0] c11_in_re, // |11> Real part
    input wire signed [15:0] c11_in_im, // |11> Imaginary part

    output wire signed [15:0] c00_out_re,
    output wire signed [15:0] c00_out_im,
    output wire signed [15:0] c01_out_re,
    output wire signed [15:0] c01_out_im,
    output wire signed [15:0] c10_out_re,
    output wire signed [15:0] c10_out_im,
    output wire signed [15:0] c11_out_re,
    output wire signed [15:0] c11_out_im
);

    // If control qubit is |0> (c00 and c01), target qubit remains unchanged
    assign c00_out_re = c00_in_re;
    assign c00_out_im = c00_in_im;

    assign c01_out_re = c01_in_re;
    assign c01_out_im = c01_in_im;

    // If control qubit is |1> (c10 and c11), target qubit is flipped
    assign c10_out_re = c11_in_re; // |10> becomes |11>
    assign c10_out_im = c11_in_im;

    assign c11_out_re = c10_in_re; // |11> becomes |10>
    assign c11_out_im = c10_in_im;

endmodule


// Giải thích cho đoạn mã trên:
// 1. Cổng CNOT kiểm soát trạng thái của qubit mục tiêu dựa trên trạng thái của qubit điều khiển
// 2. Nếu qubit điều khiển ở trạng thái |0>, qubit mục tiêu không thay đổi
// 3. Nếu qubit điều khiển ở trạng thái |1>, qubit mục tiêu bị đảo ngược (áp dụng cổng X)
// 4. Kết quả là trạng thái mới của hai qubit sau khi áp dụng cổng CNOT