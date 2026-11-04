module top_module(
	input clk,
	input reset,
	input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    parameter IDLE = 0;
    parameter CHECK_1 = 1;
    parameter CHECK_2 = 2;
    parameter CHECK_3 = 3;
    parameter SHIFT = 4;
    parameter COUNT = 5;
    parameter NOTIFY = 6;

    reg [2:0] state;
    reg [3:0] data_buffer;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
            data_buffer <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (data == 1'b1) begin
                        state <= CHECK_1;
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECK_1: begin
                    if (data == 1'b1) begin
                        state <= CHECK_2;
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECK_2: begin
                    if (data == 1'b0) begin
                        state <= CHECK_3;
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECK_3: begin
                    if (data == 1'b1) begin
                        state <= SHIFT;
                        i <= 0;
                    end else begin
                        state <= IDLE;
                    end
                end
                SHIFT: begin
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (i < 3) begin
                        i <= i + 1;
                        state <= SHIFT;
                    end else begin
                        state <= COUNT;
                    end
                end
                COUNT: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                    if (done_counting) begin
                        state <= NOTIFY;
                    end else begin
                        state <= COUNT;
                    end
                end
                NOTIFY: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) begin
                        state <= IDLE;
                    end else begin
                        state <= NOTIFY;
                    end
                end
                default: begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule