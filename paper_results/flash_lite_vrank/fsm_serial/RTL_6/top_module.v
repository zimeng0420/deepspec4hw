module top_module (
    input clk,
    input in,
    input reset,
    output done
);

    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter DATA = 3'b010;
    parameter STOP = 3'b011;
    parameter ERROR = 3'b100;
    parameter WAIT_STOP = 3'b101;

    reg [2:0] state;
    reg [2:0] next_state;
    reg [7:0] data_reg;
    reg [2:0] bit_count;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 1'b0;
            bit_count <= 3'b000;
        end else begin
            state <= next_state;
            done_reg <= 1'b0; // Clear done at the start of each cycle
        end
    end

    always @(*) begin
        next_state = state;
        done = done_reg;

        case (state)
            IDLE: begin
                done = 1'b0;
                if (~in) begin // Detect start bit (low)
                    next_state = START;
                end
            end
            START: begin
                if (in) begin
                    next_state = ERROR; // Start bit was incorrect
                end else begin
                    next_state = DATA;
                    bit_count = 3'b000;
                end
            end
            DATA: begin
                data_reg[bit_count] = in;
                bit_count = bit_count + 1'b1;
                if (bit_count == 3'b111) begin // 8 data bits received
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end
            STOP: begin
                if (in) begin // Correct stop bit (high)
                    next_state = IDLE;
                    done_reg = 1'b1; // Indicate a byte has been successfully received
                end else begin
                    next_state = ERROR; // Incorrect stop bit
                end
            end
            ERROR: begin
                if (in) begin // Wait for stop bit to go high
                    next_state = IDLE;
                end else begin
                   next_state = ERROR;
                end
            end
        endcase
    end

endmodule