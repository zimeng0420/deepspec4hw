module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);
    // State encoding
    parameter OFF = 1'b0, ON = 1'b1;
    reg current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            OFF: begin
                if (j) next_state = ON;
                else next_state = OFF;
            end
            ON: begin
                if (k) next_state = OFF;
                else next_state = ON;
            end
            default: next_state = OFF; // Default state
        endcase
    end

    // State update on clock edge
    always @(posedge clk) begin
        if (reset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    always @(current_state) begin
        out = (current_state == ON) ? 1'b1 : 1'b0;
    end
endmodule