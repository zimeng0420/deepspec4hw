module top_module (
    input [4:1] x,
    output logic f
);
    always_comb begin
        case (x[4:3])
            2'b00: f = (x[2:1] == 2'b00 || x[2:1] == 2'b10) ? 1 : 0; // f = 1 for 00 and 10
            2'b01: f = 0; // f = 0 for 01
            2'b11: f = (x[2:1] == 2'b00 || x[2:1] == 2'b01 || x[2:1] == 2'b11) ? 1 : 0; // f = 1 for 00, 01 and 11
            2'b10: f = (x[2:1] == 2'b00 || x[2:1] == 2'b01) ? 1 : 0; // f = 1 for 00 and 01
            default: f = 0;
        endcase
    end
endmodule