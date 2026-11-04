module top_module(
	input clk,
	input reset,
	input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    parameter IDLE = 0,
              CHECK_1 = 1,
              CHECK_2 = 2,
              CHECK_3 = 3,
              SHIFT = 4,
              WAIT_COUNT = 5,
              DONE_WAIT = 6;

    reg [2:0] state;
    reg [3:0] data_buffer;
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
            i <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (data == 1'b1) begin
                        state <= CHECK_1;
                        data_buffer[3:0] <= {3'b0, data}; // Initialize data_buffer
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECK_1: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    data_buffer[3:0] <= {data_buffer[2:0], data};
                    if (data == 1'b1) begin
                        state <= CHECK_2;
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECK_2: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    data_buffer[3:0] <= {data_buffer[2:0], data};
                    if (data == 1'b0) begin
                        state <= CHECK_3;
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECK_3: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    data_buffer[3:0] <= {data_buffer[2:0], data};
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
                    data_buffer[3:0] <= {data_buffer[2:0], data};
                    i <= i + 1;
                    if (i == 3) begin
                        state <= WAIT_COUNT;
                        i <= 0; // reset i for next use (not strictly needed but good practice)
                    end else begin
                        state <= SHIFT;
                    end
                end
                WAIT_COUNT: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                    if (done_counting) begin
                        state <= DONE_WAIT;
                    end else begin
                        state <= WAIT_COUNT;
                    end
                end
                DONE_WAIT: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) begin
                        state <= IDLE;
                    end else begin
                        state <= DONE_WAIT;
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