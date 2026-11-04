module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0, ON = 1'b1;
    
    // State register to hold the current state
    reg current_state, next_state;
    
    // State transition logic
    always @(*) begin
        case (current_state)
            OFF: 
                if (j == 1)
                    next_state = ON;
                else
                    next_state = OFF;
            ON:
                if (k == 1)
                    next_state = OFF;
                else
                    next_state = ON;
            default: 
                next_state = OFF; // Default state
        endcase
    end

    // Synchronous state update logic
    always @(posedge clk) begin
        if (reset)
            current_state <= OFF;
        else
            current_state <= next_state;
    end

    // Output logic
    always @(*) begin
        out = current_state;
    end

endmodule