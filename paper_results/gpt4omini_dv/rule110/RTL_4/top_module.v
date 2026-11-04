module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q);

    wire [511:0] q_next;
    wire [511:0] q_temp;

    assign q_temp[0] = (1'b0 & q[0] & q[1]) | (1'b0 & q[0] & ~q[1]) | (~1'b0 & q[0] & q[1]) | (~1'b0 & ~q[0] & q[1]) | (~1'b0 & ~q[0] & ~q[1]);
    generate
        genvar i;
        for (i = 1; i < 511; i = i + 1) begin: cell_logic
            assign q_temp[i] = (q[i-1] & q[i] & q[i+1]) ? 1'b0 :
                                (q[i-1] & q[i] & ~q[i+1]) ? 1'b1 :
                                (q[i-1] & ~q[i] & q[i+1]) ? 1'b1 :
                                (q[i-1] & ~q[i] & ~q[i+1]) ? 1'b0 :
                                (~q[i-1] & q[i] & q[i+1]) ? 1'b1 :
                                (~q[i-1] & q[i] & ~q[i+1]) ? 1'b1 :
                                (~q[i-1] & ~q[i] & q[i+1]) ? 1'b1 :
                                1'b0;
        end
    endgenerate
    assign q_temp[511] = (q[510] & q[511] & 1'b0) | (q[510] & q[511] & 1'b0) | (~q[510] & q[511] & 1'b0) | (~q[510] & ~q[511] & 1'b0) | (~q[510] & ~q[511] & 1'b0);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_temp;
        end
    end

endmodule