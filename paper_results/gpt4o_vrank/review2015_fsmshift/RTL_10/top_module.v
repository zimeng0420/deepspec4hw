module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] state;
    reg [2:0] next_state;
    
    localparam S0 = 3'b000;  // Initial state
    localparam S1 = 3'b001;  // Shift_ena asserted for 1st cycle
    localparam S2 = 3'b010;  // Shift_ena asserted for 2nd cycle
    localparam S3 = 3'b011;  // Shift_ena asserted for 3rd cycle
    localparam S4 = 3'b100;  // Shift_ena asserted for 4th cycle
    localparam S5 = 3'b101;  // Shift_ena deasserted indefinitely

    // State transition logic
    always @(*) begin
        case (state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S4;
            S4: next_state = S5;
            S5: next_state = S5;
            default: next_state = S0;
        endcase
    end

    // State updates and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Output logic based on state
    always @(*) begin
        case (state)
            S1, S2, S3, S4: shift_ena = 1;
            default: shift_ena = 0;
        endcase
    end
endmodule