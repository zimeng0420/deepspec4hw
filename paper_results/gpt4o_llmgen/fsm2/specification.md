```verilog
module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);

    // State declaration
    typedef enum logic {
        OFF = 1'b0,
        ON  = 1'b1
    } state_t;

    state_t current_state, next_state;

    // State transition logic (next state logic)
    always @(*) begin
        case (current_state)
            OFF: begin
                if (j) 
                    next_state = ON;
                else 
                    next_state = OFF;
            end
            ON: begin
                if (k) 
                    next_state = OFF;
                else 
                    next_state = ON;
            end
            default: next_state = OFF;
        endcase
    end

    // State flip-flops with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= OFF; // asynchronous reset to OFF state
        else 
            current_state <= next_state;
    end

    // Output logic (Moore machine: output depends only on the current state)
    always @(*) begin
        case (current_state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule
```

### Technical Specifications:
1. **State Encoding**: The state machine has two states: `OFF` (0) and `ON` (1), represented as 1-bit logic.
2. **Input Ports**: 
   - `clk`: Clock input for sequential logic.
   - `j`: Input determining transition from `OFF`.
   - `k`: Input determining transition from `ON`.
   - `areset`: Asynchronous active-high reset to state `OFF`.
3. **Output Port**:
   - `out`: Output of the state machine (0 for `OFF`, 1 for `ON`).
4. **State Transition Logic**:
   - **OFF state**: Transitions to `ON` on `j=1`; remains `OFF` on `j=0`.
   - **ON state**: Transitions to `OFF` on `k=1`; remains `ON` on `k=0`.
5. **Asynchronous Reset**: State machine resets to `OFF` whenever `areset` is high, irrespective of the clock.
6. **Output Logic**: Implemented as a combinational block, dependent solely on the current state (Moore machine characteristic).