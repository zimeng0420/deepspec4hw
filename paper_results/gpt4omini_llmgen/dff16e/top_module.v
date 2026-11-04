module top_module(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);
    
    // Internal signals for D flip-flops
    reg [15:0] d_flops;

    // Always block for synchronous D flip-flop behavior
    always @(posedge clk) begin
        if (!resetn) begin
            // Reset all flip-flops to 0 on active-low reset
            d_flops <= 16'b0;
        end else begin
            // Upper byte: d[15:8]
            if (byteena[1]) begin
                d_flops[15:8] <= d[15:8];
            end
            // Lower byte: d[7:0]
            if (byteena[0]) begin
                d_flops[7:0] <= d[7:0];
            end
        end
    end

    // Output assignment
    always @* begin
        q = d_flops; // Assign the stored values in D flip-flops to output
    end

endmodule