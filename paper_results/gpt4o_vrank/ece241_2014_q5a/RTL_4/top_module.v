module top_module (
	input clk,
	input areset,
	input x,
	output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        COMPLEMENT = 2'b01,
        PASS = 2'b10
    } state_t;

    state_t current_state, next_state;
    
    // State transition
    always_ff @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= IDLE;
        else 
            current_state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE:       next_state = COMPLEMENT;
            COMPLEMENT: next_state = x ? PASS : COMPLEMENT;
            PASS:       next_state = PASS;
            default:    next_state = IDLE;
        endcase
    end

    // Output logic
    always_comb begin
        case (current_state)
            IDLE:       z = 0;
            COMPLEMENT: z = ~x;
            PASS:       z = x;
            default:    z = 0;
        endcase
    end

endmodule