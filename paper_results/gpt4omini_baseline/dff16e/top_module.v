module top_module(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    reg [15:0] dff;

    always @(posedge clk) begin
        if (!resetn) begin
            dff <= 16'b0;
        end else begin
            if (byteena[0]) begin
                dff[7:0] <= d[7:0];
            end
            if (byteena[1]) begin
                dff[15:8] <= d[15:8];
            end
        end
    end

    assign q = dff;

endmodule