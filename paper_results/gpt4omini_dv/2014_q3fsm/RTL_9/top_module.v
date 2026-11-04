module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);
    reg [1:0] state, next_state;
    reg [2:0] w_count;

    localparam A = 2'b00, B = 2'b01;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 0;
        end else begin
            state <= next_state;
            if (state == B) begin
                // Shift w_count and count the number of w = 1
                w_count <= {w_count[1:0], w}; 
            end
            // Set z based on count of w in last 3 cycles
            if (next_state == B && w_count[2:0] == 3'b011 || w_count[2:0] == 3'b101 || w_count[2:0] == 3'b110) 
                z <= 1;
            else 
                z <= 0;
        end
    end

    always @(*) begin
        case (state)
            A: begin
                if (s) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                next_state = B; // Remain in state B
            end
            default: next_state = A; // Default to state A
        endcase
    end
endmodule