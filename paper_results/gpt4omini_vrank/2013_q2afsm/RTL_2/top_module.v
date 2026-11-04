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

state_t current_state, next_state;

// State transition logic
always @(*) begin
    case (current_state)
        A: begin
            if (r[1]) next_state = B;
            else if (r[2]) next_state = C;
            else if (r[3]) next_state = D;
            else next_state = A;
        end

        B: begin
            if (r[1]) next_state = B; // Remain in B if r1 is high
            else next_state = A;       // Go to A if r1 is low
        end

        C: begin
            if (r[2]) next_state = C; // Remain in C if r2 is high
            else next_state = A;      // Go to A if r2 is low
        end

        D: begin
            next_state = A;           // Go to A after D
        end

        default: next_state = A;   // Default state
    endcase
end

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (!resetn)
        current_state <= A;
    else
        current_state <= next_state;
end

// Grant signals logic
always @(*) begin
    g = 3'b000; // Default all grants to 0
    case (current_state)
        B: g[1] = 1; // Grant for device 1
        C: g[2] = 1; // Grant for device 2
        D: g[3] = 1; // Grant for device 3
        default: g = 3'b000; // No grants in state A
    endcase
end

endmodule