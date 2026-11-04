module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding using one-hot encoding or binary encoding
    typedef enum reg [2:0] {
        STATE_A = 3'b000,
        STATE_B = 3'b001,
        STATE_C = 3'b010,
        STATE_D = 3'b011,
        STATE_E = 3'b100,
        STATE_F = 3'b101
    } state_t;

    state_t current_state, next_state;

    // State flip-flops
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    // State transition table
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (w) begin
                    next_state = STATE_B;
                end else begin
                    next_state = STATE_A;
                end
            end
            STATE_B: begin
                if (w) begin
                    next_state = STATE_C;
                end else begin
                    next_state = STATE_D;
                end
            end
            STATE_C: begin
                if (w) begin
                    next_state = STATE_E;
                end else begin
                    next_state = STATE_D;
                end
            end
            STATE_D: begin
                if (w) begin
                    next_state = STATE_F;
                end else begin
                    next_state = STATE_A;
                end
            end
            STATE_E: begin
                if (w) begin
                    next_state = STATE_E;
                end else begin
                    next_state = STATE_D;
                end
            end
            STATE_F: begin
                if (w) begin
                    next_state = STATE_C;
                end else begin
                    next_state = STATE_D;
                end
            end
            default: begin
                next_state = STATE_A;
            end
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            STATE_E, STATE_F: z = 1;
            default: z = 0;
        endcase
    end

endmodule