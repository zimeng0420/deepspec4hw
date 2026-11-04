module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state, next_state;

    // State transition logic
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
                next_state = A;
            end
            default: next_state = A;
        endcase
    end

    // State registers
    always @(posedge clk) begin
        if (~resetn) 
            state <= A;
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        case(state)
            A: begin
                g[1] = r[1];
                g[2] = r[2] & ~r[1];
                g[3] = r[3] & ~r[1] & ~r[2];
            end
            B: begin
                g[1] = 1'b1;
                g[2] = 1'b0;
                g[3] = 1'b0;
            end
            C: begin
                g[1] = 1'b0;
                g[2] = 1'b1;
                g[3] = 1'b0;
            end
            D: begin
                g[1] = 1'b0;
                g[2] = 1'b0;
                g[3] = 1'b1;
            end
            default: begin
                g = 3'b000;
            end
        endcase
    end

endmodule