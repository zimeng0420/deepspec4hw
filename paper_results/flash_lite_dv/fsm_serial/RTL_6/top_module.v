module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State Definitions
    parameter IDLE      = 3'b000;
    parameter START_BIT = 3'b001;
    parameter DATA_BITS = 3'b010;
    parameter STOP_BIT  = 3'b011;
    parameter ERROR     = 3'b100;

    // Internal Signals
    reg [2:0] state;
    reg [2:0] next_state;
    reg [2:0] bit_count;
    reg data_bit_reg;

    // State Transition Logic
    always @(*) begin
        next_state = state;
        done = 1'b0; // Default value

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
                if (bit_count == 7) begin // 8 data bits received
                    next_state = STOP_BIT;
                end else begin
                    next_state = DATA_BITS;
                end
            end
            STOP_BIT: begin
                if (in) begin // Stop bit (1) received
                    next_state = IDLE;
                    done = 1'b1;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in) begin // Wait for stop bit (1)
                    next_state = IDLE;
                end
            end
            default:
                next_state = IDLE;
        endcase
    end

    // State Register and Bit Counter Update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b000;
        end else begin
            state <= next_state;
            if (state == DATA_BITS && next_state == DATA_BITS) begin
                bit_count <= bit_count + 1'b1;
            end else if (next_state == IDLE) begin
                bit_count <= 3'b000;
            end
        end
    end

endmodule