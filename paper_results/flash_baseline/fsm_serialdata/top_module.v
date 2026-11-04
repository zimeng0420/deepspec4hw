module top_module (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    reg [3:0] state;
    reg [7:0] data_reg;
    reg done_reg;

    localparam IDLE = 0;
    localparam START = 1;
    localparam DATA0 = 2;
    localparam DATA1 = 3;
    localparam DATA2 = 4;
    localparam DATA3 = 5;
    localparam DATA4 = 6;
    localparam DATA5 = 7;
    localparam DATA6 = 8;
    localparam DATA7 = 9;
    localparam STOP = 10;
    localparam WAIT_STOP = 11;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 0;
            done_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done_reg <= 0;
                    if (in == 0) begin
                        state <= START;
                    end
                end
                START: begin
                    state <= DATA0;
                    data_reg[0] <= in;
                end
                DATA0: begin
                    state <= DATA1;
                    data_reg[1] <= in;
                end
                DATA1: begin
                    state <= DATA2;
                    data_reg[2] <= in;
                end
                DATA2: begin
                    state <= DATA3;
                    data_reg[3] <= in;
                end
                DATA3: begin
                    state <= DATA4;
                    data_reg[4] <= in;
                end
                DATA4: begin
                    state <= DATA5;
                    data_reg[5] <= in;
                end
                DATA5: begin
                    state <= DATA6;
                    data_reg[6] <= in;
                end
                DATA6: begin
                    state <= DATA7;
                    data_reg[7] <= in;
                end
                DATA7: begin
                    if (in == 1) begin
                        state <= STOP;
                        done_reg <= 1;
                    end else begin
                        state <= WAIT_STOP;
                        done_reg <= 0;
                    end
                end
                STOP: begin
                    state <= IDLE;
                    done_reg <= 1;
                end
                WAIT_STOP: begin
                    done_reg <= 0;
                    if (in == 1) begin
                        state <= STOP;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end
                default: begin
                    state <= IDLE;
                    done_reg <= 0;
                end
            endcase
        end
    end

    assign out_byte = data_reg;
    assign done = done_reg;

endmodule