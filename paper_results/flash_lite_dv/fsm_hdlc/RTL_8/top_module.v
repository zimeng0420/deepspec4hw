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
    reg [2:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            S_IDLE: begin
                disc = 1'b0;
                flag = 1'b0;
                err  = 1'b0;
                if (in) next_state = S_ONE; else next_state = S_IDLE;
            end
            S_ONE: begin
                disc = 1'b0;
                flag = 1'b0;
                err  = 1'b0;
                if (in) next_state = S_TWO; else next_state = S_IDLE;
            end
            S_TWO: begin
                disc = 1'b0;
                flag = 1'b0;
                err  = 1'b0;
                if (in) next_state = S_THREE; else next_state = S_IDLE;
            end
            S_THREE: begin
                disc = 1'b0;
                flag = 1'b0;
                err  = 1'b0;
                if (in) next_state = S_FOUR; else next_state = S_IDLE;
            end
            S_FOUR: begin
                disc = 1'b0;
                flag = 1'b0;
                err  = 1'b0;
                if (in) next_state = S_FIVE; else next_state = S_IDLE;
            end
            S_FIVE: begin
                disc = 1'b0;
                flag = 1'b0;
                err  = 1'b0;
                if (in) begin
                    next_state = S_SIX;
                end else begin
                   next_state = S_IDLE;
                   disc = 1'b1;
                end
            end
            S_SIX: begin
                disc = 1'b0;
                flag = 1'b0;
                err  = 1'b0;
                if (in) begin
                    next_state = S_ERROR;
                end else begin
                    next_state = S_IDLE;
                    flag = 1'b1;
                end
            end
            S_ERROR: begin
                disc = 1'b0;
                flag = 1'b0;
                err  = 1'b1;
                if (in) next_state = S_ERROR; else next_state = S_IDLE;
            end
            default: begin
                disc = 1'b0;
                flag = 1'b0;
                err  = 1'b0;
                next_state = S_IDLE;
            end
        endcase
    end

    // State register update (synchronous)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_IDLE;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

endmodule