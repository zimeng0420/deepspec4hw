module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    always @(posedge clk) begin
        // Combinational logic to determine the output 'q' and 'state'
        if (b) begin
            q <= 1;
            state <= 1;
        end else if (a) begin
            q <= 0;
            state <= 0;
        end else begin
            state <= state; // Retain previous state
        end
    end

endmodule