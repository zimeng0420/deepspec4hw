module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum reg [2:0] {
        STATE_A = 3'b000,
        STATE_B = 3'b001,
        STATE_C = 3'b010,
        STATE_D = 3'b011,
        STATE_E = 3'b100,
        STATE_F = 3'b101,
        STATE_G = 3'b110
    } state_t;

    state_t current_state, next_state;
    reg [1:0] y_counter;
    
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= STATE_A;
            f <= 0;
            g <= 0;
            y_counter <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == STATE_B) f <= 1;
            else f <= 0;
            if (current_state == STATE_E || current_state == STATE_F || current_state == STATE_G) g <= 1;
            else g <= 0;
        end
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            STATE_A: begin
                if (resetn) next_state = STATE_B;
            end
            STATE_B: begin
                next_state = STATE_C;
            end
            STATE_C: begin
                if (x) next_state = STATE_D;
            end
            STATE_D: begin
                if (!x) next_state = STATE_E;
                else next_state = STATE_C;
            end
            STATE_E: begin
                if (x) next_state = STATE_F;
                else next_state = STATE_C;
            end
            STATE_F: begin
                y_counter = 0;
                if (y) next_state = STATE_G;
                else next_state = STATE_E;
            end
            STATE_G: begin
                if (!y) begin
                    y_counter = y_counter + 1;
                    if (y_counter >= 2) next_state = STATE_A;
                end
            end
            default: next_state = STATE_A;
        endcase
    end

endmodule