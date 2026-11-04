module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01
    } state_t;

    state_t state, next_state;
    reg [2:0] w_count; // to count the number of w=1 in 3 cycles
    reg [2:0] w_buffer; // 3-bit buffer to store w values

    // Synchronous state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 0;
            w_buffer <= 3'b000;
        end else begin
            state <= next_state;
            if (state == B) begin
                w_buffer <= {w_buffer[1:0], w}; // Shift in the current w value
                w_count <= w_buffer[0] + w_buffer[1] + w_buffer[2] + w; // Count w=1
            end
        end
    end

    // Next state and output logic
    always @(*) begin
        case (state)
            A: begin
                if (s) begin
                    next_state = B;
                    z = 0; // Initial state output
                end else begin
                    next_state = A;
                    z = 0; // Remain in A
                end
            end
            B: begin
                if (w_count == 3'b010 || w_count == 3'b001 || w_count == 3'b100) begin
                    z = 1; // Exactly two w's are 1
                end else begin
                    z = 0; // Otherwise
                end
                next_state = B; // Stay in state B
            end
            default: begin
                next_state = A;
            end
        endcase
    end

endmodule