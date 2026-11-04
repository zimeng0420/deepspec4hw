module top_module (
	input clk,
	input reset,
	input w,
	output z
);

    parameter A = 3'b000,
              B = 3'b001,
              C = 3'b010,
              D = 3'b011,
              E = 3'b100,
              F = 3'b101;

    reg [2:0] state, next_state;

    // State Flip-Flops
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // State Table
    always @(*) begin
        case (state)
            A: begin
                next_state = (w) ? B : A;
            end
            B: begin
                next_state = (w) ? C : D;
            end
            C: begin
                next_state = (w) ? E : D;
            end
            D: begin
                next_state = (w) ? F : A;
            end
            E: begin
                next_state = (w) ? E : D;
            end
            F: begin
                next_state = (w) ? C : D;
            end
            default: next_state = A;
        endcase
    end

    // Output Logic
    assign z = (state == E || state == F) ? 1'b1 : 1'b0;

endmodule