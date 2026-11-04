```verilog
module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON = 1'b1;
    
    reg state, next_state;

    // Combinational logic to determine next state
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
            default: next_state = OFF; // Default state
        endcase
    end

    // Sequential block to update the state
    always @(posedge clk) begin
        if (reset)
            state <= OFF; // Synchronous reset to OFF state
        else
            state <= next_state; // Update state
    end

    // Output logic
    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule
```