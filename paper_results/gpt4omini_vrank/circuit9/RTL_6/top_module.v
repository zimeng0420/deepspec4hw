module top_module (
    input clk,
    input a,
    output reg [2:0] q
);

    initial begin
        q = 3'bxxx; // undefined state
    end

    always @(posedge clk) begin
        if (a == 1) begin
            q <= 4; // Set to 4 when a is 1
        end else begin
            case (q)
                3'd4: q <= 4; // Remain in 4
                3'd5: q <= 6; // Transition from 5 to 6
                3'd6: q <= 0; // Transition from 6 to 0
                3'd0: q <= 1; // Transition from 0 to 1
                3'd1: q <= 4; // Transition from 1 to 4
                default: q <= 3'bxxx; // Undefined case
            endcase
        end
    end

endmodule