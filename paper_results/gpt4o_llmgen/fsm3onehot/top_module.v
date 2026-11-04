module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

    // State transition logic
    always @(*) begin
        case (state)
            4'b0001: // State A
                if (in == 1'b0)
                    next_state = 4'b0001; // A
                else
                    next_state = 4'b0010; // B

            4'b0010: // State B
                if (in == 1'b0)
                    next_state = 4'b0100; // C
                else
                    next_state = 4'b0010; // B

            4'b0100: // State C
                if (in == 1'b0)
                    next_state = 4'b0001; // A
                else
                    next_state = 4'b1000; // D

            4'b1000: // State D
                if (in == 1'b0)
                    next_state = 4'b0100; // C
                else
                    next_state = 4'b0010; // B

            default:
                next_state = 4'b0001; // Default case: A
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            4'b0001: out = 1'b0; // State A
            4'b0010: out = 1'b0; // State B
            4'b0100: out = 1'b0; // State C
            4'b1000: out = 1'b1; // State D
            default: out = 1'b0; // Default case: 0
        endcase
    end

endmodule