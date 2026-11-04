module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding using one-hot encoding
    typedef enum reg [1:0] {
        STATE_A = 2'b01,
        STATE_B = 2'b10
    } state_t;

    state_t current_state, next_state;

    // Sequential logic for state transitions
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= STATE_A; // Asynchronous reset to state A
        else
            current_state <= next_state; // State transition on clock edge
    end

    // Combinational logic for next state and output
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (x) begin
                    next_state = STATE_B;
                    z = 1;
                end else begin
                    next_state = STATE_A;
                    z = 0;
                end
            end

            STATE_B: begin
                if (x) begin
                    next_state = STATE_B;
                    z = 0;
                end else begin
                    next_state = STATE_B;
                    z = 1;
                end
            end

            default: begin
                next_state = STATE_A;
                z = 0;
            end
        endcase
    end

endmodule