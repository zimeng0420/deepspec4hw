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
    parameter IDLE = 0;
    parameter S1 = 1;
    parameter S2 = 2;
    parameter S3 = 3;
    parameter SHIFT = 4;
    parameter COUNTING = 5;
    parameter DONE_STATE = 6;

    // State register
    reg [2:0] state;

    // Internal registers
    reg [3:0] data_buffer;
    reg [1:0] shift_count;

    // FSM Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
            shift_count <= 2'b0;
            data_buffer <= 4'b0;

        end else begin
            case (state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                     shift_count <= 2'b0;
                    data_buffer <= {data_buffer[2:0], data};
                    if (data_buffer == 4'b1101) begin
                        state <= SHIFT;
                    end else begin
                        state <= IDLE;
                    end
                end
                SHIFT: begin
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;

                     if (shift_count == 2'b11) begin // Shift 4 bits total
                        state <= COUNTING;
                        shift_count <= 2'b0;
                    end else begin
                         shift_count <= shift_count + 1'b1;
                        state <= SHIFT;
                    end

                end
                COUNTING: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                    if (done_counting) begin
                        state <= DONE_STATE;
                    end else begin
                        state <= COUNTING;
                    end
                end
                DONE_STATE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) begin
                        state <= IDLE;
                    end else begin
                        state <= DONE_STATE;
                    end
                end

                default: begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    shift_count <= 2'b0;
                    data_buffer <= 4'b0;
                end
            endcase
        end
    end

endmodule