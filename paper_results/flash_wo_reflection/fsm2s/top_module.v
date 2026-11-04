module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output out
);

    // Define the states
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // State register
    reg current_state;

    // Next state logic
    reg next_state;

    // Output logic
    assign out = current_state;

    // State transition logic (sequential)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (current_state)
            OFF: begin
                if (j == 1) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            ON: begin
                if (k == 1) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
            default: next_state = OFF; // Should not happen, but good practice
        endcase
    end

endmodule