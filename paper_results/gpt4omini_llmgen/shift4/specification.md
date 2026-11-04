### Technical Specification for 4-Bit Shift Register

#### Module Interface
- **Module Name:** `top_module`
- **Inputs:**
  - `clk` (1-bit): Clock signal for synchronous operations.
  - `areset` (1-bit): Asynchronous reset signal (active high).
  - `load` (1-bit): Load signal to load data into the shift register (active high).
  - `ena` (1-bit): Enable signal to perform the shift operation (active high).
  - `data` (4-bit): Input data to load into the shift register.

- **Outputs:**
  - `q` (4-bit): Current contents of the shift register.

#### Functionality
1. **Asynchronous Reset:**
   - If `areset` is asserted (high), regardless of the clock or other input signals, the shift register `q` is reset to `4'b0000`.

2. **Synchronous Load:**
   - On the rising edge of `clk`, if `load` is asserted (high), the shift register `q` is loaded with the value from the `data` input (`q` becomes `data`).

3. **Synchronous Shift Operation:**
   - On the rising edge of `clk`, if `ena` is asserted (high) and `load` is deasserted (low), the contents of `q` are shifted right by one position:
     - `q[3]` becomes `0`
     - `q[2]` becomes `q[3]`
     - `q[1]` becomes `q[2]`
     - `q[0]` becomes `q[1]`
   - The value at `q[0]` is lost (shifted out).

4. **Priority of Operations:**
   - The `load` input has a higher priority than the `ena` input. If both `load` and `ena` are asserted at the same time, the data from `data` will be loaded into `q`, and the shift operation will not occur.

#### Implementation Notes
- The shift register should use a clocked process to detect the rising edge of `clk` for load and shift operations.
- Make sure to handle asynchronous reset separately from the clocked process to ensure immediate reset functionality.

#### Example Usage
- This shift register can be used in digital systems requiring temporary storage of data, enabling data shifting operations and reset capabilities effectively in FPGA or ASIC designs.

#### Verilog Code Template
This specification will guide the design of the Verilog code. 
```verilog
module top_module(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);
    // Implementation here
endmodule
``` 

Ensure to adhere to this specification while implementing the Verilog code for the shift register.