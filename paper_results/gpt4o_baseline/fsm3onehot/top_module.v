module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // State transition logic
    always @(*) begin
        case (state)
            4'b0001: next_state = (in == 1'b0) ? 4'b0001 : 4'b0010; // A
            4'b0010: next_state = (in == 1'b0) ? 4'b0100 : 4'b0010; // B
            4'b0100: next_state = (in == 1'b0) ? 4'b0001 : 4'b1000; // C
            4'b1000: next_state = (in == 1'b0) ? 4'b0100 : 4'b0010; // D
            default: next_state = 4'b0001; // Default: Reset to state A
        endcase
    end

    // Output logic
    assign out = (state == 4'b1000) ? 1'b1 : 1'b0; // Output is 1 only in state D

endmodule