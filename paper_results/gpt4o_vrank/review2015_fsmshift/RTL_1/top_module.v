module top_module(
    input clk,
    input reset,
    output reg shift_ena);

    reg [2:0] state, next_state;

    localparam IDLE = 3'd0,
               ENABLE1 = 3'd1,
               ENABLE2 = 3'd2,
               ENABLE3 = 3'd3,
               ENABLE4 = 3'd4;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE1;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = IDLE;
            ENABLE1: next_state = ENABLE2;
            ENABLE2: next_state = ENABLE3;
            ENABLE3: next_state = ENABLE4;
            ENABLE4: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = (state == ENABLE1) || (state == ENABLE2) || (state == ENABLE3) || (state == ENABLE4);
    end

endmodule