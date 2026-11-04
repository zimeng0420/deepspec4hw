module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);
    
    // State encoding
    localparam STATE_000 = 3'b000,
               STATE_001 = 3'b001,
               STATE_010 = 3'b010,
               STATE_011 = 3'b011,
               STATE_100 = 3'b100;
               
    reg [2:0] y, y_next;

    // State transition logic (sequential)
    always @(posedge clk) begin
        if (reset)
            y <= STATE_000;
        else
            y <= y_next;
    end

    // Next-state logic (combinational)
    always @(*) begin
        case (y)
            STATE_000: y_next = x ? STATE_001 : STATE_000;
            STATE_001: y_next = x ? STATE_100 : STATE_001;
            STATE_010: y_next = x ? STATE_001 : STATE_010;
            STATE_011: y_next = x ? STATE_010 : STATE_001;
            STATE_100: y_next = x ? STATE_100 : STATE_011;
            default: y_next = STATE_000;
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        case (y)
            STATE_011: z = 1;
            STATE_100: z = 1;
            default: z = 0;
        endcase
    end

endmodule