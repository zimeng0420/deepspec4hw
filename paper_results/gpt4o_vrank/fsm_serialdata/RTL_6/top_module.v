module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum reg [2:0] {IDLE, START, RECEIVE, STOP, ERROR} state_t;
    state_t state, next_state;
    reg [2:0] bit_counter;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 0;
            shift_reg <= 0;
            out_byte <= 8'b0;
            done <= 0;
        end else begin
            state <= next_state;
            case (next_state)
                IDLE: begin
                    done <= 0;
                end
                START: begin
                    shift_reg <= 8'b0;
                    bit_counter <= 0;
                end
                RECEIVE: begin
                    shift_reg[bit_counter] <= in;
                    bit_counter <= bit_counter + 1;
                end
                STOP: begin
                    out_byte <= shift_reg;
                    done <= 1;
                end
                ERROR: begin
                    done <= 0;
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 0)
                    next_state = START;
            end
            START: begin
                if (in == 1 && bit_counter == 0)
                    next_state = ERROR;
                else if (bit_counter == 7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            RECEIVE: begin
                if (bit_counter == 7)
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            ERROR: begin
                if (in == 1)
                    next_state = IDLE;
            end
        endcase
    end

endmodule