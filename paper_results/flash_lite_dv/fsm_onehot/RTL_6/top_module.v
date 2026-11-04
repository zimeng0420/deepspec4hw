module top_module(
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
                    next_state = in ? 10'b0000000010 : 10'b0000000001;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            10'b0000000010: // S1
                begin
                    next_state = in ? 10'b0000000100 : 10'b0000000001;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            10'b0000000100: // S2
                begin
                    next_state = in ? 10'b0000001000 : 10'b0000000001;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            10'b0000001000: // S3
                begin
                    next_state = in ? 10'b0000010000 : 10'b0000000001;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            10'b0000100000: // S4
                begin
                    next_state = in ? 10'b0001000000 : 10'b0000000001;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            10'b0001000000: // S5
                begin
                    next_state = in ? 10'b0100000000 : 10'b0010000000;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            10'b0010000000: // S6
                begin
                    next_state = in ? 10'b0000000010 : 10'b1000000000;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            10'b0100000000: // S7
                begin
                    next_state = in ? 10'b0100000000 : 10'b0000000001;
                    out1 = 1'b0;
                    out2 = in;
                end
            10'b1000000000: // S8
                begin
                    next_state = in ? 10'b0000000010 : 10'b0000000001;
                    out1 = 1'b1;
                    out2 = 1'b0;
                end
            10'b0000000000: // S9
                begin
                    next_state = in ? 10'b0000000010 : 10'b0000000001;
                    out1 = 1'b1;
                    out2 = 1'b1;
                end
            default: // Should not happen in a correct design.  Default to S0
                begin
                    next_state = 10'b0000000001;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
        endcase
    end

endmodule