module top_module (
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
);

    always @* begin
        case (sel)
            3'b000: out = data0;  // Select data0 if sel is 0
            3'b001: out = data1;  // Select data1 if sel is 1
            3'b010: out = data2;  // Select data2 if sel is 2
            3'b011: out = data3;  // Select data3 if sel is 3
            3'b100: out = data4;  // Select data4 if sel is 4
            3'b101: out = data5;  // Select data5 if sel is 5
            default: out = 4'b0000; // Output 0 if sel is greater than 5
        endcase
    end

endmodule