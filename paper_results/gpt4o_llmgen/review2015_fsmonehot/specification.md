## Technical Specification

### State Definitions
- State Encoding: 
  - S = 10'b0000000001
  - S1 = 10'b0000000010
  - S11 = 10'b0000000100
  - S110 = 10'b0000001000
  - B0 = 10'b0000010000
  - B1 = 10'b0000100000
  - B2 = 10'b0001000000
  - B3 = 10'b0010000000
  - Count = 10'b0100000000
  - Wait = 10'b1000000000

### Next-State Logic Equations
1. **B3_next** - Transition to state B3:
   - Equation: `B3_next = state[6]`
   - Justification: The system transitions to B3 from B2 always.

2. **S_next** - Transition to state S:
   - Equation: `S_next = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d & ~ack)`
   - Justification: 
     - From S, transition to S on d=0.
     - From S1, transition to S on d=0.
     - From S110, transition to S on d=0.
     - From Wait, transition to S on ack=1.

3. **S1_next** - Transition to state S1:
   - Equation: `S1_next = (state[0] & d)`
   - Justification: Transition from S to S1 on d=1.

4. **Count_next** - Transition to state Count:
   - Equation: `Count_next = state[7]`
   - Justification: Transition to Count from B3 always.

5. **Wait_next** - Transition to state Wait:
   - Equation: `Wait_next = (state[8] & done_counting)`
   - Justification: Transition from Count to Wait once done_counting is true.

### Output Logic Equations
1. **done** - Indicate done:
   - Equation: `done = state[9]`
   - Justification: Output done=1 in state Wait.

2. **counting** - Indicate counting:
   - Equation: `counting = state[8]`
   - Justification: Output counting=1 in state Count.

3. **shift_ena** - Enable shifting:
   - Equation: `shift_ena = state[4] | state[5] | state[6] | state[7]`
   - Justification: Output shift_ena=1 in states B0, B1, B2, and B3.

### Implementation
Below are the Verilog statements for the logic described:

```verilog
assign B3_next = state[6];
assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d & ~ack);
assign S1_next = (state[0] & d);
assign Count_next = state[7];
assign Wait_next = (state[8] & done_counting);
assign done = state[9];
assign counting = state[8];
assign shift_ena = state[4] | state[5] | state[6] | state[7];
```

### Additional Notes
- Ensure that state transitions are properly handled with sufficient clocking logic within a complete module definition in an actual design to ensure synchronous behavior.
- The reset logic should ensure that the initial state is S (state[0] = 1) at reset.