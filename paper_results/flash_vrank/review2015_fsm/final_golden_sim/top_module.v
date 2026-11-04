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
    localparam S1 = 4'b0001;
    localparam S2 = 4'b0010;
    localparam S3 = 4'b0011;
    localparam SHIFT = 4'b0100;
    localparam COUNTING = 4'b0101;
    localparam DONE = 4'b0110;

    reg [2:0] shift_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data) begin
                        state <= S1;
                    end else begin
                        state <= IDLE;
                    end
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                end
                S1: begin
                    if (data) begin
                        state <= S2;
                    end else begin
                        state <= IDLE;
                    end
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                end
                S2: begin
                    if (~data) begin
                        state <= S3;
                    end else begin
                        state <= IDLE;
                    end
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                end
                S3: begin
                    if (data) begin
                        state <= SHIFT;
                        shift_count <= 3'b000;
                    end else begin
                        state <= IDLE;
                    end
                    shift_ena <= 1;
                    counting <= 0;
                    done <= 0;
                end
                SHIFT: begin
                    if (shift_count < 3'b111) begin
                        state <= SHIFT;
                        shift_count <= shift_count + 1'b1;
                        shift_ena <= 1;
                        counting <= 0;
                        done <= 0;
                    end else begin
                        state <= COUNTING;
                        shift_ena <= 0;
                        counting <= 1;
                        done <= 0;
                    end
                end
                COUNTING: begin
                    shift_ena <= 0;
                    counting <= 1;
                    done <= 0;
                    if (done_counting) begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end else begin
                        state <= COUNTING;
                    end
                end
                DONE: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end else begin
                        state <= DONE;
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