### Technical Specification for 12-Hour Clock with AM/PM Indicator

#### Module Overview
The 12-hour clock module implements a real-time clock (RTC) that keeps track of hours, minutes, and seconds in BCD format. The clock features an AM/PM indicator and is controlled through a faster clock signal `clk`. It increments its time via an enable signal `ena` that pulses once per second.

#### Inputs
- **clk**: Fast-running clock signal used for timing.
- **reset**: Active high synchronous reset signal that resets the clock to "12:00 AM".
- **ena**: Enable signal that triggers time incrementing when high.

#### Outputs
- **pm**: Output flag indicating whether the time is in PM (1 for PM, 0 for AM).
- **hh**: Two BCD digits representing the hour in the range 01 to 12.
- **mm**: Two BCD digits representing the minute in the range 00 to 59.
- **ss**: Two BCD digits representing the second in the range 00 to 59.

#### Functional Requirements
1. **Time Representation**:
   - Hours (`hh`): Represented in BCD format as two digits, valid states from 01 to 12.
   - Minutes (`mm`): Represented in BCD format as two digits, valid states from 00 to 59.
   - Seconds (`ss`): Represented in BCD format as two digits, valid states from 00 to 59.

2. **Reset Operation**:
   - On the assertion of `reset` (high), regardless of the state of `ena`, the outputs should be set to:
     - `hh = 8'b0001_0010` (12 in BCD)
     - `mm = 8'b0000_0000` (00 in BCD)
     - `ss = 8'b0000_0000` (00 in BCD)
     - `pm = 0` (indicating AM)

3. **Time Incrementation**:
   - If `ena` is high, the clock should increment the `ss` every second, triggered by the `clk`.
   - When `ss` reaches `59`, it should reset to `00` and increment `mm`.
   - When `mm` reaches `59`, it should reset to `00` and increment `hh`.
   - When `hh` reaches `12` and `ena` is asserted, the `pm` signal should toggle (switch from AM to PM and vice versa).

4. **Synchronous Reset**:
   - The reset operation takes precedence over time incrementation. The system must not perform any time-related updates when `reset` is asserted.

5. **Timing Details**:
   - The clock signal `clk` is assumed to run much faster than the required one-second interval for incrementing `ss`, which indicates that a counter might be needed alongside to handle counting clock ticks.

#### State Machines
- **State Machine for Seconds**:
  - Counts from 0 to 59, resets after reaching 60, and triggers minute increment.

- **State Machine for Minutes**:
  - Similar operation as the seconds but resets after reaching 60 to increment the hour.

- **State Machine for Hours**:
  - Counts hours from 1 to 12, switches `pm` status on each `hh` transition from 12 back to 1.

#### Implementation Notes
- Use a series of counters for `ss`, `mm`, and `hh`.
- Ensure that BCD calculations are properly implemented to maintain correct representation and prevent overflow.
- Consider adding necessary logic to manage the toggling of the `pm` output based on the current hour status.

This specification provides a detailed overview of the design and operational aspects for implementing a 12-hour BCD clock with AM/PM designation using Verilog.