module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // State flip-flops
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            A: begin
                if (r[1]) 
                    next_state = B;
                else if (r[2]) 
                    next_state = C;
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
            default: next_state = A;
        endcase
    end

    // Grant output logic
    always_comb begin
        g = 3'b000; // default to no grant
        case (current_state)
            B: g[1] = 1; // Grant for device 1
            C: g[2] = 1; // Grant for device 2
            default: g = 3'b000; // No grants
        endcase
    end

endmodule