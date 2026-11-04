module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);
    reg state;
    
    // State encoding
    parameter A = 1'b0, B = 1'b1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Asynchronously reset to state B
        end else begin
            case (state)
                B: begin
                    if (in == 0) 
                        state <= A; 
                    // else remain in B 
                end
                A: begin
                    if (in == 1) 
                        state <= A; 
                    else 
                        state <= B; 
                end
            endcase
        end
    end

    always @(state) begin
        out = state; // Output is the current state
    end
endmodule