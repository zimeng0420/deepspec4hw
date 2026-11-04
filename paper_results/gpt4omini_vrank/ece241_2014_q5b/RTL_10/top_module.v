module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding using one-hot encoding
    reg [1:0] state; // 2 states: A and B

    localparam A = 2'b01;
    localparam B = 2'b10;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A; // Reset to state A
        end else begin
            case (state)
                A: begin
                    if (x) begin
                        state <= B; // Transition to state B on x=1
                        z <= 1;     // Output z=1 when transitioning to B
                    end else begin
                        state <= A; // Stay in state A on x=0
                        z <= 0;     // Output z=0
                    end
                end
                B: begin
                    if (x) begin
                        state <= B; // Stay in state B on x=1
                        z <= 0;     // Output z=0
                    end else begin
                        state <= B; // Stay in state B on x=0
                        z <= 1;     // Output z=1
                    end
                end
            endcase
        end
    end

endmodule