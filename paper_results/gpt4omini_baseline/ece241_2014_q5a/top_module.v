module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg [31:0] data; // Assuming maximum input length is 32 bits
    reg [5:0] count; // To count the number of input bits
    reg done;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            data <= 0;
            count <= 0;
            z <= 0;
            done <= 0;
        end else if (!done) begin
            data[count] <= x; // Store each input bit
            count <= count + 1;
            if (count == 31) begin // Stop collecting after 32 bits
                done <= 1;
            end
        end else begin
            z <= ~data[count - 1]; // Output the 2's complement MSB first
            count <= count - 1;
            if (count == 0) begin
                done <= 0; // Reset done state to process a new number
            end
        end
    end

endmodule