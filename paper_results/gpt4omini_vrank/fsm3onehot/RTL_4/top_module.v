module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

always @(*) begin
    case (state)
        4'b0001: // State A
            next_state = (in == 0) ? 4'b0001 : 4'b0010;
        4'b0010: // State B
            next_state = (in == 0) ? 4'b0100 : 4'b0010;
        4'b0100: // State C
            next_state = (in == 0) ? 4'b0001 : 4'b1000;
        4'b1000: // State D
            next_state = (in == 0) ? 4'b0100 : 4'b0010;
        default: 
            next_state = 4'b0001; // Default to State A
    endcase
end

assign out = (state == 4'b1000) ? 1'b1 : 1'b0;

endmodule