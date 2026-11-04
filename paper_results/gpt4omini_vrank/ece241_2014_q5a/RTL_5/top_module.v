module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);
    reg [31:0] data; // To hold the incoming bits
    reg [5:0] count; // To keep track of the number of bits received
    reg [32:0] twos_complement; // To store the 2's complement
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            data <= 0;
            count <= 0;
            z <= 0;
        end else begin
            // Shift in input x
            data <= {data[30:0], x}; // Capture the next bit
            count <= count + 1;

            // Once we have collected all bits, compute the 2's complement
            if (count == 32) begin
                twos_complement <= ~data + 1; // Calculate 2's complement
                z <= twos_complement[0]; // Output the least significant bit
                count <= 0; // Reset count for the next number
                data <= 0; // Clear data for next input
            end else begin
                // Output continues to be the LSB of twos_complement during the counting
                z <= twos_complement[0];
            end
        end
    end
endmodule