module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);

    reg [1:0] state;

    always @(posedge clock) begin
        case (state)
            2'b00: begin
                p <= 0;
                q <= 0;
                if (a) state <= 2'b01; // Transition based on a
            end
            2'b01: begin
                p <= 0;
                q <= 0;
                state <= 2'b10; // Transition
            end
            2'b10: begin
                p <= 1;
                q <= 0;
                if (a) state <= 2'b11; // Transition based on a
            end
            2'b11: begin
                if (a) begin
                    p <= 1;
                    q <= 1;
                end else begin
                    p <= 0;
                    q <= 1;
                end
                state <= 2'b00; // Reset state
            end
        endcase
    end

endmodule