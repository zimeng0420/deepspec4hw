module top_module (
    input [4:1] x,
    output logic f
);

    always_comb begin
        f = (!x[3] & !x[4] &  x[1] & !x[2]) | // Minterm 1
            ( x[3] &  x[4] & !x[1] & !x[2]) | // Minterm 2
            ( x[3] &  x[4] & !x[1] &  x[2]) | // Minterm 3
            ( x[3] &  x[4] &  x[1] &  x[2]) | // Minterm 4
            ( x[3] & !x[4] & !x[1] & !x[2]) | // Minterm 5
            ( x[3] & !x[4] & !x[1] &  x[2]) | // Minterm 6
            ( x[3] & !x[4] &  x[1] & !x[2]) | // Minterm 7
            (!x[3] & !x[4] & !x[1] & !x[2]); // Minterm 8
    end

endmodule