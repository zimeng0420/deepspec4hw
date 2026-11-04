module top_module (
	input clk,
	input w,
	input R,
	input E,
	input L,
	output reg Q
);

    reg Q_next;

    always @(*) begin
        // Combinational logic for determining next state of Q
        Q_next = (L ? R : (E ? w : Q));
    end

    always @(posedge clk) begin
        // Update flip-flop with the evaluated next state
        Q <= Q_next;
    end

endmodule