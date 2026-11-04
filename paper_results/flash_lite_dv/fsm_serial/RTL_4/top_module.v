module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State Definitions
    parameter IDLE = 3'b000;
    parameter START_BIT = 3'b001;
    parameter DATA_BITS = 3'b010;
    parameter STOP_BIT = 3'b011;
    parameter ERROR = 3'b100;

    // Internal Signals
    reg [2:0] state;
    reg [2:0] next_state;
    reg [2:0] data_bit_count;  // Counter for data bits

    // State Transition Logic
    always @(*) begin
        next_state = state;
        done = 1'b0;  // Default: not done

        case (state)
            IDLE: begin
                if (in == 1'b0) begin // Start bit detected
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (data_bit_count == 7) begin
                    next_state = STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in == 1'b1) begin // Valid stop bit
                    next_state = IDLE;
                    done = 1'b1;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1'b1) begin // Wait for stop bit
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // State Register (Synchronous Update)
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_bit_count <= 3'b000;
        end else begin
            state <= next_state;
            if (state == DATA_BITS) begin
                if (data_bit_count < 7) begin
                    data_bit_count <= data_bit_count + 1;
                end
            end else if (state != DATA_BITS) begin
                data_bit_count <= 3'b000; // Reset counter
            end
        end
    end

endmodule