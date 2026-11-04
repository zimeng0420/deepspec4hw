module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state, next_state;

    // Combinational logic for next state
    always @(*) begin
        case(state)
            A: begin
                if (r[1]) next_state = B;
                else if (r[2]) next_state = C;
                else if (r[3]) next_state = D;
                else next_state = A;
            end
            B: begin
                if (r[1]) next_state = B;
                else next_state = A;
            end
            C: begin
                if (r[2]) next_state = C;
                else next_state = A;
            end
            D: begin
                next_state = A; // State D does not hold
            end
            default: next_state = A;
        endcase
    end

    // Sequential logic for state update
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic for outputs
    always @(*) begin
        case(state)
            A: begin
                g[1] = r[1];
                g[2] = r[2] & ~r[1];
                g[3] = r[3] & ~r[1] & ~r[2];
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