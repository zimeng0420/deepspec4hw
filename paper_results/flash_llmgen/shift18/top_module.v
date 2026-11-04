module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            case (amount)
                2'b00: begin // Shift Left by 1
                    q <= {q[62:0], 1'b0};
                end
                2'b01: begin // Shift Left by 8
                    q <= {q[55:0], 8'b0};
                end
                2'b10: begin // Shift Right by 1 (Arithmetic)
                    q <= {q[63], q[63:1]};
                end
                2'b11: begin // Shift Right by 8 (Arithmetic)
                    q <= { {8{q[63]}}, q[63:8] };
                end
                default: begin
                    // Should not happen, but good practice to handle default case
                    // Optionally, keep the current value:
                    // q <= q;
                end
            endcase
        end
        // else, if neither load nor ena are asserted, retain the current value.
    end

endmodule