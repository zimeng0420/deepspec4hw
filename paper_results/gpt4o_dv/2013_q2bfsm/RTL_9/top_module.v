module top_module(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100,
        F = 3'b101,
        G = 3'b110
    } state_t;
    
    state_t state, next_state;
    reg [1:0] y_counter;

    // State register
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        // Default outputs
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            A: begin
                if (resetn) begin
                    next_state = B;
                    f = 1;
                end
            end
            B: begin
                if (x == 1)
                    next_state = C;
            end
            C: begin
                if (x == 0)
                    next_state = D;
                else if (!resetn)
                    next_state = A;
            end
            D: begin
                if (x == 1)
                    next_state = E;
                else if (!resetn)
                    next_state = A;
            end
            E: begin
                g = 1;
                y_counter = 0;
                next_state = F;
            end
            F: begin
                g = 1;
                if (y == 1)
                    next_state = G;
                else if (y_counter == 1)
                    next_state = A;
                y_counter = y_counter + 1;
            end
            G: begin
                g = 1;
            end
            default: next_state = A;
        endcase
    end

endmodule