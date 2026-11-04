module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    // Define states
    localparam IDLE        = 4'b0001;
    localparam ONE         = 4'b0010;
    localparam ONE_ONE     = 4'b0011;
    localparam ONE_ONE_ZERO= 4'b0100;
    localparam SHIFT       = 4'b0101;
    localparam COUNT       = 4'b0110;
    localparam DONE_STATE  = 4'b0111;

    reg [3:0] state;

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
                        state <= ONE;
                    end else begin
                        state <= IDLE;
                    end
                end
                ONE: begin
                    if (data == 1) begin
                        state <= ONE_ONE;
                    end else begin
                        state <= IDLE;
                    end
                end
                ONE_ONE: begin
                    if (data == 0) begin
                        state <= ONE_ONE_ZERO;
                    end else begin
                        state <= ONE_ONE;
                    end
                end
                ONE_ONE_ZERO: begin
                    if (data == 1) begin
                        state <= SHIFT;
                        shift_ena <= 1;
                    end else begin
                        state <= IDLE;
                        shift_ena <= 0;
                    end
                end
                SHIFT: begin
                    if (data) begin
                        shift_ena <= 1;
                    end else begin
                        shift_ena <= 1;
                    end
                    state <= COUNT;
                    counting <= 1;
                    shift_ena <= 0;
                end
                COUNT: begin
                    shift_ena <= 0;
                    counting <= 1;
                    if (done_counting) begin
                        state <= DONE_STATE;
                        counting <= 0;
                        done <= 1;
                    end else begin
                        state <= COUNT;
                    end
                end
                DONE_STATE: begin
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
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