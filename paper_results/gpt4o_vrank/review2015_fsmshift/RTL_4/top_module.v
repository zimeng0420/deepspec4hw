module top_module(
    input clk,
    input reset,
    output reg shift_ena);

    reg [2:0] state, next_state;
    localparam IDLE = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4;

    always @(posedge clk) begin
        if (reset) begin
            state <= S1;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case(state)
            IDLE: next_state = IDLE;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S4;
            S4: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        case(state)
            S1, S2, S3, S4: shift_ena = 1;
            default: shift_ena = 0;
        endcase
    end

endmodule