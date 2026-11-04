module top_module (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

always @(*) begin
    // Default values
    next_state = 10'b0000000000;
    out1 = 0;
    out2 = 0;

    case (state)
        10'b0000000001: begin // S0
            next_state = in ? 10'b0000000010 : 10'b0000000001; // S0 --1--> S1, S0 --0--> S0
        end
        10'b0000000010: begin // S1
            next_state = in ? 10'b0000000100 : 10'b0000000001; // S1 --1--> S2, S1 --0--> S0
        end
        10'b0000000100: begin // S2
            next_state = in ? 10'b0000001000 : 10'b0000000001; // S2 --1--> S3, S2 --0--> S0
        end
        10'b0000001000: begin // S3
            next_state = in ? 10'b0000010000 : 10'b0000000001; // S3 --1--> S4, S3 --0--> S0
        end
        10'b0000010000: begin // S4
            next_state = in ? 10'b0000100000 : 10'b0000000001; // S4 --1--> S5, S4 --0--> S0
        end
        10'b0000100000: begin // S5
            next_state = in ? 10'b0001000000 : 10'b0000100000; // S5 --1--> S6, S5 --0--> S8
        end
        10'b0001000000: begin // S6
            next_state = in ? 10'b0010000000 : 10'b0000100000; // S6 --1--> S7, S6 --0--> S9
        end
        10'b0010000000: begin // S7
            out2 = 1; // S7 (0, 1)
            next_state = in ? 10'b0010000000 : 10'b0000000001; // S7 --1--> S7, S7 --0--> S0
        end
        10'b0100000000: begin // S8
            out1 = 1; // S8 (1, 0)
            next_state = in ? 10'b0000000010 : 10'b0000000001; // S8 --1--> S1, S8 --0--> S0
        end
        10'b1000000000: begin // S9
            out1 = 1; // S9 (1, 1)
            next_state = in ? 10'b0000000010 : 10'b0000000001; // S9 --1--> S1, S9 --0--> S0
        end
    endcase
end

endmodule