module top_module (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    input [15:0] e,
    input [15:0] f,
    input [15:0] g,
    input [15:0] h,
    input [15:0] i,
    input [3:0] sel,
    output logic [15:0] out
);

    always_comb begin
        case(sel)
            4'd0: out = a;   // When sel = 0, output a
            4'd1: out = b;   // When sel = 1, output b
            4'd2: out = c;   // When sel = 2, output c
            4'd3: out = d;   // When sel = 3, output d
            4'd4: out = e;   // When sel = 4, output e
            4'd5: out = f;   // When sel = 5, output f
            4'd6: out = g;   // When sel = 6, output g
            4'd7: out = h;   // When sel = 7, output h
            4'd8: out = i;   // When sel = 8, output i
            default: out = 16'b1111111111111111; // sel = 9 to 15, output all ones
        endcase
    end

endmodule