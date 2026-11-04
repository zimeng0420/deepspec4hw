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
    localparam IDLE = 0;
    localparam BIT1 = 1;
    localparam BIT2 = 2;
    localparam BIT3 = 3;
    localparam SHIFTING = 4;
    localparam COUNTING_STATE = 5;
    localparam DONE_STATE = 6;

    // State variable
    reg [2:0] state;

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
                        state <= SHIFTING;
                        shift_ena <= 1;
                    end else begin
                        state <= IDLE;
                    end
                end
                SHIFTING: begin
                    if (shift_ena) begin
                        shift_ena <= 1;
                        state <= SHIFTING;
                    end
                    else begin
                        shift_ena <= 0;
                        state <= COUNTING_STATE;
                        counting <= 1;
                    end

                end
                COUNTING_STATE: begin
                    shift_ena <= 0;
                    counting <= 1;
                    if (done_counting) begin
                        state <= DONE_STATE;
                        counting <= 0;
                        done <= 1;
                    end
                end
                DONE_STATE: begin
                    shift_ena <= 0;
                    counting <= 0;
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

    // Counter for shift_ena
    reg [1:0] shift_count;

    always @(posedge clk) begin
        if (reset) begin
            shift_count <= 0;
        end else if (state == SHIFTING) begin
            if (shift_count < 3) begin
                shift_count <= shift_count + 1;
                shift_ena <= 1;
            end else begin
                shift_count <= 0;
                shift_ena <= 0;
            end
        end else begin
            shift_count <= 0;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 0;
        end else if (state == SHIFTING && shift_count < 3) begin
            shift_ena <= 1;
        end else begin
            shift_ena <= 0;
        end
    end

endmodule