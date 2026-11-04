module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    reg [3:0] delay; // Stores the delay value
    reg [3:0] state; // States 0: searching, 1: counting, 2: done
    reg [19:0] cycle_counter; // Counts cycles
    reg [3:0] remaining_delay; // Counts down the remaining time

    // States
    localparam SEARCH = 0, COUNT = 1, DONE = 2;

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            cycle_counter <= 20'b0;
            remaining_delay <= 4'b0;
        end else begin
            case (state)
                SEARCH: begin
                    if (data == 1'b1) begin
                        state <= (data << 1) | 1'b1; // Shift in data to check for '1101'
                    end
                    if (data == 1'b0) begin
                        state <= (data << 1); // Shift in data
                    end
                    if (state == 4'b1101) begin
                        state <= COUNT; // Move to counting state
                        delay <= {data, data, data}; // Shift in the next 4 bits as the delay
                        remaining_delay <= delay;
                        cycle_counter <= 20'b0; // Reset cycle counter
                    end
                end
                
                COUNT: begin
                    counting <= 1'b1;
                    cycle_counter <= cycle_counter + 1;
                    if (cycle_counter == 1000) begin // After 1000 cycles
                        if (remaining_delay > 0) begin
                            count <= remaining_delay; // Output current remaining time
                            remaining_delay <= remaining_delay - 1; // Decrement remaining delay
                            cycle_counter <= 20'b0; // Reset cycle counter
                        end else begin
                            state <= DONE; // Move to done state
                        end
                    end
                end
                
                DONE: begin
                    done <= 1'b1; // Assert done signal
                    count <= 4'bxxxx; // Don't care value
                    counting <= 1'b0; // Not counting anymore
                    if (ack) begin
                        state <= SEARCH; // Reset to searching state
                        done <= 1'b0; // De-assert done signal
                    end
                end
                
                default: begin
                    state <= SEARCH; // Default to searching state
                end
            endcase
        end
    end
endmodule