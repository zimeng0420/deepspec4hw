module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output [3:1] g
);

    // State definition
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State variable
    reg [1:0] current_state, next_state;

    // State flip-flops (sequential always block)
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // State table (combinational always block)
    always @(*) begin
        case (current_state)
            A: begin
                if (r[1]) begin
                    next_state <= B;
                end else if (r[2]) begin
                    next_state <= C;
                end else if (r[3]) begin
                    next_state <= D;
                end else begin
                    next_state <= A;
                end
            end
            B: begin
                if (r[1]) begin
                    next_state <= B;
                end else begin
                    next_state <= A;
                end
            end
            C: begin
                if (r[2]) begin
                    next_state <= C;
                end else begin
                    next_state <= A;
                end
            end
            D: begin
              next_state <= A;
            end
            default: next_state <= A;
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            A: begin
                g[1] = 0;
                g[2] = 0;
                g[3] = 0;
            end
            B: begin
                g[1] = 1;
                g[2] = 0;
                g[3] = 0;
            end
            C: begin
                g[1] = 0;
                g[2] = 1;
                g[3] = 0;
            end
            D: begin
              g[1] = 0;
              g[2] = 0;
              g[3] = 1;
            end
            default: begin
                g[1] = 0;
                g[2] = 0;
                g[3] = 0;
            end
        endcase
    end

endmodule