module top_module (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

    always @(*) begin
        case (state)
            2'b00: begin // State A
                if (in == 0) begin
                    next_state = 2'b00; // A
                end else begin
                    next_state = 2'b01; // B
                end
            end
            2'b01: begin // State B
                if (in == 0) begin
                    next_state = 2'b10; // C
                end else begin
                    next_state = 2'b01; // B
                end
            end
            2'b10: begin // State C
                if (in == 0) begin
                    next_state = 2'b00; // A
                end else begin
                    next_state = 2'b11; // D
                end
            end
            2'b11: begin // State D
                if (in == 0) begin
                    next_state = 2'b10; // C
                end else begin
                    next_state = 2'b01; // B
                end
            end
            default: next_state = 2'b00; // Default state
        endcase
    end

    assign out = (state == 2'b11) ? 1 : 0; // Output is 1 when in state D, 0 otherwise

endmodule