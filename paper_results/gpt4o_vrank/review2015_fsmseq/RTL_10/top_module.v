module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
    );

    typedef enum reg [2:0] {
        IDLE    = 3'b000,
        S1      = 3'b001,
        S11     = 3'b010,
        S110    = 3'b011,
        S1101   = 3'b100
    } state_t;

    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (state == S1101)
                start_shifting <= 1'b1;
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = data ? S1 : IDLE;
            S1: next_state = data ? S11 : IDLE;
            S11: next_state = data ? S11 : S110;
            S110: next_state = data ? S1101 : IDLE;
            S1101: next_state = S1101; // Once we hit 1101, stay as start_shifting is forever
            default: next_state = IDLE;
        endcase
    end
endmodule