module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);
    
    always @(posedge clk) begin
        if (a == 0 && b == 1) begin
            state <= ~state;
        end
        else if (a == 1 && b == 1) begin
            state <= ~state;
        end
        
        case (state)
            1'b0: q <= (a & ~b) | (~a & b);
            1'b1: q <= (~a & ~b) | (a & b);
        endcase 
    end
    
endmodule