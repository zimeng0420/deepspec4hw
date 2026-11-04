module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

    always @(*) begin
        // Default assignments
        next_state = 4'b0000;
        out = 1'b0;

        case (state)
            4'b0001: // State A
                if (in) begin
                    next_state = 4'b0010; // Go to B
                end else begin
                    next_state = 4'b0001; // Stay in A
                end
            4'b0010: // State B
                if (in) begin
                    next_state = 4'b0010; // Stay in B
                end else begin
                    next_state = 4'b0100; // Go to C
                end
            4'b0100: // State C
                if (in) begin
                    next_state = 4'b1000; // Go to D
                end else begin
                    next_state = 4'b0001; // Go to A
                end
            4'b1000: // State D
                if (in) begin
                    next_state = 4'b0010; // Go to B
                end else begin
                    next_state = 4'b0100; // Go to C
                end
        endcase

        // Output logic for state D
        if (state == 4'b1000) begin
            out = 1'b1; // Output = 1 in state D
        end
    end

endmodule