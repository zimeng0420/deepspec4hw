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

    localparam IDLE = 4'b0000;
    localparam START = 4'b0001;
    localparam DATA0 = 4'b0010;
    localparam DATA1 = 4'b0011;
    localparam DATA2 = 4'b0100;
    localparam DATA3 = 4'b0101;
    localparam DATA4 = 4'b0110;
    localparam DATA5 = 4'b0111;
    localparam DATA6 = 4'b1000;
    localparam DATA7 = 4'b1001;
    localparam STOP = 4'b1010;
    localparam WAIT_STOP = 4'b1011;

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
                end
                DATA0: begin
                    data_reg[0] <= in;
                    state <= DATA1;
                end
                DATA1: begin
                    data_reg[1] <= in;
                    state <= DATA2;
                end
                DATA2: begin
                    data_reg[2] <= in;
                    state <= DATA3;
                end
                DATA3: begin
                    data_reg[3] <= in;
                    state <= DATA4;
                end
                DATA4: begin
                    data_reg[4] <= in;
                    state <= DATA5;
                end
                DATA5: begin
                    data_reg[5] <= in;
                    state <= DATA6;
                end
                DATA6: begin
                    data_reg[6] <= in;
                    state <= DATA7;
                end
                DATA7: begin
                    data_reg[7] <= in;
                    state <= STOP;
                end
                STOP: begin
                    if (in == 1) begin
                        state <= IDLE;
                        done_reg <= 1;
                    end else begin
                        state <= WAIT_STOP;
                        done_reg <= 0;
                    end
                end
                WAIT_STOP: begin
                    done_reg <= 0;
                    if (in == 1) begin
                        state <= IDLE;
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