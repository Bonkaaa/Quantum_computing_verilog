module FixedPoint_Multiply(
    input wire [15:0] A, // Fixed-point input a
    input wire [15:0] B, // Fixed-point input b
    output wire [15:0] result // Fixed-point result
);

    // Fixed-point multiplication (8-bit decimal)
    localparam FP_FRAC_BITS = 8;

    // Multiply as normal
    // Result is 32 bits with 16 bits integer and 16 bits fractional
    wire signed [31:0] product_full = $signed(A) * $signed(B);

    // Adjust for fixed-point by shifting right
    assign result = product_full[FP_FRAC_BITS +: 16];

endmodule


// Giải thích cho đoạn mã trên:
// 1. Thực hiện phép nhân đầy đủ (16-bit * 16-bit = 32-bit)
    // Kết quả 32-bit này sẽ có 16 bit nguyên và (8+8)=16 bit thập phân (Q16.16)
// 2. Căn chỉnh lại dấu chấm thập phân
    // Chúng ta cần chuyển đổi từ Q16.16 (32-bit) về lại Q8.8 (16-bit)
    // bằng cách dịch phải 8 bit (FP_FRAC_BITS) và lấy 16 bit.
    // Điều này tương đương với việc lấy các bit từ [23:8] của kết quả 32-bit.
    // [31:24] [23:16] [15:8] [7:0]
    //   Int8    Int8    Frac8  Frac8  <- (Kết quả 32-bit)
    //           \_____ LẤY _____/     <- (Kết quả 16-bit mong muốn)