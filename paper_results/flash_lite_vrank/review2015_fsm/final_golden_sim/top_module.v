module top_module(
	input clk,
	input reset,
	input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack
);

    // State Definitions
    parameter IDLE = 0;
    parameter CHECK_1 = 1;
    parameter CHECK_2 = 2;
    parameter CHECK_3 = 3;
    parameter SHIFT = 4;
    parameter COUNTING_STATE = 5;
    parameter DONE_STATE = 6;

    reg [2:0] state;
    reg [3:0] data_buffer;
    reg [3:0] shift_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            data_buffer <= 4'b0000;
            shift_count <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                    if (data == 1) begin
                        state <= CHECK_1;
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECK_1: begin
                    if (data == 1) begin
                        state <= CHECK_2;
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECK_2: begin
                    if (data == 0) begin
                        state <= CHECK_3;
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECK_3: begin
                    if (data == 1) begin
                        state <= SHIFT;
                        shift_count <= 4'b0000;
                    end else begin
                        state <= IDLE;
                    end
                end
                SHIFT: begin
                    shift_ena <= 1;
                    counting <= 0;
                    done <= 0;
                     if (shift_count < 4) begin
                        shift_count <= shift_count + 1'b1;
                    end else begin
                       state <= COUNTING_STATE;
                    end
                 end
                COUNTING_STATE: begin
                    shift_ena <= 0;
                    counting <= 1;
                    done <= 0;
                    if (done_counting) begin
                        state <= DONE_STATE;
                    end else begin
                        state <= COUNTING_STATE;
                    end
                end
                DONE_STATE: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                    end else begin
                        state <= DONE_STATE;
                    end
                end
                default: begin
                    state <= IDLE;
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                end
            endcase
        end
    end

endmodule