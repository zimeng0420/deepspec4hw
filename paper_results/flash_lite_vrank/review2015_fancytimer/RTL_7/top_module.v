module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    // States
    localparam IDLE = 0,
               READ_PATTERN = 1,
               READ_DELAY = 2,
               COUNTING = 3,
               DONE = 4;

    reg [2:0] state;
    reg [3:0] pattern_buffer;
    reg [3:0] delay;
    reg [3:0] counter;
    reg [15:0] cycle_counter; //Counter for counting 1000 clock cycles.

    // State machine logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            counter <= 0;
            cycle_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_buffer <= {pattern_buffer[2:0], data};
                    if (pattern_buffer == 4'b1101) begin
                        state <= READ_DELAY;
                    end
                    counting <= 0;
                    done <= 0;
                end
                READ_DELAY: begin
                    delay <= {delay[2:0], data};
                    state <= COUNTING;
                    counting <= 1;
                    counter <= delay;
                    cycle_counter <= 0;
                end
                COUNTING: begin
                    if(cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (counter > 0) begin
                            counter <= counter - 1;
                        end else begin
                            state <= DONE;
                            counting <= 0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
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
                    counting <= 0;
                    done <= 0;
                end
            endcase
        end
    end

    // Count output logic
    assign count = (counting) ? counter : 4'b0000; // Display the counter value while counting.

endmodule