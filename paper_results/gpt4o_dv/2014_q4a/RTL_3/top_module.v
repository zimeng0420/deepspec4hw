module top_module (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    wire Q_next;

    // Combinational logic for determining the next state of Q
    assign Q_next = L ? R : (E ? w : Q);

    // Flip-flop to store the current value
    always @(posedge clk) begin
        Q <= Q_next;
    end

endmodule