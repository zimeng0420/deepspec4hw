module top_module (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

    // Internal Signals
    reg [7:0] Q; // 8-bit shift register
    wire [2:0] address; // Address for multiplexer

    // 8-bit Shift Register Implementation
    always @(posedge clk) begin
        if (enable) begin
            Q[7:1] <= Q[6:0]; // Shift existing bits
            Q[0] <= S;        // Shift in new bit
        end
    end

    // Address Generation (ABC to binary address)
    assign address = {A, B, C};

    // Multiplexer for Random Access Read
    always @(*) begin
        case (address)
            3'b000: Z = Q[0];
            3'b001: Z = Q[1];
            3'b010: Z = Q[2];
            3'b011: Z = Q[3];
            3'b100: Z = Q[4];
            3'b101: Z = Q[5];
            3'b110: Z = Q[6];
            3'b111: Z = Q[7];
            default: Z = 1'bx; // Handle unexpected input (optional, but good practice)
        endcase
    end

endmodule