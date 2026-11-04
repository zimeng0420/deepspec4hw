module top_module (
    input [3:0] in,
    output reg [1:0] pos
);
    always @(*) begin
        casez (in)
            4'b???1: pos = 2'd0; // input 4'b0001
            4'b??10: pos = 2'd1; // input 4'b0010
            4'b?100: pos = 2'd2; // input 4'b0100
            4'b1000: pos = 2'd3; // input 4'b1000
            default: pos = 2'd0; // if none are high, output zero
        endcase
    end
endmodule