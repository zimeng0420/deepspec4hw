module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01
    } state_t;

    state_t current_state, next_state;
    reg [2:0] w_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
            z <= 0;
            w_count <= 0;
        end else begin
            current_state <= next_state;
            if(current_state == B)
                w_count <= {w_count[1:0], w}; // Shift w in for counting
            if (w_count == 3'b110 || w_count == 3'b101 || w_count == 3'b011)
                z <= 1;
            else
                z <= 0;
        end
    end

    always @* begin
        case (current_state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (s)
                    next_state = B;  // Stay in B while s is 1
                else
                    next_state = A;  // Go back to A when s is 0
            end
            default: next_state = A; // Default case
        endcase
    end

endmodule