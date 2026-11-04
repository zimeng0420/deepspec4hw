module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q);
    
    integer i;
    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 512; i = i + 1) begin
                if (i == 0) begin
                    q[i] <= q[1]; // q[-1] is considered 0, so q[0]'s new value is q[1]^(0)
                end else if (i == 511) begin
                    q[i] <= q[510]; // q[512] is considered 0, so q[511]'s new value is q[510]^(0)
                end else begin
                    q[i] <= q[i-1] ^ q[i+1]; // General case
                end
            end
        end
    end
    
endmodule