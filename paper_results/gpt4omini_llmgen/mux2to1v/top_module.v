module top_module (
    input [99:0] a,
    input [99:0] b,
    input sel,
    output reg [99:0] out
);

    always @(*) begin
        if (sel == 0) begin
            out = a; // Select input a when sel is 0
        end else begin
            out = b; // Select input b when sel is 1
        end
    end

endmodule