module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

// Combinational logic for next state generation
always @(*) begin
    case (state)
        4'b0001: // State A
            next_state = (in) ? 4'b0010 : 4'b0001; // A or B
        4'b0010: // State B
            next_state = (in) ? 4'b0010 : 4'b0100; // B or C
        4'b0100: // State C
            next_state = (in) ? 4'b1000 : 4'b0001; // D or A
        4'b1000: // State D
            next_state = (in) ? 4'b0100 : 4'b0010; // C or B
        default: 
            next_state = 4'b0001; // Default to state A
    endcase
end

// Output logic based on the current state
assign out = (state == 4'b1000) ? 1'b1 : 1'b0; // Output is high only in State D

endmodule