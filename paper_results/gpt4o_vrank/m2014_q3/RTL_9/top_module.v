module top_module (
    input [4:1] x,
    output logic f
);
    always_comb begin
        casez (x)
            4'b00?0: f = 1'b0; // Handle 00 01, 10.
            4'b0101: f = 1'b1; // Handle 01 11.
            4'b1000,
            4'b1001,
            4'b1100,
            4'b1101: f = 1'b1; // Handle 11 00, 01.
            default: f = 1'b0; // d cases can be conveniently set to 0
        endcase
    end
endmodule