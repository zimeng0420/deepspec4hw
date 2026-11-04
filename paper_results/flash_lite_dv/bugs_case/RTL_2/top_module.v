module top_module(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

    // Define the valid scancodes
    localparam SCANCODE_0 = 8'h45;
    localparam SCANCODE_1 = 8'h16;
    localparam SCANCODE_2 = 8'h1e;
    localparam SCANCODE_3 = 8'h26;
    localparam SCANCODE_4 = 8'h25;
    localparam SCANCODE_5 = 8'h2e;
    localparam SCANCODE_6 = 8'h36;
    localparam SCANCODE_7 = 8'h3d;
    localparam SCANCODE_8 = 8'h3e;
    localparam SCANCODE_9 = 8'h46;

    // Define wires for each key match
    wire key_0_match;
    wire key_1_match;
    wire key_2_match;
    wire key_3_match;
    wire key_4_match;
    wire key_5_match;
    wire key_6_match;
    wire key_7_match;
    wire key_8_match;
    wire key_9_match;

    // Comparator logic for each key
    assign key_0_match = (code == SCANCODE_0);
    assign key_1_match = (code == SCANCODE_1);
    assign key_2_match = (code == SCANCODE_2);
    assign key_3_match = (code == SCANCODE_3);
    assign key_4_match = (code == SCANCODE_4);
    assign key_5_match = (code == SCANCODE_5);
    assign key_6_match = (code == SCANCODE_6);
    assign key_7_match = (code == SCANCODE_7);
    assign key_8_match = (code == SCANCODE_8);
    assign key_9_match = (code == SCANCODE_9);

    // Determine validity by ORing all key match signals
    assign valid = key_0_match | key_1_match | key_2_match | key_3_match | key_4_match | key_5_match | key_6_match | key_7_match | key_8_match | key_9_match;


    // Use a case statement to assign the output based on the key match signals
    always @(*) begin
        case (1'b1)  // Using a constant 1 to avoid latches
            key_0_match: out = 4'b0000;
            key_1_match: out = 4'b0001;
            key_2_match: out = 4'b0010;
            key_3_match: out = 4'b0011;
            key_4_match: out = 4'b0100;
            key_5_match: out = 4'b0101;
            key_6_match: out = 4'b0110;
            key_7_match: out = 4'b0111;
            key_8_match: out = 4'b1000;
            key_9_match: out = 4'b1001;
            default:     out = 4'b0000; // Default output is 0 if no key is matched
        endcase
    end

endmodule