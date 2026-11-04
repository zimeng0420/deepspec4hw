module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);
    parameter OFF = 1'b0, ON = 1'b1;
    reg state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            OFF: begin
                if (j) 
                    next_state = ON;
                else 
                    next_state = OFF;
            end
            ON: begin
                if (k) 
                    next_state = OFF;
                else 
                    next_state = ON;
            end
            default: next_state = OFF; // Default case for safety
        endcase
    end

    always @(state) begin
        out = (state == ON) ? 1'b1 : 1'b0;
    end
endmodule