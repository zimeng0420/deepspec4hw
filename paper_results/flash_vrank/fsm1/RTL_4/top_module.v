module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    reg state;
    reg next_state;

    // State definitions
    localparam A = 0;
    localparam B = 1;

    // State transition logic
    always @(*) begin
        case (state)
            A: begin
                if (in == 0) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                if (in == 0) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            default: next_state = B; // Should not happen, but good practice
        endcase
    end

    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Moore machine, output depends only on current state)
    assign out = state; // Output is the current state. Can be modified to any desired output.

endmodule