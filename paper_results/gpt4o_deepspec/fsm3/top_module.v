module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);
    // State encoding
    typedef enum reg [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01,
        STATE_C = 2'b10,
        STATE_D = 2'b11
    } state_t;

    reg [1:0] current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            STATE_A: next_state = (in == 1'b0) ? STATE_A : STATE_B;
            STATE_B: next_state = (in == 1'b0) ? STATE_C : STATE_B;
            STATE_C: next_state = (in == 1'b0) ? STATE_A : STATE_D;
            STATE_D: next_state = (in == 1'b0) ? STATE_C : STATE_B;
            default: next_state = STATE_A; // Default to state A
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= STATE_A; // Reset to state A
        else 
            current_state <= next_state; // Update state on clock edge
    end

    // Output logic (combinational)
    always @(*) begin
        case (current_state)
            STATE_D: out = 1'b1; // Output 1 for state D
            default: out = 1'b0; // Output 0 for states A, B, C
        endcase
    end
endmodule