module top_module (
    input [3:0] in,
    output reg [1:0] pos
);
    always @(*) begin
        casez(in)
            4'b1??? : pos = 2'b11; // Highest priority for in[3]
            4'b01?? : pos = 2'b10; // Next priority for in[2]
            4'b001? : pos = 2'b01; // Next priority for in[1]
            4'b0001 : pos = 2'b00; // Lowest priority for in[0]
            default : pos = 2'b00; // Default when all inputs are 0
        endcase
    end
endmodule