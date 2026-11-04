module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0, ON = 1'b1;
    
    // State register
    reg current_state, next_state;

    // Synchronous state transition
    always @(posedge clk) begin
        if (reset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for state transitions and output
    always @(*) begin
        case (current_state)
            OFF: begin
                next_state = (j == 1) ? ON : OFF;
                out = 1'b0;
            end
            ON: begin
                next_state = (k == 1) ? OFF : ON;
                out = 1'b1;
            end
            default: begin
                next_state = OFF;
                out = 1'b0;
            end
        endcase
    end

endmodule