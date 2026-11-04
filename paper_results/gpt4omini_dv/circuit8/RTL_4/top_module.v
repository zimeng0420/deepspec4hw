module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);

    reg [1:0] state; // State representation for p and q

    always @(posedge clock) begin
        case (state)
            2'b00: begin
                p <= 0;
                q <= 0;
            end
            2'b01: begin
                p <= 0;
                q <= 0;
            end
            2'b10: begin
                p <= 1;
                q <= (a) ? 0 : 1; // changes based on a
            end
            2'b11: begin
                p <= 1;
                q <= 1;
            end
        endcase
        
        if (clock == 1'b1) begin
            state <= {a, state[0]}; // Update state based on input a and previous state
        end
    end

endmodule