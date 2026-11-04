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
    reg [10:0] cycle_count; // to count (delay + 1) * 1000
    reg [2:0] state; // State machine states
    reg [2:0] next_state;
    
    parameter IDLE = 3'b000, DETECT = 3'b001, COUNT = 3'b010, DONE = 3'b011;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            cycle_count <= 0;
            count <= 4'b0000;
        end else begin
            state <= next_state;
        end
    end

    // State machine control
    always @(*) begin
        next_state = state; // Default to hold state
        case (state)
            IDLE: begin
                counting = 0; 
                done = 0;
                if (data) begin // Start detecting '1101'
                    // Shift register for pattern detection
                    // Using a shift method to recognize '1101' through 4 clock samples
                    // This will require additional shift register logic for better accuracy
                end
            end
            DETECT: begin
                // Assuming full pattern '1101' detected, shift the next 4 bits here
                // For this example purposes, let’s say we get delay directly for simplification
                delay = 4'b0000; // Should be the result of 4 bits shifted in
                count = delay + 1; // Count starts from (delay + 1) * 1000 clock cycles
                cycle_count = 0;
                counting = 1;
                next_state = COUNT;
            end
            COUNT: begin
                counting = 1;
                if (cycle_count < ((delay + 1) * 1000)) begin
                    cycle_count = cycle_count + 1;
                    if (cycle_count % 1000 == 0) begin
                        count <= delay; // Reduce remaining time each 1000 cycles for 1000 cycles
                        if (delay > 0) begin
                            delay = delay - 1; // Decrease the delay every 1000 cycles
                        end
                    end
                end else begin
                    done = 1; // Time's up
                    counting = 0;
                    next_state = DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE; // Reset back to searching for '1101'
                end
            end
        endcase
    end
endmodule