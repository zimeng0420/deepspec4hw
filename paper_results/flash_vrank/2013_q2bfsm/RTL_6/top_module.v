module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // Define the states
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0011;
    localparam D = 4'b0100;
    localparam E = 4'b0101;
    localparam F = 4'b0110;
    localparam G = 4'b0111;
    localparam H = 4'b1000;
    localparam I = 4'b1001;
    localparam J = 4'b1010;

    reg [3:0] current_state;
    reg [3:0] next_state;
    reg f_reg;
    reg g_reg;

    assign f = f_reg;
    assign g = g_reg;

    // State transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
            f_reg <= 0;
            g_reg <= 0;
        end else begin
            current_state <= next_state;
            f_reg <= f_next;
            g_reg <= g_next;
        end
    end

    reg f_next;
    reg g_next;

    // Next state and output logic
    always @(*) begin
        f_next = f_reg;
        g_next = g_reg;

        case (current_state)
            A: begin
                f_next = 0;
                g_next = 0;
                next_state = B;
                if (!resetn) begin
                    next_state = A;
                    f_next = 0;
                    g_next = 0;
                end
            end
            B: begin
                f_next = 1;
                g_next = 0;
                next_state = C;
            end
            C: begin
                f_next = 0;
                g_next = 0;
                next_state = D;
            end
            D: begin
                f_next = 0;
                g_next = 0;
                if (x == 1) begin
                    next_state = E;
                end else begin
                    next_state = D;
                end
            end
            E: begin
                f_next = 0;
                g_next = 0;
                if (x == 0) begin
                    next_state = F;
                end else begin
                    next_state = D;
                end
            end
            F: begin
                f_next = 0;
                g_next = 0;
                if (x == 1) begin
                    next_state = G;
                end else begin
                    next_state = D;
                end
            end
            G: begin
                f_next = 0;
                g_next = 1;
                next_state = H;
            end
            H: begin
                f_next = 0;
                g_next = 1;
                if (y == 1) begin
                    next_state = I;
                end else begin
                   next_state = J;
                end
            end
            I: begin
                f_next = 0;
                g_next = 1;
                next_state = I;
            end
            J: begin
                f_next = 0;
                g_next = 1;
                if(y == 1) begin
                    next_state = I;
                end else begin
                    next_state = A;
                    g_next = 0;
                end

            end
            default: begin
                f_next = 0;
                g_next = 0;
                next_state = A;
            end
        endcase
    end

endmodule