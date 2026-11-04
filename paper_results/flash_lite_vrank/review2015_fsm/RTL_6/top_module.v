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
    parameter CHECKING = 1;
    parameter SHIFTING = 2;
    parameter COUNTING_WAIT = 3;
    parameter NOTIFY = 4;
    
    reg [2:0] state;
    reg [3:0] data_buffer;
    reg [1:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
            bit_count <= 2'b00;
        end else begin
            case (state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    bit_count <= 2'b00;
                    if (data == 1'b1) begin
                        state <= CHECKING;
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECKING: begin
                    if (data == 1'b1) begin
                        state <= CHECKING;
                    end else begin
                        state <= IDLE;
                    end
                end
                CHECKING: begin
                    if (data == 1'b0) begin
                         state <= SHIFTING;
                         bit_count <= 2'b00;
                    end else begin
                        state <= CHECKING;
                    end
                end
                SHIFTING: begin
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 2'b11) begin
                        state <= COUNTING_WAIT;
                        bit_count <= 2'b00;
                    end else begin
                         state <= SHIFTING;
                    end
                end
                COUNTING_WAIT: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                    if (done_counting) begin
                        state <= NOTIFY;
                    end else begin
                         state <= COUNTING_WAIT;
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
                    bit_count <= 2'b00;
                end
            endcase
        end
    end
endmodule