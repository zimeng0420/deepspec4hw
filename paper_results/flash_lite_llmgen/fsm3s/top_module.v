module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    // State Encoding
    parameter STATE_A = 2'b00;
    parameter STATE_B = 2'b01;
    parameter STATE_C = 2'b10;
    parameter STATE_D = 2'b11;

    // State Register
    reg [1:0] current_state;

    // Output Signal
    reg out;

    // Next State Logic (Combinational)
    always @(*) begin
        case (current_state)
            STATE_A:  begin
                if (in)
                    current_state = STATE_B;
                else
                    current_state = STATE_A;
            end
            STATE_B:  begin
                if (in)
                    current_state = STATE_B;
                else
                    current_state = STATE_C;
            end
            STATE_C:  begin
                if (in)
                    current_state = STATE_D;
                else
                    current_state = STATE_A;
            end
            STATE_D:  begin
                if (in)
                    current_state = STATE_B;
                else
                    current_state = STATE_C;
            end
            default:  current_state = STATE_A; // Default to A for safety
        endcase
    end

    // Output Logic (Combinational)
    always @(*) begin
        case (current_state)
            STATE_A:  out = 1'b0;
            STATE_B:  out = 1'b0;
            STATE_C:  out = 1'b0;
            STATE_D:  out = 1'b1;
            default:  out = 1'b0; // Default output
        endcase
    end

    // State Register Update (Synchronous with Reset)
    always @(posedge clk) begin
        if (reset)
            current_state <= STATE_A; // Reset to state A
        else
            current_state <= current_state; // Update state
    end

endmodule