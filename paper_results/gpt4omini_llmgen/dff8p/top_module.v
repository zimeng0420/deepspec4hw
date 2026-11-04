module top_module(
    input clk,
    input [7:0] d,
    input reset,
    output reg [7:0] q
);

    // Declare 8 D flip-flops with a synchronous reset
    reg [7:0] dff [0:7];
    
    // Define the synchronous reset value to be 0x34
    localparam RESET_VALUE = 8'h34;

    // Always block to handle the D flip-flops
    always @(negedge clk) begin
        if (reset) begin
            // Reset all D flip-flops to 0x34
            dff[0] <= RESET_VALUE;
            dff[1] <= RESET_VALUE;
            dff[2] <= RESET_VALUE;
            dff[3] <= RESET_VALUE;
            dff[4] <= RESET_VALUE;
            dff[5] <= RESET_VALUE;
            dff[6] <= RESET_VALUE;
            dff[7] <= RESET_VALUE;
        end else begin
            // Shift the input data into the flip-flops
            dff[0] <= d;
            dff[1] <= dff[0];
            dff[2] <= dff[1];
            dff[3] <= dff[2];
            dff[4] <= dff[3];
            dff[5] <= dff[4];
            dff[6] <= dff[5];
            dff[7] <= dff[6];
        end
    end

    // Assign the output to the last D flip-flop
    always @(posedge clk) begin
        q <= dff[7]; // Output from the last DFF
    end

endmodule