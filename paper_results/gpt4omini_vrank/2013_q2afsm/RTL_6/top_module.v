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

    // State table (combinational logic)
    always @(*) begin
        case (state)
            A: begin
                if (r[1]) next_state = B;
                else if (r[2]) next_state = C;
                else if (r[3]) next_state = D;
                else next_state = A;
            end
            B: begin
                if (r[1]) next_state = B;  // Grant to device 1
                else next_state = A;       // Revert back to A if r1 = 0
            end
            C: begin
                if (r[2]) next_state = C;  // Grant to device 2
                else next_state = A;       // Revert back to A if r2 = 0
            end
            D: begin
                next_state = A;            // Go back to A, no grants
            end
            default: next_state = A;
        endcase
    end

    // State flip-flops (sequential logic)
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A;                 // Reset to state A
        else
            state <= next_state;       // Update state
    end

    // Grant outputs
    always @(*) begin
        g = 3'b000;  // Default to all grants low
        case (state)
            A: begin
                if (r[1]) g[1] = 1;   // Grant to device 1
                else if (r[2]) g[2] = 1; // Grant to device 2
                else if (r[3]) g[3] = 1; // Grant to device 3
            end
            B: g[1] = 1;                // Device 1 grant
            C: g[2] = 1;                // Device 2 grant
            D: g = 3'b000;              // No grants
        endcase
    end

endmodule