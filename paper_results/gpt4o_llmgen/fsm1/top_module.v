module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    // State encoding using parameters
    parameter STATE_A = 1'b0;
    parameter STATE_B = 1'b1;
    
    // State register to hold the current state
    reg current_state, next_state;

    // Output logic: out is high only in STATE_B
    assign out = (current_state == STATE_B) ? 1'b1 : 1'b0;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= STATE_B; // Asynchronous reset to STATE_B
        else
            current_state <= next_state; // Update state on clock edge
    end

    // Next state logic based on current state and input
    always @(*) begin
        case (current_state)
            STATE_B: next_state = (in == 1'b0) ? STATE_A : STATE_B;
            STATE_A: next_state = (in == 1'b0) ? STATE_B : STATE_A;
            default: next_state = STATE_B; // Default state transition
        endcase
    end

endmodule