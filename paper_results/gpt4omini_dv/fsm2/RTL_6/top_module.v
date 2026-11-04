module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);

    reg state, next_state;

    // State definitions
    localparam OFF = 1'b0, ON = 1'b1;

    // Asynchronous reset and state update on clk edge
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
        endcase
    end

    // Output logic
    assign out = state;

endmodule