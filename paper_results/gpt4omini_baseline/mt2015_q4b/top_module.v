module top_module(
    input x,
    input y,
    output reg z
);
    always @(*) begin
        case ({x, y})
            2'b00: z = 1;  // from 0ns to 20ns
            2'b01: z = 0;  // from 35ns to 40ns and 60ns to 65ns
            2'b10: z = 0;  // from 25ns to 30ns and 90ns onwards
            2'b11: z = (z == 1'b0) ? 1 : 0; // toggles based on previous state
            default: z = 1; // default state to avoid latches
        endcase
    end

    initial begin
        // Initial conditions
        z = 1; // Initial state of z
        #25;   // Wait for 25ns to set x=1, y=0 -> z=0
        #5;    // Remain in state (25ns to 30ns)
        #5;    // Set state x=0, y=1 -> z will remain 0
        #5;    // Stay in state (35ns to 40ns)
        #5;    // Set x=1, y=1 -> z=1
        #5;    // Stay in state (45ns to 50ns)
        #5;    // Return to state x=0, y=0 -> z=1
        #5;    // Set state x=0, y=1 -> z will remain 0
        #5;    // Stay in state (60ns to 65ns)
        #5;    // Set state x=1, y=1 -> z toggles; should remain 1
        #5;    // Set state x=0, y=1 -> z=0
        #5;    // Stay in state (80ns to 85ns)
        #5;    // Set state x=1, y=0 -> z=0
    end
endmodule