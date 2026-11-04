module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;
    
    // State register
    reg state, next_state;
    
    // State transition logic (combinational)
    always @(*) begin
        case (state)
            B: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            A: begin
                if (in == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end
        endcase
    end
    
    // Sequential state update
    always @(posedge clk) begin
        if (reset) 
            state <= B;  // Reset state is B
        else
            state <= next_state;
    end
    
    // Output logic
    always @(*) begin
        case (state)
            B: out = 1'b1;
            A: out = 1'b0;
        endcase
    end

endmodule