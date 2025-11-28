# Mô phỏng Cổng Lượng tử bằng Verilog

Project này là bài tập lớn với chủ đề mô phỏng các khái niệm tính toán lượng tử cơ bản (Qubit và Cổng Lượng tử) bằng ngôn ngữ mô tả phần cứng Verilog.

Thay vì mô phỏng vật lý lượng tử thực tế, project này tập trung vào việc mô phỏng **đại số tuyến tính** (phép nhân vector, ma trận) của các cổng lượng tử bằng cách sử dụng **số học dấu chấm cố định (fixed-point arithmetic)**.

## 💡 Khái niệm Cốt lõi

* **Biểu diễn Qubit:** Trạng thái của một qubit ($\alpha$ và $\beta$) được biểu diễn bằng hai **số phức**.
* **Số học Dấu chấm Cố định (Fixed-Point):** Để có thể tổng hợp (synthesizable) và mô phỏng hiệu quả, các số phức này được biểu diễn bằng các thanh ghi 16-bit (dưới dạng `signed [15:0]`).
    * **Định dạng:** Q8.8 (8 bit cho phần nguyên, 8 bit cho phần thập phân).
* **Cổng Lượng tử:** Mỗi cổng (`H_Gate`, `X_Gate`, `Y_Gate`, `Z_Gate`, `CNOT_Gate`) là một module Verilog tổ hợp (combinational) thực hiện phép nhân ma trận tương ứng.

## 📂 Cấu trúc Repository
```plaintext
Quantum_computing_verilog/
├── src/
│   ├── FixedPoint_Add.v      # Module cộng/trừ số Fixed-Point
│   ├── FixedPoint_Multiply.v # Module nhân số Fixed-Point
│   ├── qubit_state.v         # Thanh ghi lưu trạng thái Qubit (logic tuần tự)
│   ├── H_Gate.v              # Module cổng Hadamard
│   ├── X_Gate.v              # Module cổng Pauli-X (NOT)
│   ├── Y_Gate.v              # Module cổng Pauli-Y
│   ├── Z_Gate.v              # Module cổng Pauli-Z
│   ├── CNOT_Gate.v           # Module cổng CNOT (2-qubit gate)
│   ├── measurement.v         # Module tính xác suất đo lường
│   └── Quantum_Circuit.v     # Mạch cấp cao (tạo Trạng thái Bell)
├── tb/
│   ├── H_Gate_tb.v           # Testbench cho cổng H
│   ├── X_Gate_tb.v           # Testbench cho cổng X
│   ├── Y_Gate_tb.v           # Testbench cho cổng Y
│   ├── Z_Gate_tb.v           # Testbench cho cổng Z
│   ├── CNOT_tb.v             # Testbench cho cổng CNOT
│   ├── measurement_tb.v      # Testbench cho module đo lường
│   └── Circuit_tb.v          # Testbench cho mạch Trạng thái Bell
├── scripts/
│   ├── run_h_gate_test.ps1   # Script chạy test H_Gate
│   ├── run_x_gate_test.ps1   # Script chạy test X_Gate
│   ├── run_y_gate_test.ps1   # Script chạy test Y_Gate
│   ├── run_z_gate_test.ps1   # Script chạy test Z_Gate
│   ├── run_cnot_test.ps1     # Script chạy test CNOT_Gate
│   ├── run_measurement_test.ps1 # Script chạy test measurement
│   └── run_circuit_test.ps1  # Script chạy test mạch chính
└── README.md                 # File này
```

## 🛠️ Yêu cầu Hệ thống

Để chạy mô phỏng, bạn cần cài đặt:

1.  **Icarus Verilog (`iverilog`):** Trình biên dịch và mô phỏng Verilog.
2.  **Windows PowerShell:** Để thực thi các kịch bản (scripts) chạy tự động.

## 🚀 Cách chạy Mô phỏng

