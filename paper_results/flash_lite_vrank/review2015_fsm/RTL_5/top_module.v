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

    // States
    parameter IDLE = 0;
    parameter CHECK_1 = 1;
    parameter CHECK_2 = 2;
    parameter CHECK_3 = 3;
    parameter SHIFT = 4;
    parameter COUNTING_STATE = 5;
    parameter DONE_STATE = 6;

    reg [2:0] state;
    reg [3:0] data_buffer; // for checking the pattern

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                    if (data == 1) begin
                        state <= CHECK_1;
                        data_buffer[3:0] <= {3{1'b0}, data}; // Initialize the buffer with the first data bit
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECK_1: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                    data_buffer[3:1] <= data_buffer[2:0];
                    data_buffer[0] <= data;
                    if (data == 1) begin
                        state <= CHECK_2;
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECK_2: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                    data_buffer[3:1] <= data_buffer[2:0];
                    data_buffer[0] <= data;
                    if (data == 0) begin
                        state <= CHECK_3;
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECK_3: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                    data_buffer[3:1] <= data_buffer[2:0];
                    data_buffer[0] <= data;
                    if (data == 1) begin
                        state <= SHIFT;
                    end else begin
                        state <= IDLE;
                    end
                end
                SHIFT: begin
                    shift_ena <= 1;
                    counting <= 0;
                    done <= 0;
                    if (data_buffer[3:0] == 4'b1101) begin //Added this check to be safe in edge cases
                        if (shift_ena == 1)
                           shift_ena <= 1;
                        else
                            shift_ena <= 0;
                        if ($countbits({shift_ena,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}) == 4) begin
                          state <= COUNTING_STATE;
                        end else begin
                            state <= SHIFT;
                        end
                    end else begin
                         state <= IDLE; //Go back to idle state in case the initial pattern is not met.
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