module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum reg [1:0] {
        STATE_A = 2'b00,
        STATE_1 = 2'b01,
        STATE_0 = 2'b10,
        STATE_1_COMPLETE = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg [1:0] count_y;

    // Sequential Logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= STATE_A;
            f <= 0;
            g <= 0;
            count_y <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == STATE_A) begin
                f <= 1; // Set f for one clock cycle
            end
        end
    end

    // Combinational Logic for state transitions and outputs
    always @* begin
        next_state = current_state;
        g = 0; // Default g to 0

        case (current_state)
            STATE_A: begin
                if (f == 1) begin
                    next_state = STATE_1; // Move to STATE_1 after f is set
                end
            end
            STATE_1: begin
                if (x) begin
                    next_state = STATE_0; // Move to STATE_0 if x = 1
                end
            end
            STATE_0: begin
                if (!x) begin
                    next_state = STATE_1_COMPLETE; // Move to STATE_1_COMPLETE if x = 0
                end
            end
            STATE_1_COMPLETE: begin
                g = 1; // Set g to 1 after detecting the sequence 1, 0, 1
                if (y) begin
                    g = 1; // Maintain g = 1 if y = 1 within 2 cycles
                end else if (count_y < 2) begin
                    count_y = count_y + 1; // Increment y counter
                end else begin
                    g = 0; // Set g = 0 if y never reached 1
                end
            end
        endcase
    end

endmodule