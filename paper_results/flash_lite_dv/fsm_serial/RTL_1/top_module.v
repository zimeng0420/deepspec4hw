module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State definitions
    parameter IDLE      = 3'b000;
    parameter START_BIT = 3'b001;
    parameter DATA_BITS = 3'b010;
    parameter STOP_BIT  = 3'b011;
    parameter ERROR     = 3'b100;

    // Internal signals
    reg [2:0] state;
    reg [2:0] next_state;
    reg [2:0] data_bit_count;
    reg data_bit_valid; // Store the sampled data bit during DATA_BITS state

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_bit_count <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            if (state == DATA_BITS) begin
              data_bit_count <= data_bit_count + 1;
            end
        end
    end


    // Combinational logic for next state and output
    always @(*) begin
        // Default assignments
        next_state = state;
        done = 0;
        data_bit_valid = 0;

        case (state)
            IDLE: begin
                if (!in) begin // Start bit detected (0)
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                data_bit_valid = in; // Sample the data bit
                if (data_bit_count == 7) begin // 8 data bits received (0-7)
                    next_state = STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in) begin // Stop bit is 1 (valid)
                    next_state = IDLE;
                    done = 1;
                end else begin // Stop bit is 0 (invalid)
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in) begin // Wait for a stop bit (1)
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule