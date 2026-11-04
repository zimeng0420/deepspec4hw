### Technical Specification for Timer Module in Verilog

#### Overview
The timer module is designed to count down from a specified number of clock cycles based on a 10-bit input. The module asserts the `tc` (terminal count) output when the internal counter reaches zero. The internal counter can be loaded with a new value at any time while it is counting down.

#### Interface
- **Inputs:**
  - `clk`: Clock signal.
  - `load`: Load signal. When high, the internal counter is loaded with the value from `data`.
  - `data`: 10-bit input value used to set the internal counter.

- **Outputs:**
  - `tc`: Terminal count signal that indicates when the internal counter has reached zero.

#### Functional Description
1. **Counter Initialization:**
   - The internal counter is initialized to zero on power-up or reset.

2. **Loading the Counter:**
   - On the rising edge of `clk`, if `load` is high (1), the internal counter (`counter`) is loaded with the value from `data` (10 bits). The loading action resets the counter and stops any ongoing countdown.

3. **Counting Down:**
   - If `load` is low (0), the internal counter decrements by 1 at each clock cycle, provided it is greater than 0. 

4. **Terminal Count Indicator:**
   - The `tc` output is asserted high (1) when the internal counter reaches zero and remains high until a new value is loaded into the counter. If the counter is not zero, `tc` is low (0).

5. **Counter Behavior:**
   - The counter should be able to handle multiple load commands during its countdown, resetting to the new value specified in `data` instantly and not completing the current countdown.

#### Constraints
- The counter must be a minimum of 10 bits to accommodate the `data` input range, which allows values from 0 to 1023 (10-bit unsigned).
- The timer must properly handle asynchronous behavior of `load` without race conditions.

#### Verilog Implementation
```verilog
module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output reg tc
);
    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;  // Load the counter with 'data' on load signal
            tc <= 0;         // Reset terminal count when loading new value
        end else if (counter > 0) begin
            counter <= counter - 1; // Decrement counter
        end
        
        // Assert tc when counter reaches zero
        if (counter == 0) begin
            tc <= 1; // Terminal count
        end
    end
endmodule
```

### Notes
- Ensure to properly simulate and test the design to verify the expected behavior under various scenarios including edge cases involving simultaneous load and countdown events.
- This design assumes that the clock signal behavior is ideal and that no setup/hold time issues are present.