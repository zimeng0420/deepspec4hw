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
            default: next_state = B; // Ensure a known next state
        endcase
    end

    // State register update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign out = state;

endmodule