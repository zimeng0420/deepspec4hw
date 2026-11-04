module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

    // State Encoding
    typedef enum reg [2:0] {
        STATE_A = 3'b000,
        STATE_B = 3'b001,
        STATE_B_CHECK1 = 3'b010,
        STATE_B_CHECK2 = 3'b011,
        STATE_B_CHECK3 = 3'b100
    } state_t;
    
    state_t current_state, next_state;
    reg [1:0] w_count;  // Counter to store the number of times w=1 in the last three cycles

    // State transition on clock edge
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_A;
            w_count <= 0;
            z <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == STATE_B_CHECK1 || current_state == STATE_B_CHECK2 || current_state == STATE_B_CHECK3) begin
                if (w)
                    w_count <= w_count + 1;  // Increment count if w is 1
            end
            if (current_state == STATE_B_CHECK3) begin
                if (w_count == 2)
                    z <= 1;  // Set z high if count of ones is exactly 2
                else
                    z <= 0;
                w_count <= 0;  // Reset count
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (s)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end
            STATE_B: begin
                next_state = STATE_B_CHECK1;
            end
            STATE_B_CHECK1: begin
                next_state = STATE_B_CHECK2;
            end
            STATE_B_CHECK2: begin
                next_state = STATE_B_CHECK3;
            end
            STATE_B_CHECK3: begin
                next_state = STATE_B_CHECK1;  // Repeat the checking cycle
            end
            default: next_state = STATE_A;
        endcase
    end

endmodule