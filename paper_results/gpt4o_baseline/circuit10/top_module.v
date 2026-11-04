module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    always @(posedge clk) begin
        // State transition and output logic
        if (a & b) begin
            state <= ~state;
        end else if (a & ~b) begin
            state <= 1'b1;
        end else if (~a & b) begin
            state <= 1'b0;
        end
        
        // Output q follows the state
        q <= state;
    end

endmodule