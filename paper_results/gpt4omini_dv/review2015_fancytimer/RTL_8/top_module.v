module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    reg [3:0] delay;
    reg [19:0] timer; // To count 1000 cycles
    reg [3:0] state; // State register
    reg [3:0] bit_buffer; // To hold bits for pattern matching
    reg [3:0] current_delay;

    // State encoding
    localparam IDLE = 4'd0,
               DETECT = 4'd1,
               SHIFT = 4'd2,
               COUNT = 4'd3,
               DONE = 4'd4;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 4'b0000;
            counting <= 0;
            done <= 0;
            timer <= 20'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Looking for the pattern 1101 (0xD)
                    bit_buffer <= {bit_buffer[2:0], data};
                    if (bit_buffer == 4'b1101) begin
                        state <= SHIFT;
                    end
                end

                SHIFT: begin
                    // Shift in the next 4 bits for delay
                    delay <= {data, bit_buffer[2:0]};
                    current_delay <= delay + 1; // Total duration is delay + 1
                    count <= delay; // Set initial count
                    counting <= 1;
                    timer <= 0;
                    state <= COUNT;
                end

                COUNT: begin
                    if (timer < 20'd999999) begin // Count for 1000 cycles
                        timer <= timer + 1;
                    end else begin
                        if (count > 0) begin
                            count <= count - 1; // Decrement count every 1000 cycles
                        end else begin
                            done <= 1; // Signal done when timer is done
                            counting <= 0;
                            state <= DONE;
                        end
                        timer <= 0; // Reset timer for the next cycle
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE; // Reset to look for the next pattern
                        done <= 0; // Reset done signal
                        count <= 4'b0000;
                    end
                end

                default: state <= IDLE; // Default state
            endcase
        end
    end
endmodule