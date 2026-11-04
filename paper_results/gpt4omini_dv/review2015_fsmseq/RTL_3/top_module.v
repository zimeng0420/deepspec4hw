module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [2:0] current_state, next_state;

    localparam S_IDLE = 3'b000,
               S_1    = 3'b001,
               S_11   = 3'b010,
               S_110  = 3'b011,
               S_1101 = 3'b100;

    // State transition logic
    always @(*) begin
        case (current_state)
            S_IDLE: next_state = (data) ? S_1 : S_IDLE;
            S_1:   next_state = (data) ? S_11 : S_IDLE;
            S_11:  next_state = (data) ? S_11 : S_110;
            S_110: next_state = (data) ? S_1101 : S_IDLE;
            S_1101: next_state = S_1101; // Remain in this state
            default: next_state = S_IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            current_state <= S_IDLE;
        else
            current_state <= next_state;
    end

    // Output logic
    always @(posedge clk) begin
        if (reset)
            start_shifting <= 0;
        else
            start_shifting <= (current_state == S_1101);
    end

endmodule