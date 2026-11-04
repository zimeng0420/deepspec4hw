module top_module (
	input clk,
	input reset,
	input in,
	output reg disc,
	output reg flag,
	output reg err);

    // State encoding
    typedef enum reg [2:0] {
    	IDLE       = 3'b000,
    	ONE        = 3'b001,
    	TWO_ONES   = 3'b010,
    	THREE_ONES = 3'b011,
    	FOUR_ONES  = 3'b100,
    	FIVE_ONES  = 3'b101,
    	SIX_ONES   = 3'b110,
    	ERROR      = 3'b111
    } state_t;

    state_t state, next_state;

    // State transition
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic & output logic
    always @(*) begin
        // Default outputs
        disc = 0;
        flag = 0;
        err = 0;

        case (state)
            IDLE: begin
                if (in)
                    next_state = ONE;
                else
                    next_state = IDLE;
            end
            ONE: begin
                if (in)
                    next_state = TWO_ONES;
                else
                    next_state = IDLE;
            end
            TWO_ONES: begin
                if (in)
                    next_state = THREE_ONES;
                else
                    next_state = IDLE;
            end
            THREE_ONES: begin
                if (in)
                    next_state = FOUR_ONES;
                else
                    next_state = IDLE;
            end
            FOUR_ONES: begin
                if (in)
                    next_state = FIVE_ONES;
                else
                    next_state = IDLE;
            end
            FIVE_ONES: begin
                if (in)
                    next_state = SIX_ONES;
                else begin
                    disc = 1;  // 0111110: Signal to discard bit
                    next_state = IDLE;
                end
            end
            SIX_ONES: begin
                if (in)
                    next_state = ERROR;
                else begin
                    flag = 1;  // 01111110: Flag the frame
                    next_state = IDLE;
                end
            end
            ERROR: begin
                err = 1;  // Error: 7 or more 1s
                if (!in)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule