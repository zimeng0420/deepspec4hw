module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    parameter IDLE = 0;
    parameter DETECT = 1;
    parameter LOAD = 2;
    parameter COUNTING = 3;
    parameter WAIT_ACK = 4;

    reg [2:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [3:0] counter;
    reg [3:0] count_internal;
    reg [15:0] cycle_count; // Increased width for longer delays

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            delay <= 4'b0000;
            counter <= 4'b0000;
            cycle_count <= 16'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count_internal <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= DETECT;
                    end else begin
                        state <= IDLE;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                    count_internal <= 4'b0;

                end
                DETECT: begin
                    shift_reg <= {shift_reg[2:0], data};
                    state <= LOAD;

                end
                LOAD: begin
                    delay <= shift_reg[3:0];
                    cycle_count <= 16'b0;
                    counter <= delay;
                    state <= COUNTING;
                    counting <= 1'b1;
                end

                COUNTING: begin
                   if (cycle_count < ((delay + 1) * 1000) - 1) begin
                        cycle_count <= cycle_count + 1'b1;
                   end else begin
                       cycle_count <= 16'b0;
                       counter <= counter - 1'b1;
                       if (counter == 0)
                            state <= WAIT_ACK;
                   end
                   count_internal <= counter;
                   counting <= 1'b1;
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end

                default: begin
                    state <= IDLE;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    assign count = (counting == 1'b1) ? count_internal : 4'b0000;  // count is only valid when counting, otherwise don't care
end