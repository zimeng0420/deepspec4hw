module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    // State encoding
    typedef enum reg [2:0] {
        state_A = 3'b000,
        state_B = 3'b001,
        state_C = 3'b010,
        state_D = 3'b011,
        state_E = 3'b100,
        state_F = 3'b101
    } state_t;
    
    state_t state, next_state;
    reg [1:0] y_counter;

    // State Register
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= state_A;
        else
            state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        // Default assignments
        next_state = state;
        f = 0;
        g = (state == state_F);

        case (state)
            state_A: begin
                f = 0;
                if (resetn)
                    next_state = state_B;
            end
            state_B: begin
                f = 1; // Assert 'f' for one cycle
                next_state = state_C;
            end
            state_C: begin
                if (x == 1)
                    next_state = state_D;
            end
            state_D: begin
                if (x == 0)
                    next_state = state_E;
            end
            state_E: begin
                if (x == 1)
                    next_state = state_F;
            end
            state_F: begin
                g = 1;
                if (y_counter == 2 & ~y)
                    next_state = state_A;
                else if (y)
                    y_counter = 0; // Reset counter if `y` becomes 1
            end
            default: next_state = state_A;
        endcase
    end

    // Y counter to track cycles after g is set to 1
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            y_counter <= 0;
        else if (state == state_F & y_counter != 2'b11)
            y_counter <= y_counter + 1;
    end

endmodule