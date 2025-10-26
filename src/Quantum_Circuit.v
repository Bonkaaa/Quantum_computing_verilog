// Quantum Circuit Module
// This module integrates various quantum gates and qubit state registers
// to form a Bell State preparation circuit.

module Quantum_Circuit (
    input wire clk,
    input wire reset,
    input wire start, // Signal to start the circuit operation
    
    // Output: 8 qubit state amplitudes for 2 qubits
    output wire signed [15:0] final_c00_re,
    output wire signed [15:0] final_c00_im,
    output wire signed [15:0] final_c01_re,
    output wire signed [15:0] final_c01_im,
    output wire signed [15:0] final_c10_re,
    output wire signed [15:0] final_c10_im,
    output wire signed [15:0] final_c11_re,
    output wire signed [15:0] final_c11_im
);

    // Constants for initial states
    localparam FP_ONE = 16'h0100; // Fixed-point representation of 1.0
    localparam FP_ZERO = 16'h0000; // Fixed-point representation of 0.0
    localparam FP_INV_SQRT2 = 16'h00B5; // Approx. 0.7071 in Q8.8

    // Registers for 2-qubit states
    reg signed [15:0] c00_re_reg, c00_im_reg, c01_re_reg, c01_im_reg, 
                      c10_re_reg, c10_im_reg, c11_re_reg, c11_im_reg;

    // Next state wires
    wire signed [15:0] c00_re_next, c00_im_next, c01_re_next, c01_im_next, 
                       c10_re_next, c10_im_next, c11_re_next, c11_im_next;

    // FSM
    reg [1:0] state;
    localparam S_INIT = 2'b00;
    localparam S_HADAMARD = 2'b01; // Apply Hadamard to qubit 0
    localparam S_CNOT = 2'b10; // Apply CNOT with qubit 0 as control and qubit 1 as target
    localparam S_DONE = 2'b11; // Final state

    // State Transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_INIT;
        end else begin
            case (state)
                S_INIT: if (start) state <= S_HADAMARD;
                S_HADAMARD: state <= S_CNOT;
                S_CNOT: state <= S_DONE;
                S_DONE: if (!start) state <= S_INIT;
                default: state <= S_INIT;
            endcase
        end
    end

    // State Register Update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize to |00> state
            c00_re_reg <= FP_ONE;  c00_im_reg <= FP_ZERO;
            c01_re_reg <= FP_ZERO; c01_im_reg <= FP_ZERO;
            c10_re_reg <= FP_ZERO; c10_im_reg <= FP_ZERO;
            c11_re_reg <= FP_ZERO; c11_im_reg <= FP_ZERO;
        end else begin
            // Update to next state
            c00_re_reg <= c00_re_next; c00_im_reg <= c00_im_next;
            c01_re_reg <= c01_re_next; c01_im_reg <= c01_im_next;
            c10_re_reg <= c10_re_next; c10_im_reg <= c10_im_next;
            c11_re_reg <= c11_re_next; c11_im_reg <= c11_im_next;
        end
    end

    // Combinational Logic for Next State

    // Immediate wires for Hadamard outputs
    wire signed [15:0] h_c00_re, h_c00_im, h_c10_re, h_c10_im,
                        h_c01_re, h_c01_im, h_c11_re, h_c11_im;

    // Immediate wires for CNOT outputs
    wire signed [15:0] cnot_c00_re, cnot_c00_im, cnot_c01_re, cnot_c01_im,
                        cnot_c10_re, cnot_c10_im, cnot_c11_re, cnot_c11_im;

    // Stage 1: Apply Hadamard
    wire [15:0] add_c00c10_re, add_c00c10_im, sub_c00c10_re, sub_c00c10_im;
    wire [15:0] add_c01c11_re, add_c01c11_im, sub_c01c11_re, sub_c01c11_im;

    FixedPoint_Add add1 (c00_re_reg, c10_re_reg, 0, add_c00c10_re);
    FixedPoint_Add add2 (c00_im_reg, c10_im_reg, 0, add_c00c10_im);
    FixedPoint_Add sub1 (c00_re_reg, c10_re_reg, 1, sub_c00c10_re);
    FixedPoint_Add sub2 (c00_im_reg, c10_im_reg, 1, sub_c00c10_im);
    FixedPoint_Add add3 (c01_re_reg, c11_re_reg, 0, add_c01c11_re);
    FixedPoint_Add add4 (c01_im_reg, c11_im_reg, 0, add_c01c11_im);
    FixedPoint_Add sub3 (c01_re_reg, c11_re_reg, 1, sub_c01c11_re);
    FixedPoint_Add sub4 (c01_im_reg, c11_im_reg, 1, sub_c01c11_im);

    // Multiply by 1/sqrt(2)
    FixedPoint_Multiply mult1 (add_c00c10_re, FP_INV_SQRT2, h_c00_re);
    FixedPoint_Multiply mult2 (add_c00c10_im, FP_INV_SQRT2, h_c00_im);
    FixedPoint_Multiply mult3 (sub_c00c10_re, FP_INV_SQRT2, h_c10_re);
    FixedPoint_Multiply mult4 (sub_c00c10_im, FP_INV_SQRT2, h_c10_im);
    FixedPoint_Multiply mult5 (add_c01c11_re, FP_INV_SQRT2, h_c01_re);
    FixedPoint_Multiply mult6 (add_c01c11_im, FP_INV_SQRT2, h_c01_im);
    FixedPoint_Multiply mult7 (sub_c01c11_re, FP_INV_SQRT2, h_c11_re);
    FixedPoint_Multiply mult8 (sub_c01c11_im, FP_INV_SQRT2, h_c11_im);

    // Stage 2: Apply CNOT
    assign cnot_c00_re = h_c00_re;
    assign cnot_c00_im = h_c00_im;
    assign cnot_c01_re = h_c01_re;
    assign cnot_c01_im = h_c01_im;

    assign cnot_c10_re = h_c11_re; // |10> becomes |11>
    assign cnot_c10_im = h_c11_im;
    assign cnot_c11_re = h_c10_re; // |11> becomes |10>
    assign cnot_c11_im = h_c10_im;

    // Next state assignments based on current state
    assign c00_re_next = (state == S_HADAMARD) ? h_c00_re :
                        (state == S_CNOT) ? cnot_c00_re : c00_re_reg;
    assign c00_im_next = (state == S_HADAMARD) ? h_c00_im :
                        (state == S_CNOT) ? cnot_c00_im : c00_im_reg;
    assign c01_re_next = (state == S_HADAMARD) ? h_c01_re :
                        (state == S_CNOT) ? cnot_c01_re : c01_re_reg;
    assign c01_im_next = (state == S_HADAMARD) ? h_c01_im :
                        (state == S_CNOT) ? cnot_c01_im : c01_im_reg;
    assign c10_re_next = (state == S_HADAMARD) ? h_c10_re :
                        (state == S_CNOT) ? cnot_c10_re : c10_re_reg;
    assign c10_im_next = (state == S_HADAMARD) ? h_c10_im :
                        (state == S_CNOT) ? cnot_c10_im : c10_im_reg;
    assign c11_re_next = (state == S_HADAMARD) ? h_c11_re :
                        (state == S_CNOT) ? cnot_c11_re : c11_re_reg;
    assign c11_im_next = (state == S_HADAMARD) ? h_c11_im :
                        (state == S_CNOT) ? cnot_c11_im : c11_im_reg;

    // Final outputs
    assign final_c00_re = c00_re_reg;
    assign final_c00_im = c00_im_reg;
    assign final_c01_re = c01_re_reg;
    assign final_c01_im = c01_im_reg;
    assign final_c10_re = c10_re_reg;
    assign final_c10_im = c10_im_reg;
    assign final_c11_re = c11_re_reg;
    assign final_c11_im = c11_im_reg;

endmodule


// Giải thích cho đoạn mã trên:
// 1. Mô-đun Quantum_Circuit tích hợp các cổng lượng tử để chuẩn bị trạng thái Bell
// 2. Sử dụng FSM để điều khiển tuần tự các bước: khởi tạo, áp dụng cổng Hadamard, áp dụng cổng CNOT
// 3. Sử dụng các thanh ghi để lưu trữ trạng thái của hai qubit
// 4. Kết quả cuối cùng là trạng thái của hai qubit sau khi áp dụng các cổng lượng tử

