module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] state, next_state;

    localparam S_IDLE = 3'b000;
    localparam S_SHIFT1 = 3'b001;
    localparam S_SHIFT2 = 3'b010;
    localparam S_SHIFT3 = 3'b011;
    localparam S_SHIFT4 = 3'b100;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SHIFT1;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S_IDLE: next_state = S_IDLE;
            S_SHIFT1: next_state = S_SHIFT2;
            S_SHIFT2: next_state = S_SHIFT3;
            S_SHIFT3: next_state = S_SHIFT4;
            S_SHIFT4: next_state = S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            S_SHIFT1, S_SHIFT2, S_SHIFT3, S_SHIFT4: shift_ena = 1'b1;
            default: shift_ena = 1'b0;
        endcase
    end

endmodule