module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out  // Corrected: out must be a reg since assigned within an always block
);

    always @(*) begin // Use always @(*) for combinational logic
        if (sel) begin
            out = b;
        end else begin
            out = a;
        end
    end

endmodule