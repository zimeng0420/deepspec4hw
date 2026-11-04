module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output [3:1] g
);

    // Define states
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg [1:0] state;
    reg [1:0] next_state;

    // Output register
    reg [3:1] g;

    // State Table (Combinational Logic)
    always @(*) begin
        next_state = state; // Default: Stay in current state

        case (state)
            A: begin
                if (r[1])       next_state = B;
                else if (r[2])  next_state = C;
                else if (r[3])  next_state = D;
                else            next_state = A; // Stay in A if no requests
            end
            B: begin
                if (r[1])       next_state = B;
                else            next_state = A;
            end
            C: begin
                if (r[2])       next_state = C;
                else            next_state = A;
            end
            D: begin
                if (r[1] || r[2] || r[3]) next_state = A;
                else next_state = D;
            end
            default: next_state = A; // Handle any unexpected state
        endcase
    end

    // State Flip-Flops (Sequential Logic)
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A; // Reset to state A
        else
            state <= next_state;
    end

    // Output Logic (Combinational Logic)
    always @(*) begin
        g = 3'b000; // Default: No grants

        case (state)
            B: g[1] = 1'b1; // Grant to device 1
            C: g[2] = 1'b1; // Grant to device 2
            D: g[3] = 1'b1; // Grant to device 3
            default: g = 3'b000; // No grant in state A
        endcase
    end

endmodule