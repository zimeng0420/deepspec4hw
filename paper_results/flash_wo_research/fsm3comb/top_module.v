module top_module (
	input in,
	input [1:0] state,
	output reg [1:0] next_state,
	output out
);

always @(*) begin
    case (state)
        2'b00: begin // A
            if (in == 0) begin
                next_state = 2'b00; // A
            end else begin
                next_state = 2'b01; // B
            end
        end
        2'b01: begin // B
            if (in == 0) begin
                next_state = 2'b10; // C
            end else begin
                next_state = 2'b01; // B
            end
        end
        2'b10: begin // C
            if (in == 0) begin
                next_state = 2'b00; // A
            end else begin
                next_state = 2'b11; // D
            end
        end
        2'b11: begin // D
            if (in == 0) begin
                next_state = 2'b10; // C
            end else begin
                next_state = 2'b01; // B
            end
        end
        default: next_state = 2'b00; // Should not happen, but good practice
    endcase
end

assign out = (state == 2'b11); // D

endmodule