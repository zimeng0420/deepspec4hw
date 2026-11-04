module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);
    reg state, next_state;

    parameter OFF = 1'b0, ON = 1'b1;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state
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
            default: next_state = OFF; // Default case
        endcase
    end

    // Output logic
    always @(*) begin
        out = state;
    end
endmodule