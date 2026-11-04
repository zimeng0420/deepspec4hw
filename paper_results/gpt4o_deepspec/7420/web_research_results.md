# Web Research Results

Total Results: 1

## Result 1

The 7420 IC is a member of the 7400 series of integrated circuits. It houses two independent 4-input NAND gates in a 14-pin dual in-line package (DIP).

**Functionality:**
The 7420 performs the NAND logic function. A NAND gate's output is low only when all of its inputs are high; otherwise, the output is high. The IC can be used for combining multiple digital conditions into a single logic gate operation. It can also be applied in control logic, security systems, arithmetic units, and signal qualification logic.

**Pinout:**
The 7420 has 14 pins. Each of the two NAND gates has four inputs and one output. The remaining pins are for power (VCC) and ground.
*   Pin 1: Input A for gate 1
*   Pin 2: Input B for gate 1
*   Pin 3: Not connected
*   Pin 4: Input C for gate 1
*   Pin 5: Input D for gate 1
*   Pin 6: Output Y for gate 1
*   Pin 7: Ground
*   Pin 8: Output Y for gate 2
*   Pin 9: Input A for gate 2
*   Pin 10: Input B for gate 2
*   Pin 11: Not connected
*   Pin 12: Input C for gate 2
*   Pin 13: Input D for gate 2
*   Pin 14: VCC (positive supply)

The module with the same functionality as the 7420 chip is defined as:

```
module top_module(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    output p1y,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p2y
);
```

---

