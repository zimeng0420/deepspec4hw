module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    reg [1:0] state, next_state;
    parameter A = 2'b00, B = 2'b01, B1 = 2'b10, B2 = 2'b11;

    // Counter for w=1 occurrences
    reg [1:0] w_count;
    // Cycle counter in state B
    reg [1:0] cycle_count;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (s == 1)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (cycle_count == 2)
                    next_state = B1;
                else
                    next_state = B;
            end
            B1: begin
                next_state = B2;
            end
            B2: begin
                next_state = B;
            end
            default: next_state = A;
        endcase
    end

    // Cycle and w=1 count logic
    always @(posedge clk) begin
        if (reset || state == A) begin
            cycle_count <= 0;
            w_count <= 0;
        end else if (state == B) begin
            cycle_count <= cycle_count + 1;
            if (w == 1)
                w_count <= w_count + 1;
        end else if (state == B2) begin
            cycle_count <= 0;
            w_count <= 0;
        end
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            z <= 0;
        end else if (state == B1) begin
            if (w_count == 2)
                z <= 1;
            else
                z <= 0;
        end else if (state == B2) begin
            z <= 0;  // Reset z after it was produced in B1
        end
    end

endmodule