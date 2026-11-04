module top_module (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

    always @(*) begin
        case (state)
            2'b00: // State A
                next_state = (in == 0) ? 2'b00 : 2'b01; // A or B
            2'b01: // State B
                next_state = (in == 0) ? 2'b10 : 2'b01; // C or B
            2'b10: // State C
                next_state = (in == 0) ? 2'b00 : 2'b11; // A or D
            2'b11: // State D
                next_state = (in == 0) ? 2'b10 : 2'b01; // C or B
            default: 
                next_state = 2'b00; // Default to State A
        endcase
    end

    assign out = (state == 2'b11) ? 1 : 0; // Output logic

endmodule