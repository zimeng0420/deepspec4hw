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
    reg [19:0] cycle_count; // To count up to (delay + 1) * 1000
    reg [3:0] state;       
    reg [3:0] bits_received;
    
    localparam IDLE = 4'b0000, 
               WAIT_PATTERN = 4'b0001,
               SHIFT_DELAY = 4'b0010,
               COUNTING = 4'b0011,
               DONE = 4'b0100;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
            cycle_count <= 20'b0;
            bits_received <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (data) begin
                        state <= WAIT_PATTERN;
                        bits_received <= 4'b0000; // Reset bits received counter
                    end
                end

                WAIT_PATTERN: begin
                    if (bits_received < 3) begin
                        bits_received <= bits_received + 1;
                    end else if (data && bits_received == 3) begin
                        state <= SHIFT_DELAY; // If 1101 detected
                        delay <= 4'b0000;      // Prepare to receive delay bits
                    end else begin
                        bits_received <= 4'b0000; // Reset if the sequence isn't matched
                        state <= IDLE;
                    end
                end

                SHIFT_DELAY: begin
                    if (bits_received < 4) begin
                        delay <= {delay[2:0], data}; // Shift in the delay bits
                        bits_received <= bits_received + 1;
                    end else begin
                        state <= COUNTING; // Move to counting after getting 4 bits
                        cycle_count <= 20'b0; // Reset cycle counter
                        counting <= 1'b1;
                    end
                end

                COUNTING: begin
                    if (cycle_count < (delay + 1) * 1000 - 1) begin
                        cycle_count <= cycle_count + 1;
                        if (cycle_count % 1000 == 0) begin
                            if (count > 0) count <= count - 1; // Decrement count every 1000 cycles
                        end
                    end else begin
                        done <= 1'b1;
                        counting <= 1'b0;
                        state <= DONE;
                    end
                end

                DONE: begin
                    count <= 4'bxxxx; // Don't-care state output when done
                    if (ack) begin
                        state <= IDLE; // Wait for acknowledge to reset
                    end
                end
            endcase
        end
    end

endmodule