```verilog
module top_module(
    input ring, 
    input vibrate_mode,
    output ringer,
    output motor
);

    // Internal signals to manage the outputs
    assign ringer = ring & ~vibrate_mode; // Ringer is ON if ring is high and vibrate_mode is LOW
    assign motor = ring & vibrate_mode;    // Motor is ON if ring is high and vibrate_mode is HIGH

endmodule
```

### Technical Specifications:

1. **Input Signals:**
   - `ring`: This signal is high (1) when there is an incoming call; otherwise, it is low (0).
   - `vibrate_mode`: This signal is high (1) when the phone is in vibrate mode; otherwise, it is low (0).

2. **Output Signals:**
   - `ringer`: This output activates the ringer; it should be high (1) only when there is a ring signal and the phone is not in vibrate mode.
   - `motor`: This output activates the vibration motor; it should be high (1) only when there is a ring signal and the phone is in vibrate mode.

3. **Functionality:**
   - When `ring` = 1 and `vibrate_mode` = 0: 
     - `ringer` = 1, `motor` = 0
   - When `ring` = 1 and `vibrate_mode` = 1: 
     - `ringer` = 0, `motor` = 1
   - When `ring` = 0: 
     - `ringer` = 0, `motor` = 0 (both should be turned off)

4. **Design Constraints:**
   - Implement combinational logic using immediate assignment (`assign` statements) to derive output states based on the inputs.
   - Ensure mutual exclusivity between `ringer` and `motor` such that they are never high simultaneously. 

5. **Test Conditions:**
   - Valid signal transitions during simulation to verify functionality under all possible input combinations.
