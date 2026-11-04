module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // Define state encoding
    typedef enum reg [2:0] {
        STATE_A = 3'b000,
        STATE_B = 3'b001,
        STATE_C = 3'b010,
        STATE_D = 3'b011,
        STATE_E = 3'b100
    } state_t;

    state_t current_state, next_state;

    // FSM Combinational Logic
    always @(*) begin
        // Default outputs and next state
        f = 0;
        g = 0;
        next_state = current_state;

        case (current_state)
            STATE_A: begin
                if (resetn) begin
                    f = 1;
                    next_state = STATE_B;
                end
            end

            STATE_B: begin
                if (!x) next_state = STATE_C;
            end

            STATE_C: begin
                if (x) next_state = STATE_D;
            end

            STATE_D: begin
                g = 1;
                if (y) next_state = STATE_E;
                else next_state = STATE_B;
            end

            STATE_E: begin
                g = 1;
            end

            default: next_state = STATE_A;
        endcase
    end

    // FSM Sequential Logic
    always @(posedge clk) begin
        if (!resetn)
            current_state <= STATE_A;
        else
            current_state <= next_state;
    end

endmodule