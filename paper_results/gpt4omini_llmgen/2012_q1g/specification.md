```verilog
module top_module (
    input [4:1] x,
    output logic f
);

    // Implementing the function based on the Karnaugh map.

    always_comb begin
        case ({x[4], x[3], x[2], x[1]})
            4'b0000: f = 1; // f(0, 0, 0, 0) = 1
            4'b0001: f = 0; // f(0, 0, 0, 1) = 0
            4'b0011: f = 0; // f(0, 0, 1, 1) = 0
            4'b0010: f = 1; // f(0, 0, 1, 0) = 1
            4'b0100: f = 0; // f(0, 1, 0, 0) = 0
            4'b0111: f = 1; // f(0, 1, 1, 1) = 1
            4'b0110: f = 1; // f(0, 1, 1, 0) = 1
            4'b0101: f = 0; // f(0, 1, 0, 1) = 0
            4'b1000: f = 1; // f(1, 0, 0, 0) = 1
            4'b1001: f = 1; // f(1, 0, 0, 1) = 1
            4'b1011: f = 0; // f(1, 0, 1, 1) = 0
            4'b1010: f = 1; // f(1, 0, 1, 0) = 1
            4'b1100: f = 0; // f(1, 1, 0, 0) = 0
            4'b1111: f = 0; // f(1, 1, 1, 1) = 0
            4'b1110: f = 1; // f(1, 1, 1, 0) = 1
            4'b1101: f = 0; // f(1, 1, 0, 1) = 0
            default: f = 0; // Default case
        endcase
    end

endmodule
```