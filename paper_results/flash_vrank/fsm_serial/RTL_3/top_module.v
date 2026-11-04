module top_module (
    input clk,
    input in,
    input reset,
    output done
);

    reg [3:0] state;
    reg done_r;

    parameter IDLE = 4'b0000;
    parameter START = 4'b0001;
    parameter DATA0 = 4'b0010;
    parameter DATA1 = 4'b0011;
    parameter DATA2 = 4'b0100;
    parameter DATA3 = 4'b0101;
    parameter DATA4 = 4'b0110;
    parameter DATA5 = 4'b0111;
    parameter DATA6 = 4'b1000;
    parameter DATA7 = 4'b1001;
    parameter STOP = 4'b1010;
    parameter WAIT_STOP = 4'b1011;


    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_r <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done_r <= 0;
                    if (in == 0) begin
                        state <= START;
                    end
                end
                START: begin
                    state <= DATA0;
                end
                DATA0: begin
                    state <= DATA1;
                end
                DATA1: begin
                    state <= DATA2;
                end
                DATA2: begin
                    state <= DATA3;
                end
                DATA3: begin
                    state <= DATA4;
                end
                DATA4: begin
                    state <= DATA5;
                end
                DATA5: begin
                    state <= DATA6;
                end
                DATA6: begin
                    state <= DATA7;
                end
                DATA7: begin
                    state <= STOP;
                end
                STOP: begin
                    if (in == 1) begin
                        state <= IDLE;
                        done_r <= 1;
                    end else begin
                        state <= WAIT_STOP;
                        done_r <= 0;
                    end
                end
                WAIT_STOP: begin
                    done_r <= 0;
                    if (in == 1) begin
                        state <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE;
                    done_r <= 0;
                end
            endcase
        end
    end

    assign done = done_r;

endmodule