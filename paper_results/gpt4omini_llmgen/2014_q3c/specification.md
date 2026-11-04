```verilog
module top_module (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

// State Encoding
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

// Next state and output logic
always @(posedge clk) begin
    case (y)
        S0: begin
            if (x == 0) begin
                Y0 <= S0; 
                z <= 0;
            end else begin
                Y0 <= S1; 
                z <= 0;
            end
        end
        S1: begin
            if (x == 0) begin
                Y0 <= S1; 
                z <= 0;
            end else begin
                Y0 <= S4; 
                z <= 0;
            end
        end
        S2: begin
            if (x == 0) begin
                Y0 <= S2; 
                z <= 0;
            end else begin
                Y0 <= S1; 
                z <= 0;
            end
        end
        S3: begin
            if (x == 0) begin
                Y0 <= S1; 
                z <= 1;
            end else begin
                Y0 <= S2; 
                z <= 1;
            end
        end
        S4: begin
            if (x == 0) begin
                Y0 <= S3; 
                z <= 1;
            end else begin
                Y0 <= S4; 
                z <= 1;
            end
        end
        default: begin
            Y0 <= S0; 
            z <= 0;
        end
    endcase
end

endmodule
```

### Technical Specification:

1. **Module Definition**:
   - The module is named `top_module`.
   - Inputs:
     - `clk`: Clock signal for state transition.
     - `x`: Input signal determining the state transition and output.
     - `y[2:0]`: Current state, represented as a 3-bit vector.
   - Outputs:
     - `Y0`: Next state output as a register.
     - `z`: Output signal based on the current state and input `x`.

2. **State Encoding**:
   - The states are represented with 3 bits (y[2:0]):
     - `S0 (000)`, `S1 (001)`, `S2 (010)`, `S3 (011)`, `S4 (100)`.

3. **Next State Logic**:
   - Uses a synchronous state transition based on the current state (`y`) and the input signal (`x`).
   - Each state has predefined next states depending on the value of `x` (0 or 1).
   - Next state assignments are performed within an `always` block that is triggered on the rising edge of `clk`.

4. **Output Logic**:
   - The output `z` is assigned based on the current state and the input signal `x` as per the state table.
   - Binary output (`0` or `1`) based on current state and logic conditions.

5. **Default State Handling**:
   - If an undefined state is reached, the next state defaults to `S0` and output `z` defaults to `0`.