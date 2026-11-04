module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    // State Encoding
    parameter OFF = 1'b0;
    parameter ON = 1'b1;

    reg current_state, next_state;

    // State Transition Logic
    always @(*) begin
        case (current_state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Sequential Logic: State Update and Reset Handling
    always @(posedge clk) begin
        if (reset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

    // Output Logic
    always @(*) begin
        out = (current_state == ON);
    end

endmodule