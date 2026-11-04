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
    reg disc_reg, flag_reg, err_reg; // registers to hold outputs for one cycle

    // Next state logic and output logic (Moore FSM)
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (in)      state <= S_ONE;
                    else         state <= S_IDLE;
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                end
                S_ONE: begin
                    if (in)      state <= S_TWO;
                    else         state <= S_IDLE;
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                end
                S_TWO: begin
                    if (in)      state <= S_THREE;
                    else         state <= S_IDLE;
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                end
                S_THREE: begin
                    if (in)      state <= S_FOUR;
                    else         state <= S_IDLE;
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                end
                S_FOUR: begin
                    if (in)      state <= S_FIVE;
                    else         state <= S_IDLE;
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                end
                S_FIVE: begin
                    if (in) begin
                        state <= S_SIX;
                        disc_reg <= 1'b0;
                    end
                    else begin
                        state <= S_IDLE;
                        disc_reg <= 1'b1; // Assert disc
                    end
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                end
                S_SIX: begin
                    if (in) begin
                        state <= S_ERROR;
                        flag_reg <= 1'b0;
                    end
                    else begin
                        state <= S_IDLE;
                        flag_reg <= 1'b1; // Assert flag
                    end
                    disc_reg <= 1'b0;
                    err_reg <= 1'b0;

                end
                S_ERROR: begin
                    if (in)      state <= S_ERROR;
                    else         state <= S_IDLE;
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b1; // Assert error
                end
                default: begin
                    state <= S_IDLE;
                    disc_reg <= 1'b0;
                    flag_reg <= 1'b0;
                    err_reg <= 1'b0;
                end
            endcase
        end
    end
    // Output assignments
    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;


endmodule