module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output [3:1] g
);

    // State Definitions
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State Register
    reg [1:0] state, next_state;

    // Output Assignments
    always @(*) begin
        case (state)
            A: begin
                if (r[1]) g[1] = 1;
                else if (r[2]) g[2] = 1;
                else if (r[3]) g[3] = 1;
                else g[1] = 0; g[2] = 0; g[3] = 0;
            end
            B: begin
                g[1] = r[1];
                g[2] = 0; g[3] = 0;
            end
            C: begin
                g[2] = r[2];
                g[1] = 0; g[3] = 0;
            end
            D: begin
                g[3] = r[3];
                g[1] = 0; g[2] = 0;
            end
            default: begin
                g[1] = 0; g[2] = 0; g[3] = 0;
            end
        endcase
    end

    // State Table (Next State Logic)
    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                if (r[1]) next_state = B;
                else if (r[2]) next_state = C;
                else if (r[3]) next_state = D;
                else next_state = A;
            end
            B: begin
                if (!r[1]) next_state = A;
                else next_state = B;
            end
            C: begin
                if (!r[2]) next_state = A;
                else next_state = C;
            end
            D: begin
                if (!r[3]) next_state = A;
                else next_state = D;
            end
            default: next_state = A;
        endcase
    end

    // State Flip-Flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

endmodule