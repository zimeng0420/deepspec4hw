module top_module (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    case ({j, k})
        2'b00: Q <= Q;          // Retain the previous state
        2'b01: Q <= 0;          // Reset to 0
        2'b10: Q <= 1;          // Set to 1
        2'b11: Q <= ~Q;         // Toggle the state
    endcase
end

endmodule