module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg [31:0] data; // 32-bit data register for the input
    reg [5:0] count; // to count number of bits received
    reg valid;       // to indicate when output is valid

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            data <= 0;
            count <= 0;
            valid <= 0;
            z <= 0;
        end else if (!areset) begin
            // Shift in the new bit
            data <= {x, data[31:1]};
            count <= count + 1;

            // When count reaches 32, it indicates we received all bits (or limit)
            if (count < 32) begin
                valid <= 1;
            end else begin
                valid <= 0;
            end
        end
    end

    always @(*) begin
        if (valid) begin
            z = ~data + 1; // Compute 2's complement
        end else begin
            z = 0; // Default output
        end
    end

endmodule