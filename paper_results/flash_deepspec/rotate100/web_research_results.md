# Web Research Results

Total Results: 1

## Result 1

Here's information to help you build a 100-bit left/right rotator with synchronous load and left/right enable in Verilog:

**Conceptual Overview**

*   **Rotator vs. Shifter:** A rotator shifts in the shifted-out bit from the opposite end of the register, preserving data. A shifter discards the shifted-out bit and typically shifts in a zero.
*   **Synchronous Load:** The register loads new data only on the active edge of the clock signal.
*   **Left/Right Enable:** Control signals determine the direction of rotation.

**Module Definition**

```verilog
module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

//Implement your solution here

endmodule
```

**Signal Descriptions**

*   `clk`: Clock input.
*   `load`:  Synchronous active-high load enable. When asserted, the register loads data instead of rotating.
*   `ena[1:0]`:  Synchronous enable signals to control the rotation direction.
    *   `2'b01`: Rotate right by one bit.
    *   `2'b10`: Rotate left by one bit.
    *   `2'b00` and `2'b11`: Do not rotate.
*   `data[99:0]`:  Input data to be loaded into the register.
*   `q[99:0]`: The output, representing the current contents of the rotator.

**Implementation Details**

1.  **Synchronous Load:** Use the `load` signal in a clocked always block to load the `data` input into the `q` register.

2.  **Rotation Logic:**
    *   Use a clocked `always` block to implement the rotation. The rotation should only occur on the active edge of the clock.
    *   Inside the `always` block, use the `ena` signals to determine the rotation direction.
    *   For right rotation, the least significant bit (LSB) should be shifted in from the most significant bit (MSB) position.
    *   For left rotation, the MSB should be shifted in from the LSB position.
    *   When `ena` is `2'b00` or `2'b11`, the register should hold its current value.

**Example Implementation Code**

```verilog
module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena == 2'b01) begin // Rotate right
        q <= {q[0], q[99:1]};
    end else if (ena == 2'b10) begin // Rotate left
        q <= {q[98:0], q[99]};
    end else begin // Do not rotate
        q <= q;
    end
end

endmodule
```

**Additional Considerations**

*   **Reset:**  Consider adding a reset signal (synchronous or asynchronous) to initialize the register to a known state.
*   **Asynchronous vs. Synchronous Reset:**
    *   *Asynchronous Reset:* Resets the register immediately, regardless of the clock. Requires a reset synchronizer to prevent metastability.
    *   *Synchronous Reset:* Resets the register on the active clock edge.  Generally ensures the circuit is 100% synchronous.
*   **Initial Values:** You can set an initial value for the register using the `initial` keyword.

**Important Notes**

*   When both `load` and `ena` are asserted simultaneously, `load` should have higher priority.
*   Ensure that your Verilog code is synthesizable.


---

