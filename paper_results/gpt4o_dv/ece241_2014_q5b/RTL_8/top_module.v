module top_module (
	input clk,
	input areset,
	input x,
	output reg z
);

    // One-hot state encoding
    typedef enum reg [1:0] {STATE_A = 2'b01, STATE_B = 2'b10} state_t;
    
    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_A;   // Reset to State A
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always @* begin
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
                next_state = STATE_B; // Remain in state B
                if (x) begin
                    z = 0;
                end else begin
                    z = 1;
                end
            end
            default: begin
                next_state = STATE_A; // Default to state A
                z = 0;
            end
        endcase
    end

endmodule