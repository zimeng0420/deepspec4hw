module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out  // Corrected: output must be reg when assigned inside an always block
);

    always @(*) begin  // Use an always block for assigning to a reg
        if (sel) begin
            out = b;
        end else begin
            out = a;
        end
    end

endmodule