module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Define states
    parameter S_IDLE = 3'b000;
    parameter S_ONE  = 3'b001;
    parameter S_TWO  = 3'b010;
    parameter S_THREE= 3'b011;
    parameter S_FOUR = 3'b100;
    parameter S_FIVE = 3'b101;
    parameter S_SIX  = 3'b110;
    parameter S_ERROR= 3'b111;

    // State register
    reg [2:0] state;
    reg disc_reg;
    reg flag_reg;
    reg err_reg;

    // Next state logic and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                    if (in)
                        state <= S_ONE;
                    else
                        state <= S_IDLE;
                end
                S_ONE: begin
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                    if (in)
                        state <= S_TWO;
                    else
                        state <= S_IDLE;
                end
                S_TWO: begin
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                    if (in)
                        state <= S_THREE;
                    else
                        state <= S_IDLE;
                end
                S_THREE: begin
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                    if (in)
                        state <= S_FOUR;
                    else
                        state <= S_IDLE;
                end
                S_FOUR: begin
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                    if (in)
                        state <= S_FIVE;
                    else
                        state <= S_IDLE;
                end
                S_FIVE: begin
                    if (in) begin
                      disc_reg <= 1'b0;
                      flag_reg <= 1'b0;
                      err_reg <= 1'b0;
                        state <= S_SIX;
                    end else begin
                      disc_reg <= 1'b1;
                      flag_reg <= 1'b0;
                      err_reg <= 1'b0;
                      state <= S_IDLE;
                    end
                end
                S_SIX: begin
                    if (in) begin
                      disc_reg <= 1'b0;
                      flag_reg <= 1'b0;
                      err_reg <= 1'b1;
                        state <= S_ERROR;
                    end else begin
                      disc_reg <= 1'b0;
                      flag_reg <= 1'b1;
                      err_reg <= 1'b0;
                        state <= S_IDLE;
                    end
                end
                S_ERROR: begin
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                    if (in)
                        state <= S_ERROR;
                    else
                        state <= S_IDLE;
                end
                default: begin
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                    state <= S_IDLE;
                end
            endcase
        end
    end

    always @(posedge clk) begin
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg;
    end
end