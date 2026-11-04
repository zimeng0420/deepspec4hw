### Technical Specification for Mealy-Type Finite State Machine to Recognize Sequence "101"

**Module Header:**
```verilog
module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);
```

**State Encoding:**
- State 0 (S0): Initial state (no part of "101" detected).
- State 1 (S1): '1' detected.
- State 2 (S2): '10' detected (overlaps allowed).

**State Transition Table:**

| Current State | Input (x) | Next State | Output (z) |
|----------------|-----------|-------------|------------|
| S0             | 0         | S0          | 0          |
| S0             | 1         | S1          | 0          |
| S1             | 0         | S2          | 0          |
| S1             | 1         | S1          | 0          |
| S2             | 0         | S0          | 0          |
| S2             | 1         | S1          | 1          |

**State Transition Diagram:**
- **S0** --1--> **S1**
- **S1** --0--> **S2**
- **S2** --1--> **S1** (output z=1)
- **S2** --0--> **S0**

**Reset Conditions:**
- On a negative edge trigger of `aresetn`, the FSM transitions to `S0`, and the output `z` is set to 0.

**Clock Sensitivity:**
- The FSM transitions occur on the rising edge of `clk`.

**Implementation:**
- Use `always` blocks to manage state transitions and output generation.

**Output Conditions:**
- The output `z` should only be set to '1' in the state transition from `S2` to `S1`.

### Sample Verilog Implementation
```verilog
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Asynchronous reset
        z <= 0;
        state <= S0;
    end else begin
        case(state)
            S0: begin
                if (x) begin
                    state <= S1;
                end
            end
            
            S1: begin
                if (x) begin
                    state <= S1; // Stay in S1
                end else begin
                    state <= S2;
                end
            end
            
            S2: begin
                if (x) begin
                    z <= 1; // Output 1 on detecting "101"
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
        endcase
    end
end
```

**Note:** 
- Ensure that the state variables and output signal `z` are declared appropriately (e.g., as registers).
- Be aware of edge cases where the input may toggle in rapid succession; the FSM should reliably detect the sequence "101" even with overlapping. 

This specification provides a structured approach to implementing a Mealy FSM in Verilog, fulfilling the requirements outlined in the task.