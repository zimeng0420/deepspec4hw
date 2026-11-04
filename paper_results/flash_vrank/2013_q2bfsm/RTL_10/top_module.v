module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // Define states
    localparam A = 4'b0001; // Reset state
    localparam B = 4'b0010; // f = 1 for one cycle
    localparam C = 4'b0011; // Monitoring x: 1
    localparam D = 4'b0100; // Monitoring x: 1, 0
    localparam E = 4'b0101; // Monitoring x: 1, 0, 1.  g = 1 next cycle
    localparam F = 4'b0110; // g = 1, monitoring y
    localparam G = 4'b0111; // g = 1, monitoring y (one cycle after F)
    localparam H = 4'b1000; // g = 1, y seen within 2 cycles, g remains 1
    localparam I = 4'b1001; // g = 0 permanently
    localparam J = 4'b1010; // Dummy state to avoid code complexity

    reg [3:0] current_state;
    reg [3:0] next_state;
    reg f_reg;
    reg g_reg;

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

    reg f_reg_next;
    reg g_reg_next;


    // Next state logic
    always @(*) begin
        next_state = current_state;
        f_reg_next = f_reg;
        g_reg_next = g_reg;

        case (current_state)
            A: begin
                f_reg_next = 0;
                g_reg_next = 0;
                next_state = B;
            end
            B: begin
                f_reg_next = 0;
                g_reg_next = 0;
                next_state = C;
            end
            C: begin
                f_reg_next = 0;
                g_reg_next = 0;
                if (x == 1) next_state = D;
                else next_state = C;
            end
            D: begin
                f_reg_next = 0;
                g_reg_next = 0;
                if (x == 0) next_state = E;
                else next_state = C;
            end
            E: begin
                f_reg_next = 0;
                g_reg_next = 0;
                if (x == 1) next_state = F;
                else next_state = C;

            end
            F: begin
                f_reg_next = 0;
                g_reg_next = 1;
                if (y == 1) next_state = H;
                else next_state = G;
            end
            G: begin
                f_reg_next = 0;
                g_reg_next = 1;
                if (y == 1) next_state = H;
                else next_state = I;
            end
            H: begin
                f_reg_next = 0;
                g_reg_next = 1;
                next_state = H;
            end
            I: begin
                f_reg_next = 0;
                g_reg_next = 0;
                next_state = I;
            end
            default: begin
                f_reg_next = 0;
                g_reg_next = 0;
                next_state = A;
            end
        endcase
    end

    // Output logic
    assign f = (current_state == B) ? 1 : 0;
    assign g = g_reg;

endmodule