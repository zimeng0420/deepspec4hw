module top_module (
    input clk,
    input in,
    input reset,
    output done
);

    parameter IDLE = 0,
              START_BIT = 1,
              DATA_BITS = 2,
              STOP_BIT = 3,
              ERROR = 4;

    reg [2:0] state, next_state;
    reg [7:0] data_bits;
    reg [2:0] bit_count;
    reg done_r;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_r <= 0;
            bit_count <= 0;
        end else begin
            state <= next_state;
            done_r <= (state == STOP_BIT && next_state == IDLE) ? 1 : 0;
        end
    end

    always @(*) begin
        next_state = state;
        done = done_r;

        case (state)
            IDLE: begin
                if (~in) begin
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                next_state = DATA_BITS;
                bit_count = 0;
            end
            DATA_BITS: begin
                data_bits[bit_count] = in;
                if (bit_count == 7) begin
                    next_state = STOP_BIT;
                end else begin
                    next_state = DATA_BITS;
                    bit_count = bit_count + 1;
                end
            end
            STOP_BIT: begin
                if (in) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if(in) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = ERROR;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule