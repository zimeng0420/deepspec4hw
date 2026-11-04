module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_state;

    assign next_state[0] = (q[0] & q[1]) ? 1'b0 : (q[1] ? 1'b1 : 1'b0);
    assign next_state[511] = (q[510] & q[511]) ? 1'b0 : (q[511] ? 1'b1 : 1'b0);
    
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : rule110
            assign next_state[i] = (q[i-1] & q[i]) ? (q[i+1] ? 1'b0 : 1'b1) : 
                                    (q[i] ? (q[i+1] ? 1'b1 : 1'b0) : 
                                    (q[i+1] ? 1'b1 : 1'b0));
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule