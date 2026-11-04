module top_module(
    input clk,
    input resetn,
    input [1:3] r,
    output reg [1:3] g
);

    // State Definition
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State Register
    reg [1:0] state, next_state;

    // State Table (Combinational Logic for Next State)
    always @(*) begin
        next_state = state; // Default: Stay in the current state

        case (state)
            A: begin
                if (r[1])
                    next_state = B;
                else if (r[2])
                    next_state = C;
                else if (r[3])
                    next_state = D;
                else
                    next_state = A;
            end
            B: begin
                if (r[1])
                    next_state = B;
                else
                    next_state = A;
            end
            C: begin
                if (r[2])
                    next_state = C;
                else
                    next_state = A;
            end
            D: begin
                if (r[3])
                    next_state = D;
                else
                    next_state = A;
            end
        endcase
    end

    // State Flip-Flops (Sequential Logic)
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Output Logic (Combinational Logic for Outputs)
    always @(*) begin
        g = 3'b000; // Default: No grants
        case (state)
            A: begin
                if (r[1])
                    g[1] = 1;
                else if (r[2])
                    g[2] = 1;
                else if (r[3])
                    g[3] = 1;
            end
            B: begin
                g[1] = r[1];
            end
            C: begin
                g[2] = r[2];
            end
            D: begin
                g[3] = r[3];
            end
        endcase
    end

endmodule