Tất cả các lệnh biên dịch và chạy đã được đóng gói trong các tệp PowerShell trong thư mục `scripts/`.

### Test Hadamard Gate (H_Gate)
```powershell
cd <thư_mục_dự_án>
.\scripts\run_h_gate_test.ps1
```

### Test Pauli-X Gate (X_Gate)
```powershell
cd <thư_mục_dự_án>
.\scripts\run_x_gate_test.ps1
```

### Test Pauli-Y Gate (Y_Gate)
```powershell
cd <thư_mục_dự_án>
.\scripts\run_y_gate_test.ps1
```

### Test Pauli-Z Gate (Z_Gate)
```powershell
cd <thư_mục_dự_án>
.\scripts\run_z_gate_test.ps1
```

### Test CNOT Gate
```powershell
cd <thư_mục_dự_án>
.\scripts\run_cnot_test.ps1
```

### Test Measurement Module
```powershell
cd <thư_mục_dự_án>
.\scripts\run_measurement_test.ps1
```

### Test Quantum Circuit (Bell State)
```powershell
cd <thư_mục_dự_án>
.\scripts\run_circuit_test.ps1
```

**Lưu ý:** Các script tự động tìm kiếm `iverilog` và `vvp` trong PATH hoặc tại đường dẫn mặc định `C:\iverilog\bin\`.

## 📊 Chi tiết các Module

### 1. **FixedPoint_Add.v**
Module thực hiện phép cộng/trừ số Fixed-Point (Q8.8):
- **Input:** Hai số 16-bit (A, B) và cờ điều khiển `sub_en`
- **Output:** Kết quả phép cộng hoặc trừ
- **Chức năng:** 
  - `sub_en = 0`: Thực hiện A - B (phép trừ)
  - `sub_en = 1`: Thực hiện A + B (phép cộng)

### 2. **FixedPoint_Multiply.v**
Module thực hiện phép nhân số Fixed-Point:
- **Input:** Hai số 16-bit (A, B)
- **Output:** Kết quả phép nhân (16-bit)
- **Cơ chế:** Nhân đầy đủ 32-bit rồi điều chỉnh lại định dạng Q8.8

### 3. **qubit_state.v**
Module thanh ghi trạng thái Qubit với logic tuần tự:
- **Input:** Clock, reset, update_en, trạng thái mới (alpha, beta)
- **Output:** Trạng thái hiện tại của qubit
- **Chức năng:** Lưu trữ và cập nhật trạng thái qubit khi có tín hiệu `update_en`

### 4. **H_Gate.v (Hadamard Gate)**
Cổng Hadamard tạo superposition:
- **Ma trận:** `H = 1/√2 * [[1, 1], [1, -1]]`
- **Chức năng:** Biến đổi trạng thái qubit từ basis state sang superposition
- **Ví dụ:** `|0⟩ → (|0⟩ + |1⟩)/√2`, `|1⟩ → (|0⟩ - |1⟩)/√2`

### 5. **X_Gate.v (Pauli-X Gate)**
Cổng NOT lượng tử:
- **Ma trận:** `X = [[0, 1], [1, 0]]`
- **Chức năng:** Đảo ngược trạng thái qubit
- **Ví dụ:** `|0⟩ → |1⟩`, `|1⟩ → |0⟩`

### 6. **Y_Gate.v (Pauli-Y Gate)**
Cổng Y lượng tử với pha ±90 độ:
- **Ma trận:** `Y = [[0, -i], [i, 0]]`
- **Chức năng:** Áp dụng pha ±90 độ (nhân với ±i) cho trạng thái qubit
- **Ví dụ:** `|0⟩ → i|1⟩`, `|1⟩ → -i|0⟩`

### 7. **Z_Gate.v (Pauli-Z Gate)**
Cổng Z lượng tử với pha 180 độ:
- **Ma trận:** `Z = [[1, 0], [0, -1]]`
- **Chức năng:** Giữ nguyên |0⟩, đảo dấu |1⟩
- **Ví dụ:** `|0⟩ → |0⟩`, `|1⟩ → -|1⟩`

### 8. **CNOT_Gate.v (Controlled-NOT Gate)**
Cổng 2-qubit với qubit điều khiển và qubit mục tiêu:
- **Ma trận:** `CNOT = [[1,0,0,0], [0,1,0,0], [0,0,0,1], [0,0,1,0]]`
- **Chức năng:** 
  - Nếu control qubit = `|0⟩`: Target qubit không đổi
  - Nếu control qubit = `|1⟩`: Target qubit bị đảo (áp dụng X gate)
- **Basis states:** `|00⟩, |01⟩, |10⟩, |11⟩`

### 9. **measurement.v (Measurement Module)**
Module tính xác suất đo lường qubit:
- **Input:** Trạng thái qubit (alpha, beta) dưới dạng số phức
- **Output:** Xác suất đo được |0⟩ (P0) và |1⟩ (P1)
- **Công thức:** 
  - `P(0) = |alpha|² = alpha_re² + alpha_im²`
  - `P(1) = |beta|² = beta_re² + beta_im²`
- **Lưu ý:** Tổng P(0) + P(1) phải bằng 1.0

### 10. **Quantum_Circuit.v (Bell State Circuit)**
Mạch tạo trạng thái Bell (entangled state):
- **Sequence:** 
  1. Khởi tạo: `|00⟩`
  2. Áp dụng H gate trên qubit 0: `(|00⟩ + |10⟩)/√2`
  3. Áp dụng CNOT gate: `(|00⟩ + |11⟩)/√2` (Bell state)
- **FSM:** Sử dụng máy trạng thái hữu hạn để điều khiển tuần tự
- **States:** S_INIT → S_HADAMARD → S_CNOT → S_DONE

## 🔬 Kết quả Mô phỏng

Sau khi chạy các testbench, kết quả được hiển thị dưới dạng số Fixed-Point (hex):
- `0x0100` = 1.0 (256/256)
- `0x00B5` ≈ 0.707 (181/256) ≈ 1/√2
- `0x0000` = 0.0

Kết quả cũng có thể được xem bằng công cụ waveform viewer như GTKWave với file `.vcd` được tạo ra.

## 🎯 Mục đích Học tập

Project này giúp hiểu:
1. Cách biểu diễn khái niệm lượng tử bằng đại số tuyến tính
2. Kỹ thuật Fixed-Point arithmetic trong thiết kế phần cứng
3. Cấu trúc module và testbench trong Verilog
4. Máy trạng thái hữu hạn (FSM) trong thiết kế số
5. Các cổng lượng tử cơ bản: H, X, Y, Z, CNOT
6. Khái niệm entanglement qua Bell State
7. Cách tính xác suất đo lường qubit

## 📝 Ghi chú

- **Độ chính xác:** Sử dụng Q8.8 (8-bit fractional) có độ chính xác giới hạn (~0.004)
- **Tổng hợp (Synthesis):** Module này có thể được tổng hợp thành phần cứng thực (FPGA/ASIC)
- **Mở rộng:** Có thể mở rộng để hỗ trợ nhiều qubit hơn và các cổng phức tạp hơn

## 🤝 Đóng góp

Đây là project học tập. Mọi góp ý và cải tiến đều được hoan nghênh!

## 📚 Tài liệu Tham khảo

- [Quantum Computing for Computer Scientists](https://www.cambridge.org/core/books/quantum-computing-for-computer-scientists/8AEA723BEE5CC9F5C03FDD4BA850C711)
- [Verilog HDL: A Guide to Digital Design and Synthesis](https://www.amazon.com/Verilog-HDL-Guide-Digital-Synthesis/dp/0130449113)
- [Fixed-Point Arithmetic in Verilog](https://zipcpu.com/dsp/2017/07/21/bit-growth.html)

