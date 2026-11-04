```verilog
module top_module (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);
    
    always @(*) begin
        // Initialize outputs to zero
        left = 0;
        down = 0;
        right = 0;
        up = 0;

        // Check the scancode and assert the corresponding output
        case (scancode)
            16'hE06B: left = 1;   // Left arrow key pressed
            16'hE072: down = 1;   // Down arrow key pressed
            16'hE074: right = 1;  // Right arrow key pressed
            16'hE075: up = 1;     // Up arrow key pressed
            default: ;             // No action for other keys
        endcase
    end

endmodule
```

### Technical Specifications:
1. **Module Name**: top_module
2. **Inputs**:
   - `scancode`: 16-bit input representing the received scancode from the PS/2 keyboard.
3. **Outputs**:
   - `left`: 1-bit output that indicates if the left arrow key is pressed (active high).
   - `down`: 1-bit output that indicates if the down arrow key is pressed (active high).
   - `right`: 1-bit output that indicates if the right arrow key is pressed (active high).
   - `up`: 1-bit output that indicates if the up arrow key is pressed (active high).
4. **Functionality**:
   - The module checks the input `scancode`. If it matches the predefined values for arrow keys, it asserts the corresponding output.
   - If none of the specified scancodes are detected, all outputs remain low.
5. **Implementation**:
   - A combinatorial `always @(*)` block is used to evaluate the input `scancode` continuously and drive the outputs based on its value.
6. **Scancode Mapping**:
   - 16'hE06B -> Left Arrow
   - 16'hE072 -> Down Arrow
   - 16'hE074 -> Right Arrow
   - 16'hE075 -> Up Arrow
   - Default case handles any other input by leaving outputs unchanged (inactive).