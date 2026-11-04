module top_module (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

always @(*) begin
    // Default assignments
    left = 0;
    down = 0;
    right = 0;
    up = 0;

    // Case statement to check for arrow key scancodes
    case (scancode)
        16'hE06B: left = 1;    // Left arrow
        16'hE072: down = 1;    // Down arrow
        16'hE074: right = 1;   // Right arrow
        16'hE075: up = 1;      // Up arrow
        default: ;              // No action needed for anything else
    endcase
end

endmodule