module top_module (
    input [4:1] x,
    output logic f
);

    always_comb begin
        case (x)
            4'b0001, 4'b0010, 4'b0011: f = 0;
            4'b0110, 4'b0111, 4'b1000, 4'b1001: f = 1;
            default: f = 0; // Assigning default value for don't-care conditions
        endcase
    end

endmodule