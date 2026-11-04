module top_module (
    input clk,
    input j,
    input k,
    output reg Q
);

    reg Qold;

    always @(posedge clk) begin
        Qold <= Q; // Store the old value of Q
        case ({j, k})
            2'b00: Q <= Qold;  // Qold
            2'b01: Q <= 0;     // 0
            2'b10: Q <= 1;     // 1
            2'b11: Q <= ~Qold;  // ~Qold
        endcase
    end

endmodule