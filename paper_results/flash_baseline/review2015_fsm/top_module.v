module top_module(
	input clk,
	input reset,
	input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    reg [3:0] state;

    localparam IDLE = 4'b0000;
    localparam BIT1 = 4'b0001;
    localparam BIT2 = 4'b0010;
    localparam BIT3 = 4'b0011;
    localparam SHIFT1 = 4'b0100;
    localparam SHIFT2 = 4'b0101;
    localparam SHIFT3 = 4'b0110;
    localparam SHIFT4 = 4'b0111;
    localparam COUNTING = 4'b1000;
    localparam DONE = 4'b1001;

    always @(posedge clk) begin
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
                        state <= BIT1;
                    end
                end
                BIT1: begin
                    if (data == 1) begin
                        state <= BIT2;
                    end else begin
                        state <= IDLE;
                    end
                end
                BIT2: begin
                    if (data == 0) begin
                        state <= BIT3;
                    end else begin
                        state <= IDLE;
                    end
                end
                BIT3: begin
                    if (data == 1) begin
                        state <= SHIFT1;
                        shift_ena <= 1;
                    end else begin
                        state <= IDLE;
                    end
                end
                SHIFT1: begin
                    state <= SHIFT2;
                    shift_ena <= 1;
                end
                SHIFT2: begin
                    state <= SHIFT3;
                    shift_ena <= 1;
                end
                SHIFT3: begin
                    state <= SHIFT4;
                    shift_ena <= 1;
                end
                SHIFT4: begin
                    state <= COUNTING;
                    shift_ena <= 0;
                    counting <= 1;
                end
                COUNTING: begin
                    counting <= 1;
                    if (done_counting) begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end
                end
                DONE: begin
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
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