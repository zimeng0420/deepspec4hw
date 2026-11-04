### Technical Specification for the Countdown Timer Module

**Module Name:** top_module

**Purpose:**  
Implement a countdown timer using a down-counter that asserts a terminal count signal `tc` when the countdown reaches zero.

**Inputs:**
1. `clk`: Clock input signal. The timer will decrement the counter on each rising edge of this clock signal.
2. `load`: Control input signal. When high (1), loads data into the counter. When low (0), allows the counter to decrement.
3. `data`: 10-bit input bus. Provides the initial count value to load into the timer.

**Output:**
1. `tc`: Terminal count output signal. Asserted high (1) when the internal counter reaches zero, otherwise low (0). Remains high until the counter is reloaded with a new value.

**Behavioral Specifications:**

1. **Load Behavior:**
   - When `load` is asserted high (1), the 10-bit value from `data` is loaded into the internal counter, regardless of the counter's current state or value.

2. **Counting Behavior:**
   - When `load` is low (0):
     - **Decrement Condition:** The counter decrements by 1 on each rising edge of `clk` if it is not already zero.
     - **Terminal Count Detection:** If the counter reaches zero, it should stop decrementing and remain at zero until `load` is asserted again.
     - The `tc` signal is asserted when the counter is zero.

3. **Initialization & Edge Cases:**
   - At initialization, the behavior of the counter should be defined as having an undefined or known starting counter value until `load` is first asserted.
   - Ensure synchronous resets or initializations are handled such that no unexpected behavior occurs at startup.

4. **Design Constraints:**
   - The counter should be implemented using a down-counter mechanism.
   - `tc` is a combinatorial output based on the counter value reaching zero.
   - Edge-triggered logic for `clk` should be used to control the counter's decrement operation.

5. **Edge Trigger:**
   - Ensure all combinatorial logic and clock-dependent processes adhere to standard synchronous design practices.

6. **Optional Features (Not Required):**
   - **Asynchronous Reset:** Can be implemented if required for initialization outside of loading new values.
   - **Overflow/Underflow Handling:** Ensure no wrap-around of counter values from zero in case of decrement beyond zero.

**Notes:**
- Ensure to conduct thorough simulation testing to verify that the module meets the specified requirements and proper timing closure is achieved.
- Ensure design is compliant with target synthesis and FPGA/ASIC design constraints if required for specific deployment environments.