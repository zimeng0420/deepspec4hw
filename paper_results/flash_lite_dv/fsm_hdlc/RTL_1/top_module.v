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
    reg disc_reg;
    reg flag_reg;
    reg err_reg;

    // State transition logic and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (in) state <= S_ONE; else state <= S_IDLE;
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
                S_ONE: begin
                    if (in) state <= S_TWO; else state <= S_IDLE;
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
                S_TWO: begin
                    if (in) state <= S_THREE; else state <= S_IDLE;
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
                S_THREE: begin
                    if (in) state <= S_FOUR; else state <= S_IDLE;
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
                S_FOUR: begin
                    if (in) state <= S_FIVE; else state <= S_IDLE;
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
                S_FIVE: begin
                    if (in) begin
                        state <= S_SIX;
                        disc_reg <= 0;
                        flag_reg <= 0;
                        err_reg <= 0;
                    end else begin
                        state <= S_IDLE;
                        disc_reg <= 1;
                        flag_reg <= 0;
                        err_reg <= 0;
                    end
                end
                S_SIX: begin
                    if (in) begin
                        state <= S_ERROR;
                        disc_reg <= 0;
                        flag_reg <= 0;
                        err_reg <= 0;
                    end else begin
                        state <= S_IDLE;
                        disc_reg <= 0;
                        flag_reg <= 1;
                        err_reg <= 0;
                    end
                end
                S_ERROR: begin
                    if (in) begin
                        state <= S_ERROR;
                        disc_reg <= 0;
                        flag_reg <= 0;
                        err_reg <= 1;
                    end else begin
                        state <= S_IDLE;
                        disc_reg <= 0;
                        flag_reg <= 0;
                        err_reg <= 0;
                    end
                end
                default: begin
                    state <= S_IDLE;
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
            endcase
        end
    end
    always @(posedge clk) begin
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg;
    end
endmodule