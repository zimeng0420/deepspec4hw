module top_module (
	input clk,
	input in,
	input reset,
	output done
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE,
        START_BIT,
        RECEIVE_BITS,
        STOP_BIT,
        ERROR
    } state_t;

    reg [2:0] state, next_state;
    reg [7:0] shift_reg;          // Shift register to hold data bits
    reg [3:0] bit_count;          // Counter for bit reception
    reg start_bit_detected, stop_bit_valid;
    reg done_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            if (state == RECEIVE_BITS) begin
                shift_reg <= {in, shift_reg[7:1]}; // Shift in new bit
                bit_count <= bit_count + 1;
            end
            if (state == STOP_BIT && stop_bit_valid) begin
                done_reg <= 1;
            end else begin
                done_reg <= 0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        start_bit_detected = 0;
        stop_bit_valid = 0;

        case (state)
            IDLE: begin
                if (in == 0) begin
                    next_state = START_BIT;
                    start_bit_detected = 1;
                end
            end
            START_BIT: begin
                next_state = RECEIVE_BITS;
            end
            RECEIVE_BITS: begin
                if (bit_count == 8) begin
                    next_state = STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in == 1) begin
                    stop_bit_valid = 1;
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1) begin  // Wait for stop bit (idle line)
                    next_state = IDLE;
                end
            end
        endcase
    end

    assign done = done_reg;

endmodule