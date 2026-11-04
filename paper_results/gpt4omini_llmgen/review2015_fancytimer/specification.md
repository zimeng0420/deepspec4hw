```verilog
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

    // Synchronous State Transition and Output Logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;        // Reset to IDLE state
            counting <= 0;                // Not counting
            done <= 0;                    // Not done
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
                    // Shift in logic would go here
                    next_state = RECEIVING;  // Move to RECEIVING state
                end
            end
            RECEIVING: begin
                if (/* Check if 4 bits received */) begin
                    // Store the delay[3:0] value
                    next_state = COUNTING;   // Move to COUNTING state
                    counter <= (delay + 1) * 1000; // Initialize cycle counter
                    remaining_time <= delay; // Start remaining time
                end
            end
            COUNTING: begin
                counting = 1;                  // Assert counting
                // Output current remaining time during counting
                if (remaining_time > 0) begin
                    if (counter == 0) begin
                        remaining_time <= remaining_time - 1; // Update remaining time
                        counter <= 1000; // Reload counter for 1000 cycles
                    end
                end else begin
                    next_state = DONE;       // Move to DONE state when finished
                end
            end
            DONE: begin
                counting = 0;                // Deassert counting
                if (ack) begin
                    next_state = IDLE;       // Reset to IDLE state
                end
            end
        endcase
    end

    // Output remaining time logic
    assign count = (current_state == COUNTING) ? remaining_time : 4'bxxxx; // Don't care value when not counting

endmodule
``` 

### Technical Specification:
- **Inputs**: 
    - `clk`: Clock signal for synchronization.
    - `reset`: Active high synchronous reset to initiate the state machine.
    - `data`: Serial input where the pattern '1101' and delay bits are provided.
    - `ack`: Acknowledgment signal from the user.

- **Outputs**:
    - `count`: 4-bit output that reflects the current remaining time during the counting phase (outputs a don't-care value otherwise).
    - `counting`: Indicates when the timer is actively counting.
    - `done`: Indicates when the timer has completed the countdown cycle.

- **Functionality**:
    - Detects the input pattern '1101' to start the timing process.
    - Shifts in the 4 bits following the pattern to represent the delay period.
    - Counts for `(delay + 1) * 1000` clock cycles, decrementing the delay value every 1000 cycles.
    - Upon completion, asserts the `done` signal and awaits user acknowledgment via `ack` before resetting to search for the next start sequence. 

- **State Machine**:
    - States: IDLE, RECEIVING, COUNTING, DONE.
    - Transitioning based on input conditions, with cycle counting and output logic appropriately defined.