module top_module (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

always @(*) begin
    case (state)
        2'b00: begin // State A
            if (in == 0)
                next_state = 2'b00;
            else
                next_state = 2'b01;
        end
        2'b01: begin // State B
            if (in == 0)
                next_state = 2'b10;
            else
                next_state = 2'b01;
        end
        2'b10: begin // State C
            if (in == 0)
                next_state = 2'b00;
            else
                next_state = 2'b11;
        end
        2'b11: begin // State D
            if (in == 0)
                next_state = 2'b10;
            else
                next_state = 2'b01;
        end
        default: next_state = 2'b00;
    endcase
end

assign out = (state == 2'b11);

endmodule