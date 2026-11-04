module top_module(
    input clk,
    input d,
    output reg q
);

    reg q_posedge, q_negedge;

    always @(posedge clk) begin
        q_posedge <= d; // Capture d on the rising edge
    end

    always @(negedge clk) begin
        q_negedge <= d; // Capture d on the falling edge
    end

    always @(*) begin
        q = clk ? q_posedge : q_negedge; // Output based on clock level
    end

endmodule