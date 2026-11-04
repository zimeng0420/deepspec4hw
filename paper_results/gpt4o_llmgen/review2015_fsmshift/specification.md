**Technical Specification for Shift Register Enable Control Module**

**Module Name:** top_module

**Functionality Overview:**
The module controls the enabling of a shift register within an FSM. The `shift_ena` output should be asserted for exactly four clock cycles under two scenarios:
1. Immediately after a reset condition.
2. When a specific bit pattern (event/condition detection) is identified by another part of the FSM system, though the detection mechanism isn't specified here.

**Inputs:**
- `clk`: Clock signal (System clock input to synchronize operations).
- `reset`: Active-high synchronous reset (Asserts the shift enable for four cycles when activated).

**Outputs:**
- `shift_ena`: Controls enabling of the shift register (Asserted high for exactly four cycles post-reset or upon detection of a condition).

**Operational Requirements:**
1. **Reset Behavior:**
   - When the `reset` signal is asserted (active-high), the `shift_ena` should be asserted high beginning immediately on the next clock cycle.
   - The `shift_ena` remains asserted for exactly four consecutive clock cycles.
   - After these four cycles, `shift_ena` should be deasserted (held low) indefinitely until the next reset condition.

2. **Idle/Steady-State Behavior:**
   - Once the four-cycle assertion post-reset completes, `shift_ena` must remain low continuously unless reset is triggered again.
   - There is no re-enabling of `shift_ena` without an explicit reset in this requirement phase.

3. **Timing Requirements:**
   - The assertion and deassertion edges of `shift_ena` must be synchronous with the rising edge of the `clk`.
   - The reset logic must also adhere to synchronous reset specifications.

**FSM State Description:**
- **IDLE**: Default state where `shift_ena` is low.
- **SHIFT_ENABLE**: Active state post-reset where `shift_ena` is asserted for four cycles.
  - Transition from `IDLE` to `SHIFT_ENABLE` on the next cycle after reset is detected.
  - Stay in `SHIFT_ENABLE` for three additional cycles post the initial enable.
  - Transition back to `IDLE` after completion of four total enable cycles.

**Verilog Implementation Logic:**
- **State Register**: 
  - 2-bit wide register to track current state (`IDLE`, `SHIFT_ENABLE`) and count the number of cycles the shift enable has been active.
  
- **State Transition Logic**: 
  - Utilizes if-else or case structure triggered on the rising edge of the clock.
  - Incorporates synchronous reset state transition.

- **Output Logic**:
  - `shift_ena` derived directly from current state logic.
  - Driven based on the cycle counter ensuring the four-cycle assertion time.

**Constraints:**
- No external control for re-enabling unless specified by additional detection mechanism requirements not covered in this task.
- External bit pattern detection triggering is assumed to be handled outside this module.

**Documentation and Maintainability:**
- Clear in-line comments accompanying the Verilog code for state machine detailing each part of the logic.
- Modular design practices to allow easy adaptations if additional functionality is desired in subsequent design phases.