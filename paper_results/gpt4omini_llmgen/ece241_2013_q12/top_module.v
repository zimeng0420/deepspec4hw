module top_module (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

// 8-bit Shift Register Declaration
reg [7:0] shift_reg;

// Always block for shift operation
always @(posedge clk) begin
    if (enable) begin
        shift_reg <= {S, shift_reg[7:1]}; // Shift in MSB first
    end
end

// Multiplexer for random access output
always @(*) begin
    case ({A, B, C}) // Concatenating A, B, C to form a 3-bit address
        3'b000: Z = shift_reg[0]; // when ABC = 000
        3'b001: Z = shift_reg[1]; // when ABC = 001
        3'b010: Z = shift_reg[2]; // when ABC = 010
        3'b011: Z = shift_reg[3]; // when ABC = 011
        3'b100: Z = shift_reg[4]; // when ABC = 100
        3'b101: Z = shift_reg[5]; // when ABC = 101
        3'b110: Z = shift_reg[6]; // when ABC = 110
        3'b111: Z = shift_reg[7]; // when ABC = 111
        default: Z = 1'b0;         // Default case
    endcase
end

endmodule