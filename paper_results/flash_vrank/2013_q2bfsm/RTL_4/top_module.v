module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // Define the states of the FSM
    typedef enum logic [3:0] {
        A,      // Reset state
        B,      // f = 1 for one cycle
        C,      // Monitoring x: first 1
        D,      // Monitoring x: 0 after 1
        E,      // Monitoring x: second 1 after 1, 0
        F,      // g = 1, monitoring y
        G,      // g = 1 permanently
        H       // g = 0 permanently
    } state_t;

    // State register
    reg state, next_state;

    // Output registers
    reg f_reg, g_reg;

    // Temporary registers for x sequence detection
    reg x_d1, x_d2;

    // Temporary registers for y sequence detection
    reg y_d1;
    
    //assign f = f_reg;
    //assign g = g_reg;

    // State transition logic
    always_comb begin
        next_state = state;
        case (state)
            A: begin
                if (!resetn) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            B: begin
                next_state = C;
            end
            C: begin
                if (x) begin
                    next_state = D;
                end else begin
                    next_state = C;
                end
            end
            D: begin
                if (!x) begin
                    next_state = E;
                end else begin
                    next_state = C;
                end
            end
            E: begin
                if (x) begin
                    next_state = F;
                end else begin
                    next_state = C;
                end
            end
            F: begin
                if (y) begin
                    next_state = G;
                end else begin
                  if (y_d1) begin
                    next_state = G;
                  end else begin
                    next_state = H;
                  end
                end
            end
            G: begin
                next_state = G;
            end
            H: begin
                next_state = H;
            end
            default: begin
                next_state = A;
            end
        endcase
    end

    // State and data register update
    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f_reg <= 0;
            g_reg <= 0;
            x_d1 <= 0;
            x_d2 <= 0;
            y_d1 <= 0;
        end else begin
            state <= next_state;
            x_d2 <= x_d1;
            x_d1 <= x;
            y_d1 <= y;

            case (next_state)
                A: begin
                    f_reg <= 0;
                    g_reg <= 0;
                end
                B: begin
                    f_reg <= 1;
                    g_reg <= 0;
                end
                C: begin
                    f_reg <= 0;
                    g_reg <= 0;
                end
                D: begin
                    f_reg <= 0;
                    g_reg <= 0;
                end
                E: begin
                    f_reg <= 0;
                    g_reg <= 0;
                end
                F: begin
                    f_reg <= 0;
                    g_reg <= 1;
                end
                G: begin
                    f_reg <= 0;
                    g_reg <= 1;
                end
                H: begin
                    f_reg <= 0;
                    g_reg <= 0;
                end
                default: begin
                    f_reg <= 0;
                    g_reg <= 0;
                end
            end
        end
    end
    
    assign f = f_reg;
    assign g = g_reg;
endmodule