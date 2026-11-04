module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);
    // State Encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // State Flip-Flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            A: begin
                if (r[1])       next_state = B; // Request from device 1
                else if (r[2])  next_state = C; // Request from device 2
                else if (r[3])  next_state = D; // Request from device 3
                else            next_state = A; // No requests
            end
            
            B: begin
                if (r[1])       next_state = B; // Maintain state B if r1 is still high
                else            next_state = A; // Go back to A if r1 is low
            end
            
            C: begin
                if (r[2])       next_state = C; // Maintain state C if r2 is still high
                else            next_state = A; // Go back to A if r2 is low
            end
            
            D: begin
                next_state = A; // Go back to A from D
            end
            
            default: next_state = A; // Retry to state A on error
        endcase
    end

    // Output Logic
    always @(*) begin
        g = 3'b000; // Default case, no grants
        case (current_state)
            B: g[1] = 1; // Grant to device 1
            C: g[2] = 1; // Grant to device 2
            D: g[3] = 1; // Grant to device 3
            default: g = 3'b000; // No grants
        endcase
    end
endmodule