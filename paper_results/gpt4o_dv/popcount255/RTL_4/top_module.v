module top_module (
    input [254:0] in,
    output reg [7:0] out
);

    integer i;
    reg [7:0] count;

    always @(*) begin
        count = 8'b0;  // Initialize the count to zero
        for (i = 0; i < 255; i = i + 1) begin
            count = count + in[i];  // Sum up the '1's in the input vector
        end
        out = count;  // Assign the count to the output
    end

endmodule