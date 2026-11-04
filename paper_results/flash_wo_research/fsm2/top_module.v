module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output out
);

    reg current_state;
    reg next_state;

    // State definitions
    localparam OFF = 0;
    localparam ON  = 1;

    // Output logic (Moore machine)
    assign out = current_state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            OFF: begin
                if (j == 0) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
            ON: begin
                if (k == 0) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            default: next_state = OFF; // Should not happen, but good practice
        endcase
    end

endmodule