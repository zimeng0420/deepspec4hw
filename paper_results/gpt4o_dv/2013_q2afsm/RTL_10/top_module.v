module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    localparam [1:0] A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state, next_state;

    // State flip-flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A; // Reset to initial state A
        else
            state <= next_state;
    end
    
    // Next-state logic
    always @(*) begin
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
            default: next_state = A; // Default to state A for safe FSM
        endcase
    end

    // Output logic
    always @(*) begin
        g = 3'b000; // Default all grants to 0
        case (state)
            B: g[1] = 1; // Grant device 1
            C: g[2] = 1; // Grant device 2
            D: g[3] = 1; // Grant device 3
        endcase
    end

endmodule