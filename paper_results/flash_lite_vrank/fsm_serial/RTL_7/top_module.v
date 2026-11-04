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

    reg [2:0] state, next_state;
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
            done_reg <= (next_state == STOP);
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                done_reg = 1'b0;
                if (!in) begin
                    next_state = START;
                end
            end
            START: begin
                if (in) begin
                   next_state = ERROR;
                end else {
                  next_state = DATA;
                  bit_count = 3'b000;
                }

            end
            DATA: begin
                data_reg[bit_count] = in;
                if (bit_count == 7) begin
                   next_state = STOP;
                end else begin
                    next_state = DATA;
                end
                bit_count = bit_count + 1'b1;

            end
            STOP: begin
                if (in) begin
                    next_state = IDLE;
                } else {
                    next_state = ERROR;
                }
            end
            ERROR: begin
                if (in) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            WAIT_STOP: begin
                if (in) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule