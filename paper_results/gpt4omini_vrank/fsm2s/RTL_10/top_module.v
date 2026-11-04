module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    typedef enum reg [1:0] {OFF, ON} state_t; 
    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    always @(state, j, k) begin
        case (state)
            OFF: begin
                out = 1'b0; // output for OFF state
                if (j == 1'b1) next_state = ON; // transition to ON
                else next_state = OFF; // stay in OFF
            end

            ON: begin
                out = 1'b1; // output for ON state
                if (k == 1'b1) next_state = OFF; // transition to OFF
                else next_state = ON; // stay in ON
            end

            default: next_state = OFF; // default state
        endcase
    end

endmodule