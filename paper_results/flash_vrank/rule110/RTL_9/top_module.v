module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q);

    reg [511:0] next_q;

    always @(*) begin
        for (int i = 0; i < 512; i++) begin
            // Determine the neighbours' states. Treat out-of-bounds as zero.
            reg left = (i == 0) ? 0 : q[i-1];
            reg center = q[i];
            reg right = (i == 511) ? 0 : q[i+1];

            // Implement Rule 110 logic.
            if (left && center && right)      next_q[i] = 0;
            else if (left && center && !right) next_q[i] = 1;
            else if (left && !center && right) next_q[i] = 1;
            else if (left && !center && !right)next_q[i] = 0;
            else if (!left && center && right) next_q[i] = 1;
            else if (!left && center && !right)next_q[i] = 1;
            else if (!left && !center && right)next_q[i] = 1;
            else /*(!left && !center && !right)*/ next_q[i] = 0;
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