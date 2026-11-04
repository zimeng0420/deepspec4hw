module top_module (
    input [254:0] in,
    output reg [7:0] out
);

    integer i;
    always @(*) begin
        out = 8'd0; // Initialize the output to zero
        for (i = 0; i < 255; i = i + 1) begin // Loop over each bit
            out = out + in[i]; // Add the current bit value to the output count
        end
    end

endmodule