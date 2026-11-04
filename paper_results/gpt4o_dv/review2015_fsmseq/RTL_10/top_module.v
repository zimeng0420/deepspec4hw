module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting);

    reg [2:0] state, next_state;

    // State encoding
    localparam S_IDLE  = 3'b000;
    localparam S_1     = 3'b001;
    localparam S_11    = 3'b010;
    localparam S_110   = 3'b011;
    localparam S_1101  = 3'b100;

    // State transition logic (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            S_IDLE:  next_state = (data == 1'b1) ? S_1 : S_IDLE;
            S_1:     next_state = (data == 1'b1) ? S_11 : S_IDLE;
            S_11:    next_state = (data == 1'b0) ? S_110 : S_11;
            S_110:   next_state = (data == 1'b1) ? S_1101 : S_IDLE;
            S_1101:  next_state = S_1101;
            default: next_state = S_IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset)
            start_shifting <= 1'b0;
        else if (state == S_1101)
            start_shifting <= 1'b1;
    end

endmodule