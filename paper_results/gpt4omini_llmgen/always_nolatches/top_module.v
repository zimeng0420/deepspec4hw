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