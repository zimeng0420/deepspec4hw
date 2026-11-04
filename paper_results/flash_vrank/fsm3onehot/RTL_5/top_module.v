module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        case (state)
            4'b0001: begin // State A
                if (in == 0) begin
                    next_state = 4'b0001; // Next state A
                end else begin
                    next_state = 4'b0010; // Next state B
                end
            end
            4'b0010: begin // State B
                if (in == 0) begin
                    next_state = 4'b0100; // Next state C
                end else begin
                    next_state = 4'b0010; // Next state B
                end
            end
            4'b0100: begin // State C
                if (in == 0) begin
                    next_state = 4'b0001; // Next state A
                end else begin
                    next_state = 4'b1000; // Next state D
                end
            end
            4'b1000: begin // State D
                if (in == 0) begin
                    next_state = 4'b0100; // Next state C
                end else begin
                    next_state = 4'b0010; // Next state B
                end
            end
            default: next_state = 4'bxxxx;
        endcase
    end

    assign out = (state == 4'b1000); // Output is 1 when in state D, 0 otherwise

endmodule