module top_module (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

// Logic for Y0
always @(*) begin
    case (y) 
        3'b000: Y0 = (x == 1) ? 1 : 0; 
        3'b001: Y0 = 0; 
        3'b010: Y0 = (x == 1) ? 1 : 0; 
        3'b011: Y0 = (x == 0) ? 1 : 0; 
        3'b100: Y0 = (x == 0) ? 1 : 0; 
        default: Y0 = 0; 
    endcase 
end 

// Logic for z
always @(*) begin
    case (y) 
        3'b000: z = 0; 
        3'b001: z = 0; 
        3'b010: z = 0; 
        3'b011: z = 1; 
        3'b100: z = 1; 
        default: z = 0; 
    endcase 
end 

endmodule 