module top_module (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        case (state)
            10'b0000000001: // S0
                begin
                    if (in)
                        next_state = 10'b0000000010; // S1
                    else
                        next_state = 10'b0000000001; // S0
                    out1 = 0;
                    out2 = 0;
                end
            10'b0000000010: // S1
                begin
                    if (in)
                        next_state = 10'b0000000100; // S2
                    else
                        next_state = 10'b0000000001; // S0
                    out1 = 0;
                    out2 = 0;
                end
            10'b0000000100: // S2
                begin
                    if (in)
                        next_state = 10'b0000001000; // S3
                    else
                        next_state = 10'b0000000001; // S0
                    out1 = 0;
                    out2 = 0;
                end
            10'b0000001000: // S3
                begin
                    if (in)
                        next_state = 10'b0000010000; // S4
                    else
                        next_state = 10'b0000000001; // S0
                    out1 = 0;
                    out2 = 0;
                end
            10'b0000010000: // S4
                begin
                    if (in)
                        next_state = 10'b0000100000; // S5
                    else
                        next_state = 10'b0000000001; // S0
                    out1 = 0;
                    out2 = 0;
                end
            10'b0000100000: // S5
                begin
                    if (in)
                        next_state = 10'b0001000000; // S6
                    else
                        next_state = 10'b0000000001; // S8
                    out1 = 0;
                    out2 = 0;
                end
            10'b0001000000: // S6
                begin
                    if (in)
                        next_state = 10'b0010000000; // S7
                    else
                        next_state = 10'b0100000000; // S9
                    out1 = 0;
                    out2 = 0;
                end
            10'b0010000000: // S7
                begin
                    if (in)
                        next_state = 10'b0010000000; // S7
                    else
                        next_state = 10'b0000000001; // S0
                    out1 = 0;
                    out2 = 1;
                end
            10'b0100000000: // S8
                begin
                    if (in)
                        next_state = 10'b0000000010; // S1
                    else
                        next_state = 10'b0000000001; // S0
                    out1 = 1;
                    out2 = 0;
                end
            10'b1000000000: // S9
                begin
                    if (in)
                        next_state = 10'b0000000010; // S1
                    else
                        next_state = 10'b0000000001; // S0
                    out1 = 1;
                    out2 = 1;
                end
            default:
                begin
                    next_state = 10'b0000000001; // S0
                    out1 = 0;
                    out2 = 0;
                end
        endcase
    end

endmodule