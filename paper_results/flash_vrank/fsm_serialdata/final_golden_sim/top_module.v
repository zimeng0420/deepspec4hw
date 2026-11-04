module top_module (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    parameter IDLE = 0, START = 1, DATA0 = 2, DATA1 = 3, DATA2 = 4, DATA3 = 5,
              DATA4 = 6, DATA5 = 7, DATA6 = 8, DATA7 = 9, STOP = 10, ERROR = 11;

    reg [3:0] state, next_state;
    reg [7:0] data_reg;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            done_reg <= 0;
        end
    end

    always @(*) begin
        next_state = state;
        out_byte = data_reg;
        done = done_reg;

        case (state)
            IDLE: begin
                if (in == 0) begin
                    next_state = START;
                    data_reg = 0;
                end else begin
                    next_state = IDLE;
                end
            end
            START: next_state = DATA0;
            DATA0: begin
                data_reg[0] = in;
                next_state = DATA1;
            end
            DATA1: begin
                data_reg[1] = in;
                next_state = DATA2;
            end
            DATA2: begin
                data_reg[2] = in;
                next_state = DATA3;
            end
            DATA3: begin
                data_reg[3] = in;
                next_state = DATA4;
            end
            DATA4: begin
                data_reg[4] = in;
                next_state = DATA5;
            end
            DATA5: begin
                data_reg[5] = in;
                next_state = DATA6;
            end
            DATA6: begin
                data_reg[6] = in;
                next_state = DATA7;
            end
            DATA7: begin
                data_reg[7] = in;
                next_state = STOP;
            end
            STOP: begin
                if (in == 1) begin
                    next_state = IDLE;
                    done_reg = 1;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
              if (in == 1) begin
                next_state = IDLE;
              end
              else begin
                next_state = ERROR;
              end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule