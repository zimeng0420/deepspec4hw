module top_module (
    input  [7:0] code,
    output [3:0] out,
    output valid
);

    // Define valid scancodes
    localparam KEY_0_SCANCODE = 8'h45;
    localparam KEY_1_SCANCODE = 8'h16;
    localparam KEY_2_SCANCODE = 8'h1e;
    localparam KEY_3_SCANCODE = 8'h26;
    localparam KEY_4_SCANCODE = 8'h25;
    localparam KEY_5_SCANCODE = 8'h2e;
    localparam KEY_6_SCANCODE = 8'h36;
    localparam KEY_7_SCANCODE = 8'h3d;
    localparam KEY_8_SCANCODE = 8'h3e;
    localparam KEY_9_SCANCODE = 8'h46;

    // Comparators for each scancode
    wire key_0_match = (code == KEY_0_SCANCODE);
    wire key_1_match = (code == KEY_1_SCANCODE);
    wire key_2_match = (code == KEY_2_SCANCODE);
    wire key_3_match = (code == KEY_3_SCANCODE);
    wire key_4_match = (code == KEY_4_SCANCODE);
    wire key_5_match = (code == KEY_5_SCANCODE);
    wire key_6_match = (code == KEY_6_SCANCODE);
    wire key_7_match = (code == KEY_7_SCANCODE);
    wire key_8_match = (code == KEY_8_SCANCODE);
    wire key_9_match = (code == KEY_9_SCANCODE);


    // Validity signal
    assign valid = key_0_match || key_1_match || key_2_match || key_3_match || key_4_match ||
                   key_5_match || key_6_match || key_7_match || key_8_match || key_9_match;


    // Output logic using a case statement
    always_comb begin
        case (1'b1)  // Always evaluate since it's combinational
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
            default:     out = 4'b0000;
        endcase
    end

endmodule