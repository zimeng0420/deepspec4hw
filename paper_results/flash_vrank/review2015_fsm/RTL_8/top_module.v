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
    parameter IDLE = 4'b0000;
    parameter S1 = 4'b0001;
    parameter S2 = 4'b0010;
    parameter S3 = 4'b0011;
    parameter SHIFT = 4'b0100;
    parameter COUNTING = 4'b0101;
    parameter DONE = 4'b0110;


    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data) begin
                        state <= S1;
                    end else begin
                        state <= IDLE;
                    end
                end
                S1: begin
                    if (data) begin
                        state <= S2;
                    end else begin
                        state <= IDLE;
                    end
                end
                S2: begin
                    if (~data) begin
                        state <= S3;
                    end else begin
                        state <= IDLE;
                    end
                end
                S3: begin
                    if (data) begin
                        state <= SHIFT;
                        shift_ena <= 1;
                    end else begin
                        state <= IDLE;
                    end
                end
                SHIFT: begin
                    if (shift_ena) begin
                        state <= SHIFT;
                        shift_ena <= 1;
                    end
                     else begin
                        state <= COUNTING;
                        shift_ena <= 0;
                        counting <= 1;
                    end


                    if (state == SHIFT)
                        if (shift_ena) begin
                            static integer shift_count;
                            shift_count = shift_count + 1;
                            if(shift_count == 4) begin
                                shift_ena <= 0;
                                shift_count <= 0;
                            end
                            else
                                shift_ena <= 1;

                        end
                    else;



                    if (!shift_ena && state==SHIFT)
                        state <= COUNTING;
                end
                COUNTING: begin
                    shift_ena <= 0;
                    counting <= 1;
                    if (done_counting) begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end else begin
                        state <= COUNTING;
                    end
                end
                DONE: begin
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