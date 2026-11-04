module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);
    reg [31:0] data; // Internal register to hold the number
    reg [5:0] count; // Counter to keep track of bits processed
    reg state; // Current state

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            data <= 0;
            count <= 0;
            z <= 0;
            state <= 0; // Reset state
        end else begin
            if (state == 0) begin
                // Start of input capture
                data[count] <= x; // Capture the input bit
                count <= count + 1; // Increment counter
                if (count == 31) begin
                    state <= 1; // Move to computing state after 32 bits
                end
            end else if (state == 1) begin
                // Compute 2's complement
                z <= ~data + 1; // Negate and add 1 for 2's complement
                state <= 0; // Return to initial state after computation
            end
        end
    end
endmodule