```verilog
module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'b00,  // State A
        B = 2'b01,  // State B
        C = 2'b10   // State C
    } state_t;

    state_t current_state, next_state;

    // Sequential block for state registers
    always_ff @(posedge clk or negedge resetn) begin
        if (~resetn)
            current_state <= A;  // Reset to state A
        else
            current_state <= next_state;  // Transition to next state
    end

    // Combinational block for next state logic
    always_comb begin
        // Default next state and outputs 
        next_state = current_state;
        g = 3'b000;  // Default grant outputs

        case (current_state)
            A: begin
                if (r[1]) begin
                    next_state = B;  // Priority: Device 1
                end else if (r[2]) begin
                    next_state = C;  // Priority: Device 2
                end else if (r[3]) begin
                    next_state = A;  // Device 3 (lowest priority)
                end else begin
                    next_state = A;  // Stay in A if no requests
                end
            end

            B: begin
                g[1] = 1;  // Grant to device 1
                if (~r[1]) begin
                    next_state = A;  // Go back to A if device 1 deasserts request
                end else begin
                    next_state = B;  // Remain in B as device 1 still has a request
                end
            end

            C: begin
                g[2] = 1;  // Grant to device 2
                if (~r[2]) begin
                    next_state = A;  // Go back to A if device 2 deasserts request
                end else begin
                    next_state = C;  // Remain in C as device 2 still has a request
                end
            end

            default: next_state = A;  // Fallback to state A
        endcase
    end

endmodule
```

### Technical Specification:

1. **Module Definition**
   - Name: `top_module`
   - Inputs:
     - `clk` (clock signal)
     - `resetn` (active-low synchronous reset)
     - `r` (3-bit input representing request signals from three devices)
   - Outputs:
     - `g` (3-bit output representing grant signals for the three devices)

2. **State Encoding**
   - Use a 2-bit encoded state:
     - `00` for State A
     - `01` for State B
     - `10` for State C

3. **State Transition Logic**
   - **Current State A:** 
     - Transition to State B if `r[1]` = 1
     - Transition to State C if `r[2]` = 1
     - Remain in State A if `r[3]` = 1 or if no requests are active.
   - **State B:**
     - Grant g[1] = 1 for device 1.
     - Transition back to State A if `r[1]` = 0.
   - **State C:**
     - Grant g[2] = 1 for device 2.
     - Transition back to State A if `r[2]` = 0.
   - If in State B or C and the corresponding request is still active (r[\(i\)] = 1), remain in the same state.

4. **Reset Behavior**
   - On low `resetn`, the FSM resets to State A.

5. **Output Behavior**
   - Outputs g[3] remain low, corresponding to device 3 which receives no direct grant in this structure when higher priority devices are active.

This Verilog implementation captures the described specification for the FSM arbiter controlling access to shared resources based on the priority of the requesting devices.