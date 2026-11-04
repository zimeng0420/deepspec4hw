module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    pedge <= (prev_in == 8'b00000000 && in == 8'b00000001) ? 8'b00000001 :
              (prev_in == 8'b00000001 && in == 8'b00000011) ? {pedge[6:0], 1'b1} : 
              {pedge[6:0], 1'b0}; // Update the pedge based on bit transition
    prev_in <= in; // Update the previous state
end

endmodule