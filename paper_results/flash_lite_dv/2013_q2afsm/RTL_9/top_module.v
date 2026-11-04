module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State Definitions
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // State Register
    reg [1:0] state;
    reg [1:0] next_state;

    // State Transition Logic
    always @(*) begin
        next_state = state; // Default: stay in current state

        case (state)
            A: begin
                if (r[1]) next_state = B;
                else if (r[2]) next_state = C;
                else if (r[3]) next_state = D;
            end
            B: begin
                if (~r[1]) next_state = A;
            end
            C: begin
                if (~r[2]) next_state = A;
            end
            D: begin
            end
        endcase
    end

    // State Flip-Flops
    always @(posedge clk or negedge resetn) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Output Logic
    always @(*) begin
        g = 3'b000;  // Default: no grants
        case (state)
            A: begin
                if (r[1]) g[1] = 1'b1;
                else if (r[2]) g[2] = 1'b1;
                else if (r[3]) g[3] = 1'b1;
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