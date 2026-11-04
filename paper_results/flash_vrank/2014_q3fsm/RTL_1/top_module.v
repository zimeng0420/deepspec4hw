module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    reg [2:0] state;
    reg [1:0] count; // Counter for w=1 within a 3-cycle window

    // State definitions
    localparam A = 3'b000; // Reset state
    localparam B = 3'b001; // Initial state after s=1
    localparam C = 3'b010; // Counting w=1 (first cycle)
    localparam D = 3'b011; // Counting w=1 (second cycle)
    localparam E = 3'b100; // Counting w=1 (third cycle)
	 localparam F = 3'b101; // Output z=1 state (one clock cycle)


    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            count <= 0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        z <= 0;
                        count <= 0;
                    end else begin
                        state <= A;
                        z <= 0;
                        count <= 0;
                    end
                end
                B: begin
                    state <= C;
                    z <= 0;
                    count <= (w == 1) ? 1 : 0;
                end
                C: begin
                    state <= D;
                    z <= 0;
                    count <= count + ((w == 1) ? 1 : 0);
                end
                D: begin
                    state <= E;
                    z <= 0;
                    count <= count + ((w == 1) ? 1 : 0);
                end
                E: begin
                    if (count == 2) begin
                        state <= F;
                        z <= 0;
                    end else begin
                        state <= B;
                        z <= 0;
                    end
					   count <= 0;
                end
				  F: begin
					   state <= B;
					   z <= 1;
				  end
                default: begin
                    state <= A;
                    z <= 0;
                    count <= 0;
                end
            endcase
        end
    end

endmodule