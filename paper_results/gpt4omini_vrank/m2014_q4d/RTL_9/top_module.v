module top_module (
    input clk,
    input in,
    output logic out
);
    logic d;
    
    assign d = in ^ out; // XOR operation

    always_ff @(posedge clk) begin
        out <= d; // D flip-flop
    end
endmodule