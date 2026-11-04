module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q);

    reg [511:0] next_q;

    always @(*) begin
        for (int i = 0; i < 512; i++) begin
            // Determine the neighbors
            integer left = (i == 0) ? 0 : q[i-1];
            integer right = (i == 511) ? 0 : q[i+1];
            integer center = q[i];
            
            // Implement Rule 110
            if (left == 1 && center == 1 && right == 1) next_q[i] = 0;
            else if (left == 1 && center == 1 && right == 0) next_q[i] = 1;
            else if (left == 1 && center == 0 && right == 1) next_q[i] = 1;
            else if (left == 1 && center == 0 && right == 0) next_q[i] = 0;
            else if (left == 0 && center == 1 && right == 1) next_q[i] = 1;
            else if (left == 0 && center == 1 && right == 0) next_q[i] = 1;
            else if (left == 0 && center == 0 && right == 1) next_q[i] = 1;
            else next_q[i] = 0;
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule