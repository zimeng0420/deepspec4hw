module top_module(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Define states
    parameter S_IDLE = 0,
              S_ONE  = 1,
              S_TWO  = 2,
              S_THREE= 3,
              S_FOUR = 4,
              S_FIVE = 5,
              S_SIX  = 6,
              S_ERROR= 7;

    // State register
    reg [2:0] current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_IDLE;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            current_state <= next_state;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end
    end

    // Next state and output logic
    always @(*) begin
        next_state = S_IDLE; // Default next state

        case (current_state)
            S_IDLE: begin
                if (in) next_state = S_ONE;
            end
            S_ONE: begin
                if (in) next_state = S_TWO;
                else next_state = S_IDLE;
            end
            S_TWO: begin
                if (in) next_state = S_THREE;
                else next_state = S_IDLE;
            end
            S_THREE: begin
                if (in) next_state = S_FOUR;
                else next_state = S_IDLE;
            end
            S_FOUR: begin
                if (in) next_state = S_FIVE;
                else next_state = S_IDLE;
            end
            S_FIVE: begin
                if (in) next_state = S_SIX;
                else begin
                    next_state = S_IDLE;
                    disc = 1'b1;
                end
            end
            S_SIX: begin
                if (in) next_state = S_ERROR;
                else begin
                    next_state = S_IDLE;
                    flag = 1'b1;
                end
            end
            S_ERROR: begin
                if (!in) next_state = S_IDLE;
                else next_state = S_ERROR;
                err = 1'b1;
            end
            default: next_state = S_IDLE;
        endcase
    end

endmodule