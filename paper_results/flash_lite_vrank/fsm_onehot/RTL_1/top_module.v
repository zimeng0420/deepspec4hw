module top_module (
	input in,
	input [9:0] state,
	output [9:0] next_state,
	output out1,
	output out2);

    // State transition logic
    always @(*) begin
        case (1'b1)
            1'b1: begin
                if (state[0]) begin // S0
                    next_state[0] = ~in;
                    next_state[1] = in;
                    next_state[2] = 1'b0;
                    next_state[3] = 1'b0;
                    next_state[4] = 1'b0;
                    next_state[5] = 1'b0;
                    next_state[6] = 1'b0;
                    next_state[7] = 1'b0;
                    next_state[8] = 1'b0;
                    next_state[9] = 1'b0;
                end
                if (state[1]) begin // S1
                    next_state[0] = ~in;
                    next_state[1] = 1'b0;
                    next_state[2] = in;
                    next_state[3] = 1'b0;
                    next_state[4] = 1'b0;
                    next_state[5] = 1'b0;
                    next_state[6] = 1'b0;
                    next_state[7] = 1'b0;
                    next_state[8] = 1'b0;
                    next_state[9] = 1'b0;
                end
                if (state[2]) begin // S2
                    next_state[0] = ~in;
                    next_state[1] = 1'b0;
                    next_state[2] = 1'b0;
                    next_state[3] = in;
                    next_state[4] = 1'b0;
                    next_state[5] = 1'b0;
                    next_state[6] = 1'b0;
                    next_state[7] = 1'b0;
                    next_state[8] = 1'b0;
                    next_state[9] = 1'b0;
                end
                if (state[3]) begin // S3
                    next_state[0] = ~in;
                    next_state[1] = 1'b0;
                    next_state[2] = 1'b0;
                    next_state[3] = 1'b0;
                    next_state[4] = in;
                    next_state[5] = 1'b0;
                    next_state[6] = 1'b0;
                    next_state[7] = 1'b0;
                    next_state[8] = 1'b0;
                    next_state[9] = 1'b0;
                end
                if (state[4]) begin // S4
                    next_state[0] = ~in;
                    next_state[1] = 1'b0;
                    next_state[2] = 1'b0;
                    next_state[3] = 1'b0;
                    next_state[4] = 1'b0;
                    next_state[5] = in;
                    next_state[6] = 1'b0;
                    next_state[7] = 1'b0;
                    next_state[8] = 1'b0;
                    next_state[9] = 1'b0;
                end
                if (state[5]) begin // S5
                    next_state[0] = ~in;
                    next_state[1] = in;
                    next_state[2] = 1'b0;
                    next_state[3] = 1'b0;
                    next_state[4] = 1'b0;
                    next_state[5] = 1'b0;
                    next_state[6] = in;
                    next_state[7] = 1'b0;
                    next_state[8] = 1'b0;
                    next_state[9] = 1'b0;
                end
                if (state[6]) begin // S6
                    next_state[0] = ~in;
                    next_state[1] = in;
                    next_state[2] = 1'b0;
                    next_state[3] = 1'b0;
                    next_state[4] = 1'b0;
                    next_state[5] = 1'b0;
                    next_state[6] = 1'b0;
                    next_state[7] = in;
                    next_state[8] = 1'b0;
                    next_state[9] = 1'b0;
                end
                if (state[7]) begin // S7
                    next_state[0] = ~in;
                    next_state[1] = in;
                    next_state[2] = 1'b0;
                    next_state[3] = 1'b0;
                    next_state[4] = 1'b0;
                    next_state[5] = 1'b0;
                    next_state[6] = 1'b0;
                    next_state[7] = in;
                    next_state[8] = 1'b0;
                    next_state[9] = 1'b0;
                end
                if (state[8]) begin // S8
                    next_state[0] = ~in;
                    next_state[1] = in;
                    next_state[2] = 1'b0;
                    next_state[3] = 1'b0;
                    next_state[4] = 1'b0;
                    next_state[5] = 1'b0;
                    next_state[6] = 1'b0;
                    next_state[7] = 1'b0;
                    next_state[8] = 1'b0;
                    next_state[9] = 1'b0;
                end
                if (state[9]) begin // S9
                    next_state[0] = ~in;
                    next_state[1] = in;
                    next_state[2] = 1'b0;
                    next_state[3] = 1'b0;
                    next_state[4] = 1'b0;
                    next_state[5] = 1'b0;
                    next_state[6] = 1'b0;
                    next_state[7] = 1'b0;
                    next_state[8] = 1'b0;
                    next_state[9] = 1'b0;
                end
                default: begin
                    next_state[0] = 1'b0;
                    next_state[1] = 1'b0;
                    next_state[2] = 1'b0;
                    next_state[3] = 1'b0;
                    next_state[4] = 1'b0;
                    next_state[5] = 1'b0;
                    next_state[6] = 1'b0;
                    next_state[7] = 1'b0;
                    next_state[8] = 1'b0;
                    next_state[9] = 1'b0;
                end
            endcase
    end

    // Output logic
    always @(*) begin
        out1 = 1'b0;
        out2 = 1'b0;
        if (state[7]) begin // S7
            out2 = 1'b1;
        end
        if (state[8]) begin // S8
            out1 = 1'b1;
        end
        if (state[9]) begin // S9
            out1 = 1'b1;
            out2 = 1'b1;
        end
    end

endmodule