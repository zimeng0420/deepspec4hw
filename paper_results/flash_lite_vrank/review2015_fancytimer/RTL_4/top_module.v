module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State Definitions
    localparam IDLE = 0;
    localparam READ_SEQUENCE = 1;
    localparam READ_DELAY = 2;
    localparam COUNTING = 3;
    localparam DONE_WAIT = 4;

    // Internal Signals
    reg [2:0] state;
    reg [3:0] sequence_buffer;
    reg [3:0] delay;
    reg [3:0] counter;
    reg [3:0] remaining_delay;
    reg [31:0] cycle_counter;  // Counter for clock cycles

    // Default Output Assignments
    assign count = (counting) ? remaining_delay : 4'b0; // count is don't care when not counting
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            sequence_buffer <= 4'b0;
            delay <= 4'b0;
            counter <= 4'b0;
            remaining_delay <= 4'b0;
            cycle_counter <= 0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    sequence_buffer <= {sequence_buffer[2:0], data};
                    if (sequence_buffer == 4'b1101) begin
                        state <= READ_DELAY;
                    end
                end
                READ_DELAY: begin
                    sequence_buffer <= {sequence_buffer[2:0], data};
                    delay <= sequence_buffer[3:0];
                    remaining_delay <= delay;
                    cycle_counter <= 0;
                    state <= COUNTING;
                    counting <= 1'b1;
                end
                COUNTING: begin
                    cycle_counter <= cycle_counter + 1;
                    if (cycle_counter == 1000) begin
                        cycle_counter <= 0;
                        if (remaining_delay > 0) begin
                            remaining_delay <= remaining_delay - 1;
                        end else begin
                            state <= DONE_WAIT;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end
                    end
                end
                DONE_WAIT: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                        sequence_buffer <= 4'b0;
                        delay <= 4'b0;
                        remaining_delay <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule