```verilog
module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

// State encoding
typedef enum reg [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

// State and next state variables
state_t current_state, next_state;

// Asynchronous reset to state A
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        A: next_state = (in == 0) ? A : B;
        B: next_state = (in == 0) ? C : B;
        C: next_state = (in == 0) ? A : D;
        D: next_state = (in == 0) ? C : B;
        default: next_state = A; // default case for safety
    endcase
end

// Output logic based on the current state
always @(current_state) begin
    case (current_state)
        A: out = 0;
        B: out = 0;
        C: out = 0;
        D: out = 1;
        default: out = 0; // precaution for undefined states
    endcase
end

endmodule
```