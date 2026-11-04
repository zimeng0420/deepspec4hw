module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out
);

    always @(*) begin
        if (sel) begin
            out = b;  // Select input b when sel is 1
        end else begin
            out = a;  // Select input a when sel is 0
        end
    end

endmodule