module top_module (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);
    always @(*) begin
        // Default outputs
        left = 0;
        down = 0;
        right = 0;
        up = 0;

        // Check for scancodes
        case (scancode)
            16'hE06B: left = 1;   // left arrow
            16'hE072: down = 1;   // down arrow
            16'hE074: right = 1;  // right arrow
            16'hE075: up = 1;     // up arrow
            default: ;             // none
        endcase
    end
endmodule