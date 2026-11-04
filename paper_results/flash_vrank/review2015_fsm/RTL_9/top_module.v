module top_module(
	input clk,
	input reset,
	input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    // Define the states
    localparam IDLE       = 0;
    localparam BIT1       = 1;
    localparam BIT2       = 2;
    localparam BIT3       = 3;
    localparam SHIFT      = 4;
    localparam COUNTING_S = 5;
    localparam DONE       = 6;

    // State variable
    reg [2:0] state;

    // Counter for shift enable
    reg [1:0] shift_count;

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
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                    if (data) begin
                        state <= BIT1;
                    end
                end
                BIT1: begin
                    if (data) begin
                        state <= BIT2;
                    end else begin
                        state <= IDLE;
                    end
                end
                BIT2: begin
                    if (!data) begin
                        state <= BIT3;
                    end else begin
                        state <= IDLE;
                    end
                end
                BIT3: begin
                    if (data) begin
                        state <= SHIFT;
                        shift_ena <= 1;
                        shift_count <= 0;
                    end else begin
                        state <= IDLE;
                    end
                end
                SHIFT: begin
                    if (shift_count < 3) begin
                        shift_count <= shift_count + 1;
                        shift_ena <= 1;
                        state <= SHIFT;
                    end else begin
                        shift_ena <= 0;
                        counting <= 1;
                        state <= COUNTING_S;
                    end
                end
                COUNTING_S: begin
                    counting <= 1;
                    if (done_counting) begin
                        counting <= 0;
                        done <= 1;
                        state <= DONE;
                    end else begin
                        state <= COUNTING_S;
                    end
                end
                DONE: begin
                    done <= 1;
                    if (ack) begin
                        done <= 0;
                        state <= IDLE;
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