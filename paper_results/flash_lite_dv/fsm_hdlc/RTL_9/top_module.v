module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Define states
    parameter S_IDLE = 0;
    parameter S_ONE = 1;
    parameter S_TWO = 2;
    parameter S_THREE = 3;
    parameter S_FOUR = 4;
    parameter S_FIVE = 5;
    parameter S_SIX = 6;
    parameter S_ERROR = 7;

    // State register
    reg [2:0] state;

    // Next state logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_ONE;
                    else
                        state <= S_IDLE;
                end
                S_ONE: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_TWO;
                    else
                        state <= S_IDLE;
                end
                S_TWO: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_THREE;
                    else
                        state <= S_IDLE;
                end
                S_THREE: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_FOUR;
                    else
                        state <= S_IDLE;
                end
                S_FOUR: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_FIVE;
                    else
                        state <= S_IDLE;
                end
                S_FIVE: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_SIX;
                    else
                        state <= S_IDLE;
                end
                S_SIX: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_ERROR;
                    else begin
                        disc <= 1'b1;
                        state <= S_IDLE;
                    end
                end
                S_ERROR: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b1;
                    if (in)
                        state <= S_ERROR;
                    else
                        state <= S_IDLE;
                end
                default: begin
                    state <= S_IDLE;
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                end
            endcase
        end
    end

    // Output logic (assert for one clock cycle)
    always @(posedge clk) begin
      if (reset) begin
        flag <= 1'b0;
      end else if (state == S_SIX && in == 1'b0) begin
        flag <= 1'b1;
      end else begin
        flag <= 1'b0;
      end
    end

    always @(posedge clk) begin
      if (reset) begin
        err <= 1'b0;
      end else if (state == S_ERROR) begin
        err <= 1'b1;
      end else begin
        err <= 1'b0;
      end
    end

endmodule