module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // State transition logic
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
                if (r[1]) next_state = B; // Request from device 1
                else if (r[2]) next_state = C; // Request from device 2
                else if (r[3]) next_state = D; // Request from device 3
                else next_state = A; // No requests
            end
            B: begin
                if (r[1]) next_state = B; // Continue granting device 1
                else next_state = A; // Revert to state A if no request from device 1
            end
            C: begin
                if (r[2]) next_state = C; // Continue granting device 2
                else next_state = A; // Revert to state A if no request from device 2
            end
            D: begin
                // Device 3 is granted, it can only return to state A
                next_state = A; 
            end
            default: next_state = A; // Safety default
        endcase
    end

    // Output logic
    always_comb begin
        g = 3'b000; // Default to no grants
        case (current_state)
            A: begin
                if (r[1]) g[1] = 1; // Grant for device 1
                else if (r[2]) g[2] = 1; // Grant for device 2
                else if (r[3]) g[3] = 1; // Grant for device 3
            end
            B: g[1] = 1; // Grant for device 1
            C: g[2] = 1; // Grant for device 2
            D: g[3] = 1; // Grant for device 3
            default: g = 3'b000; // Safety default
        endcase
    end

endmodule