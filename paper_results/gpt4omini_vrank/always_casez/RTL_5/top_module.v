module top_module (
    input [7:0] in,
    output reg [2:0] pos
);
    integer i;
    always @(*) begin
        pos = 3'b000; // default output is 0
        for (i = 0; i < 8; i = i + 1) begin
            if (in[i]) begin
                pos = i; // output the position of the first 1 bit
                break;
            end
        end
    end
endmodule