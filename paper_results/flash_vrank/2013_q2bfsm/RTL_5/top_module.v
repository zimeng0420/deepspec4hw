module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // Define states
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0011;
    localparam D = 4'b0100;
    localparam E = 4'b0101;
    localparam F = 4'b0110;
    localparam G = 4'b0111;
    localparam H = 4'b1000;
    localparam I = 4'b1001;

    reg [3:0] current_state, next_state;
    reg f_reg, g_reg;

    // State register update
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
            f_reg <= 0;
            g_reg <= 0;
        end else begin
            current_state <= next_state;
            f_reg <= f_reg_next;
            g_reg <= g_reg_next;
        end
    end

    reg f_reg_next, g_reg_next;

    // Next state and output logic
    always @(*) begin
        next_state = current_state;
        f_reg_next = f_reg;
        g_reg_next = g_reg;

        case (current_state)
            A: begin
                f_reg_next = 0;
                g_reg_next = 0;
                if (!resetn) begin
                    next_state = A;
                end else begin
                    next_state = B;
                    f_reg_next = 1;
                end
            end
            B: begin
                f_reg_next = 0;
                g_reg_next = 0;
                next_state = C;
            end
            C: begin
                f_reg_next = 0;
                g_reg_next = 0;
                if (x == 1) begin
                    next_state = D;
                end else begin
                    next_state = C;
                end
            end
            D: begin
                f_reg_next = 0;
                g_reg_next = 0;
                if (x == 0) begin
                    next_state = E;
                end else begin
                    next_state = C;
                end
            end
            E: begin
                f_reg_next = 0;
                g_reg_next = 0;
                if (x == 1) begin
                    next_state = F;
                end else begin
                    next_state = C;
                end
            end
            F: begin
                f_reg_next = 0;
                g_reg_next = 1;
                next_state = G;
            end
            G: begin
                f_reg_next = 0;
                g_reg_next = 1;
                if (y == 1) begin
                    next_state = H;
                end else begin
                    next_state = I;
                end
            end
            H: begin
               f_reg_next = 0;
               g_reg_next = 1;
               next_state = H;
            end
            I: begin
                f_reg_next = 0;
                g_reg_next = 0;
                if (y == 1) begin
                   next_state = H;
                end else begin
                   next_state = G;
                end
            end
            default: begin
                next_state = A;
                f_reg_next = 0;
                g_reg_next = 0;
            end
        endcase
        if (!resetn) begin
            next_state = A;
            f_reg_next = 0;
            g_reg_next = 0;
        end
    end

    assign f = f_reg;
    assign g = g_reg;

endmodule