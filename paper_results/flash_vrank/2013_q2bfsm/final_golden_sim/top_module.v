module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // Define states
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;
    localparam G = 3'b110;
    localparam H = 3'b111;


    reg [2:0] current_state, next_state;
    reg f_reg, g_reg;

    // State transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            A: begin
                next_state = A;
                if (resetn) next_state = B;
            end
            B: begin
                next_state = C;
            end
            C: begin
                if (x == 1) next_state = D;
                else next_state = C;
            end
            D: begin
                if (x == 0) next_state = E;
                else next_state = C;
            end
            E: begin
                if (x == 1) next_state = F;
                else next_state = C;
            end
            F: begin
                next_state = G;
            end
            G: begin
                if (y == 1) next_state = H;
                else next_state = G;
            end
            H: begin
               next_state = H;
            end
            default: next_state = A;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (!resetn) begin
            f_reg <= 0;
            g_reg <= 0;
        end else begin
            case (current_state)
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
                    g_reg <= 0;
                end
                G: begin
                    f_reg <= 0;
                    g_reg <= 1;
                end
                H: begin
                    f_reg <= 0;
                    g_reg <= 1;
                end
                default: begin
                    f_reg <= 0;
                    g_reg <= 0;
                end
            endcase
        end
    end

    assign f = f_reg;
    assign g = g_reg;

    always @(posedge clk) begin
        if(!resetn) begin
            g_reg <= 0;
        end
        else if(current_state == F) begin
            g_reg <= 1;
        end
        else if (current_state == G) begin
            g_reg <= 1;
            if(y == 0)
                next_state <= (g_reg) ? G : next_state;
            else
                next_state <= H;
        end
        else if (current_state == H) begin
            g_reg <= 1;
        end
        else begin
            g_reg <= 0;
        end
    end


endmodule