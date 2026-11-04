module top_module (
	input clk,
	input in,
	input reset,
	output reg [7:0] out_byte,
	output reg done
);

    // State declaration
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        START_BIT = 3'b001,
        DATA_BITS = 3'b010,
        STOP_BIT = 3'b011
    } state_type;

    state_type state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift_reg;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        done = 0; // Default value
        next_state = state;

        case (state)
            IDLE: begin
                if (~in) // Start bit detected
                    next_state = START_BIT;
            end

            START_BIT: begin
                next_state = DATA_BITS;
                bit_count = 0;
            end

            DATA_BITS: begin
                data_shift_reg[bit_count] = in;
                if (bit_count == 3'd7) begin
                    next_state = STOP_BIT;
                end else begin
                    bit_count = bit_count + 1;
                end
            end

            STOP_BIT: begin
                if (in) begin // Stop bit is correct
                    out_byte = data_shift_reg;
                    done = 1;
                    next_state = IDLE;
                end // If not, remain in STOP_BIT until in becomes 1
            end

            default: next_state = IDLE;
        endcase
    end

endmodule