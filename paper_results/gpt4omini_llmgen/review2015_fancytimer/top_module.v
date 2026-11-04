module top_module(
    input wire clk,             // Clock signal
    input wire reset,           // Active high synchronous reset
    input wire data,            // Serial data input
    output wire [3:0] count,    // Current remaining time output
    output reg counting,        // Signal indicating the timer is counting
    output reg done,           // Signal indicating the timer has timed out
    input wire ack              // Acknowledgment signal from the user
);

    // State Encoding
    typedef enum logic [2:0] {
        IDLE,            // Waiting for the start sequence
        RECEIVING,      // Receiving the 4-bit delay value
        COUNTING,       // Counting down
        DONE            // Finished counting, waiting for ack
    } state_t;

    state_t current_state, next_state; // State variable
    logic [3:0] delay;                  // Holds the received 4-bit delay
    logic [12:0] counter;               // Cycle counter for timing
    logic [3:0] remaining_time;         // Remaining time to output
    logic [3:0] data_buffer;            // Buffer to hold the shifted-in data
    logic [2:0] bit_count;              // Count shifted bits

    // Synchronous State Transition and Output Logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;        // Reset to IDLE state
            counting <= 0;                // Not counting
            done <= 0;                    // Not done
            bit_count <= 0;               // Reset bit count
            counter <= 0;                 // Reset counter
            remaining_time <= 4'b0000;    // Reset remaining time
        end else begin
            current_state <= next_state;  // Update state
            if (current_state == COUNTING) begin
                if (counter > 0) begin
                    counter <= counter - 1; // Decrease cycle counter
                end else begin
                    done <= 1;              // Timer timed out
                end
            end else begin
                if (current_state == DONE && ack) begin
                    done <= 0;              // Acknowledge received, reset done
                    next_state <= IDLE;     // Reset to IDLE state
                end
            end
        end
    end

    // Combinational Logic for Next State and Outputs
    always_comb begin
        next_state = current_state;        // Default next state
        counting = 0;                      // Default counting to 0
        case (current_state)
            IDLE: begin
                if (data == 1) begin          // Detect start sequence (1101)
                    next_state = RECEIVING;  // Move to RECEIVING state
                end
            end
            RECEIVING: begin
                if (bit_count < 4) begin
                    data_buffer <= {data_buffer[2:0], data}; // Shift in new bit
                    bit_count <= bit_count + 1; // Increment bit counter
                    if (bit_count == 3) begin // After receiving 4 bits (including 1101)
                        delay <= data_buffer[3:0]; // Store the delay[3:0] value
                        counter <= (delay + 1) * 1000; // Initialize cycle counter
                        remaining_time <= delay; // Start remaining time
                        next_state = COUNTING;   // Move to COUNTING state
                    end
                end
            end
            COUNTING: begin
                counting = 1;                  // Assert counting
                // Output current remaining time during counting
                if (counter == 0) begin
                    if (remaining_time > 0) begin
                        remaining_time <= remaining_time - 1; // Update remaining time
                        counter <= 1000; // Reload counter for 1000 cycles
                    end else begin
                        next_state = DONE;       // Move to DONE state when finished
                    end
                end
            end
            DONE: begin
                counting = 0;                // Deassert counting
            end
        endcase
    end

    // Output remaining time logic
    assign count = (current_state == COUNTING) ? remaining_time : 4'bxxxx; // Don't care value when not counting

endmodule
 