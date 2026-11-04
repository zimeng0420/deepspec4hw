module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    reg z;
    reg [1:0] state;

    // Define the states
    localparam S_ZERO = 2'b00;  // Initial state, seen a '0'
    localparam S_ONE = 2'b01;   // Seen the first '1'
    localparam S_REST = 2'b10;  // Processing remaining bits
    localparam S_DONE = 2'b11; // Reset is asserted, output '0'


    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_ZERO;
            z <= 0;
        end else begin
            case (state)
                S_ZERO: begin
                    if (x == 1) begin
                        state <= S_ONE;
                        z <= 1;
                    end else begin
                        state <= S_ZERO;
                        z <= 0;
                    end
                end
                S_ONE: begin
                    state <= S_REST;
                    z <= ~x;
                end
                S_REST: begin
                    state <= S_REST;
                    z <= ~x;
                end
				S_DONE: begin
					state <= S_DONE;
					z <= 0;
				end
                default: begin
                    state <= S_ZERO;
                    z <= 0;
                end
            endcase
        end
    end

endmodule