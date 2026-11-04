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
        STATE_F = 3'b101
    } state_t;

    reg [2:0] state, next_state;
    reg [1:0] y_counter;

    // State transition logic
    always @(*) begin
        next_state = state; // Default to stay in current state
        f = 0;
        case (state)
            STATE_A: begin
                f = 0;
                if (!resetn) next_state = STATE_A;
                else next_state = STATE_B;
            end
            STATE_B: begin
                f = 1; // Set f to 1 for one clock cycle after de-asserting reset
                next_state = STATE_C;
            end
            STATE_C: begin
                if (x) next_state = STATE_D;
            end
            STATE_D: begin
                if (~x) next_state = STATE_E;
            end
            STATE_E: begin
                if (x) next_state = STATE_F;
            end
            STATE_F: begin
                if ((!y) && (y_counter < 2)) next_state = STATE_F; // Stay here and check y
                else if (y_counter >= 2) next_state = STATE_A; // y did not become 1 within two clock cycles
            end
            default: next_state = STATE_A;
        endcase
    end

    // State flip-flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= STATE_A;
            y_counter <= 0;
            g <= 0;
        end else begin
            state <= next_state;
            if (state == STATE_F && next_state == STATE_F && !g) begin
                y_counter <= y_counter + 1;
            end else if (next_state != STATE_F) begin
                y_counter <= 0;
            end

            if ((state == STATE_F) && (y || (y_counter < 2))) begin
                g <= 1;
            end else if (state == STATE_A) begin
                g <= 0;
            end
        end
    end

endmodule