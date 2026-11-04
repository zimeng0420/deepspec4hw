module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);
    // State encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t state, next_state;

    // State Flip-Flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        case (state)
            A: begin
                if (r[1]) next_state = B;
                else if (r[2]) next_state = C;
                else if (r[3]) next_state = D;
                else next_state = A;
            end
            B: begin
                if (r[1]) next_state = B; // grant remains
                else next_state = A; // go back to A if r1 = 0
            end
            C: begin
                if (r[2]) next_state = C; // grant remains
                else next_state = A; // go back to A if r2 = 0
            end
            D: begin
                next_state = A; // go back to A from D
            end
            default: next_state = A;
        endcase
    end

    // Output Logic
    always @(*) begin
        g = 3'b000; // default output
        case (state)
            B: g[1] = 1'b1; // grant device 1
            C: g[2] = 1'b1; // grant device 2
            // No grant for device 3 as per priority logic in state A
            default: g[3] = 1'b0; // no grant for device 3
        endcase
    end
endmodule