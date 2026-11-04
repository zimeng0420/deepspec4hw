module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);
    typedef enum logic [1:0] {
        DISCARD = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset)
            current_state <= DISCARD;
        else
            current_state <= next_state;
    end

    always_comb begin
        done = 1'b0;  // Default value for done
        case (current_state)
            DISCARD: begin
                if (in[3] == 1'b1)
                    next_state = BYTE1;
                else
                    next_state = DISCARD;
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                done = 1'b1;  // Signal done in the cycle after the third byte
                next_state = DISCARD;
            end
            default: next_state = DISCARD; // Default state fallback
        endcase
    end
endmodule