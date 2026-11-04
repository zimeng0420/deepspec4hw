module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

// State Encoding
localparam [1:0] STATE_A = 2'b00,
                 STATE_B = 2'b01,
                 STATE_C = 2'b10,
                 STATE_D = 2'b11;

reg [1:0] current_state, next_state;

// State Transition Logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= STATE_A; // Reset the state to A
    end else begin
        current_state <= next_state; // Transition to the next state
    end
end

// Next State Logic
always @(*) begin
    case (current_state)
        STATE_A: next_state = (in == 1'b0) ? STATE_A : STATE_B;
        STATE_B: next_state = (in == 1'b0) ? STATE_C : STATE_B;
        STATE_C: next_state = (in == 1'b0) ? STATE_A : STATE_D;
        STATE_D: next_state = (in == 1'b0) ? STATE_C : STATE_B;
        default: next_state = STATE_A; // Default state
    endcase
end

// Output Logic
always @(*) begin
    case (current_state)
        STATE_A: out = 1'b0;
        STATE_B: out = 1'b0;
        STATE_C: out = 1'b0;
        STATE_D: out = 1'b1;
        default: out = 1'b0; // Default output
    endcase
end

endmodule