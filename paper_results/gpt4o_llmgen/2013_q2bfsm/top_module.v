module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum {A, B, C, D, E, F, G} state_t;
    state_t state, next_state;

    reg [1:0] x_seq; // To check for x sequence 1, 0, 1
    reg [1:0] y_wait; // To count the y monitoring cycles

    // State transition on clock edge
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            x_seq <= 2'b00;
            y_wait <= 2'b00;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (!resetn)
                    next_state = A;
                else
                    next_state = B;
            end
            B: begin
                next_state = C;
            end
            C: begin
                if (x_seq == 2'b01 && x == 1)
                    next_state = D;
                else
                    next_state = C;
            end
            D: begin
                next_state = E;
            end
            E: begin
                if (y == 1)
                    next_state = F;
                else if (y_wait == 2'b01)
                    next_state = G;
                else
                    next_state = E;
            end
            F: begin
                next_state = F;
            end
            G: begin
                next_state = G;
            end
            default: next_state = A;
        endcase
    end

    // Outputs and other sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            f <= 0;
            g <= 0;
            x_seq <= 2'b00;
            y_wait <= 2'b00;
        end else begin
            case (state)
                A: begin
                    f <= 0;
                    g <= 0;
                end
                B: begin
                    f <= 1;
                end
                C: begin
                    f <= 0;
                    x_seq <= {x_seq[0], x};
                    g <= 0;
                end
                D: begin
                    g <= 1;
                end
                E: begin
                    if (g == 1) y_wait <= y_wait + 1;
                end
                F: begin
                    g <= 1;
                end
                G: begin
                    g <= 0;
                end
            endcase
        end
    end

endmodule