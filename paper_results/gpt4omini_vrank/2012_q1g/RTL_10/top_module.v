module top_module (
    input [4:1] x,
    output logic f
);
    assign f = (x[4] == 0 && x[3] == 0 && x[2] == 0 && x[1] == 0) || // 1 for minterm 0
                (x[4] == 0 && x[3] == 0 && x[2] == 1 && x[1] == 0) || // 1 for minterm 3
                (x[4] == 1 && x[3] == 1 && x[2] == 1 && x[1] == 0) || // 1 for minterm 6
                (x[4] == 1 && x[3] == 0 && x[2] == 0 && x[1] == 1) || // 1 for minterm 9
                (x[4] == 1 && x[3] == 1 && x[2] == 0 && x[1] == 1) || // 1 for minterm 7
                (x[4] == 0 && x[3] == 1 && x[2] == 0 && x[1] == 1);   // 1 for minterm 4
endmodule