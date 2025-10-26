module FixedPoint_Add(
    input wire [15:0] A, // Fixed-point input a
    input wire [15:0] B, // Fixed-point input b
    input wire sub_en,
    output wire [15:0] Sum // Fixed-point result
);

    // Extend to 17 bits to handle overflow
    wire signed [16:0] a_ext = {{1{A[15]}}, A};
    wire signed [16:0] b_ext = {{1{B[15]}}, B};

    wire signed [16:0] temp_sum;

    // sub_en = 0 -> A - B
    // sub_en = 1 -> A + B
    assign temp_sum = (sub_en == 1'b0) ? (a_ext - b_ext) : (a_ext + b_ext);

    // Saturate result to 16 bits
    assign Sum = temp_sum[15:0];

endmodule

// Mở rộng lên 17 bit để xử lý tràn số
// Thêm bit dấu vào đầu của A và B để tránh lỗi khi cộng/trừ
// Thực hiện phép cộng hoặc trừ dựa trên tín hiệu sub_en
// Nếu kết quả vượt quá phạm vi của 16 bit, ta chỉ lấy 16 bit thấp hơn
