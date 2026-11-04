module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output out
);

    // State Definition
    parameter OFF = 0;
    parameter ON  = 1;

    // State Register
    reg [0:0] state;

    // Output Logic
    assign out = state;

    // Next State Logic and State Update
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: begin
                    if (j) begin
                        state <= ON;
                    end else begin
                        state <= OFF;
                    end
                end
                ON: begin
                    if (k) begin
                        state <= OFF;
                    end else begin
                        state <= ON;
                    end
                end
            endcase
        end
    end

endmodule