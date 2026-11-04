module top_module (
	input clk,
	input in,
	input reset,
	output done
);

    parameter IDLE = 0, START = 1, DATA = 2, STOP = 3, ERROR = 4;
    reg [2:0] state, next_state;
    reg [7:0] data_reg;
    reg [2:0] bit_count;
    reg data_valid;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 8'b0;
            bit_count <= 3'b0;
            data_valid <= 1'b0;
        end else begin
            state <= next_state;
            data_valid <= (next_state == STOP);
        end
    end

    always @(*) begin
        next_state = state;
        done = data_valid;

        case (state)
            IDLE: begin
                if (!in) begin // Start bit detected
                    next_state = START;
                end
            end
            START: begin
                next_state = DATA;
                bit_count = 3'b0;
            end
            DATA: begin
                data_reg[bit_count] = in;
                bit_count = bit_count + 1;
                if (bit_count == 3'b111) begin // 8 data bits received
                    next_state = STOP;
                end
            end
            STOP: begin
                if (in) begin // Stop bit correct
                    next_state = IDLE;
                end else begin // Stop bit error
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in) begin // Wait for stop bit
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule