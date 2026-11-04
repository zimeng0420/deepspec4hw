module top_module (
    input [4:1] x,
    output logic f
);
    always_comb begin
        case (x)
            4'b0001, 4'b0111: f = 1'b0;
            4'b0100, 4'b0101, 4'b1111, 4'b1110: f = 1'b1;
            4'b1000, 4'b1001: f = 1'b1;
            4'b1010: f = 1'b0;
            default: f = 1'b0; // handling don't care cases
        endcase
    end
endmodule