module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);
    reg state, next_state;

    // State definitions
    localparam OFF = 1'b0;
    localparam ON = 1'b1;

    // Combinational logic for next state
    always @(*) begin
        case (state)
            OFF: begin
                if (j) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            ON: begin
                if (k) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
        endcase
    end

    // Sequential logic for state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    always @(*) begin
        out = state;
    end
endmodule