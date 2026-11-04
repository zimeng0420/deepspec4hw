```verilog
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
```

### Technical Specification:
1. **Shift Register**:
    - 8 D-type flip-flops.
    - Shift in from input `S`, MSB first (Q[0] receives S on the first clock cycle).
    - Synchronous shifting controlled by input `enable`.

2. **Inputs**:
    - `clk`: Clock signal for synchronizing operations.
    - `enable`: Controls whether the shift register performs shifting on the rising edge of `clk`.
    - `S`: Data input to be shifted into the register.
    - `A`, `B`, `C`: 3-bit address inputs for selecting which output of the shift register to assign to `Z`.

3. **Output**:
    - `Z`: The output selected based on the value of `A`, `B`, and `C`, directly mapping to the respective output from the shift register.

4. **Behavior**:
    - When `A`, `B`, and `C` are `000`, `Z` outputs the value of `Q[0]` (first bit).
    - Increments through `Q[1]` to `Q[7]` according to binary values from `ABC`.
    - Default case sets `Z` to `0` if inputs fall outside the defined cases.

This design ensures that the circuitry complies with the given behavior using only an 8-bit shift register and multiplexing logic for output selection.