module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State encoding
    typedef enum logic [1:0] {
        STATE_B = 1'b0,
        STATE_A = 1'b1
    } state_t;

    state_t state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            STATE_B: next_state = (in == 0) ? STATE_A : STATE_B;
            STATE_A: next_state = (in == 0) ? STATE_B : STATE_A;
            default: next_state = STATE_B;
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        case (state)
            STATE_B: out = 1;
            STATE_A: out = 0;
            default: out = 1;
        endcase
    end

    // State update logic (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;
        end else begin
            state <= next_state;
        end
    end

endmodule