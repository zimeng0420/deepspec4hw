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

    // Define states
    parameter IDLE = 0,
              DETECT = 1,
              SHIFT = 2,
              COUNTING = 3,
              NOTIFY = 4;

    reg [2:0] state;
    reg [3:0] data_buffer; // Buffer for the 4-bit pattern detection

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (data_buffer == 4'b1101) begin
                        state <= SHIFT;
                    end
                    else begin
                        state <= (data_buffer[2:0] == 3'b110) ? DETECT : IDLE;
                    end
                    data_buffer <= {data_buffer[2:0], data};
                end

                DETECT: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    data_buffer <= {data_buffer[2:0], data};
                    if (data_buffer == 4'b1101) begin
                        state <= SHIFT;
                    end
                    else begin
                       state <= IDLE;
                    end
                end

                SHIFT: begin
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    data_buffer <= {data_buffer[2:0], data};
                    if (shift_ena) begin
                        state <= SHIFT;
                    end
                    else begin
                      state <= COUNTING;
                    end

                end

                COUNTING: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                    if (done_counting) begin
                        state <= NOTIFY;
                    end
                end

                NOTIFY: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) begin
                        state <= IDLE;
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