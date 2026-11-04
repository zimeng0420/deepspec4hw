module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G_HIGH = 6, G_LOW = 7;

    reg state, next_state;
    reg f_reg, g_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f_reg <= 0;
            g_reg <= 0;
        end else begin
            state <= next_state;
            f_reg <= (next_state == B) ? 1 : 0;
            g_reg <= (next_state == G_HIGH) ? 1 : (next_state == G_LOW ? 0 : g_reg);

        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                next_state = A;
                if (resetn) begin
                    next_state = B;
                end
            end
            B: begin
                next_state = C;
            end
            C: begin
                next_state = C;
                if (x == 1) begin
                    next_state = D;
                end
            end
            D: begin
                next_state = D;
                if (x == 0) begin
                    next_state = E;
                end
            end
            E: begin
                next_state = E;
                if (x == 1) begin
                    next_state = F;
                end
            end
            F: begin
                next_state = G_HIGH;
            end
            G_HIGH: begin
                next_state = G_HIGH;
                if (y == 1) begin
                    next_state = G_HIGH;
                end else begin
                  next_state = G_LOW;
                end
            end
            G_LOW: begin
                next_state = G_LOW;
            end
            default: next_state = A;
        end
    end

    assign f = f_reg;
    assign g = g_reg;

endmodule