module top_module (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

always @(posedge clk) begin
    case (y)
        3'b000: begin
            Y0 <= x ? 1'b1 : 1'b0; // Next state Y = 001
            z <= 1'b0;
        end
        3'b001: begin
            Y0 <= x ? 1'b0 : 1'b1; // Next state Y = 100 for x=1, Y=001 for x=0
            z <= 1'b0;
        end
        3'b010: begin
            Y0 <= x ? 1'b1 : 1'b0; // Next state Y = 001 for x=1, Y=010 for x=0
            z <= 1'b0;
        end
        3'b011: begin
            Y0 <= x ? 1'b0 : 1'b1; // Next state Y = 010 for x=1, Y=001 for x=0
            z <= 1'b1;
        end
        3'b100: begin
            Y0 <= 1'b0; // Next state Y = 100 for x=1, Y=011 for x=0
            z <= 1'b1;
        end
        default: begin
            Y0 <= 1'b0; // Default case
            z <= 1'b0;
        end
    endcase
end

endmodule