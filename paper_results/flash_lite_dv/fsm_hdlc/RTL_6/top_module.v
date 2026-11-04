module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State Definition
    parameter S_IDLE = 0,
              S_ONE  = 1,
              S_TWO  = 2,
              S_THREE= 3,
              S_FOUR = 4,
              S_FIVE = 5,
              S_SIX  = 6,
              S_ERROR= 7;

    // State Register
    reg [2:0] state;

    // Next State Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (in)
                        state <= S_ONE;
                    else
                        state <= S_IDLE;
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err  <= 1'b0;
                end
                S_ONE: begin
                    if (in)
                        state <= S_TWO;
                    else
                        state <= S_IDLE;
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err  <= 1'b0;
                end
                S_TWO: begin
                    if (in)
                        state <= S_THREE;
                    else
                        state <= S_IDLE;
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err  <= 1'b0;
                end
                S_THREE: begin
                    if (in)
                        state <= S_FOUR;
                    else
                        state <= S_IDLE;
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err  <= 1'b0;
                end
                S_FOUR: begin
                    if (in)
                        state <= S_FIVE;
                    else
                        state <= S_IDLE;
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err  <= 1'b0;
                end
                S_FIVE: begin
                    if (in) begin
                        state <= S_SIX;
                    end else begin
                        state <= S_IDLE;
                        disc <= 1'b1;
                    end
                    flag <= 1'b0;
                    err  <= 1'b0;
                end
                S_SIX: begin
                    if (in) begin
                        state <= S_ERROR;
                    end else begin
                        state <= S_IDLE;
                        flag <= 1'b1;
                    end
                    disc <= 1'b0;
                    err  <= 1'b0;
                end
                S_ERROR: begin
                    if (in)
                        state <= S_ERROR;
                    else
                        state <= S_IDLE;
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err  <= 1'b1;
                end
                default: begin
                    state <= S_IDLE;
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err  <= 1'b0;
                end
            endcase
        end
    end

endmodule