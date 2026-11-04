module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        COUNT1 = 2'b10,
        COUNT2 = 2'b11
    } state_t;

    state_t state, next_state;
    reg [2:0] count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            count <= 0;
            z <= 0;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (state == B) begin
            if (count < 3) begin
                count <= count + 1;
            end else begin
                count <= 0; // Reset count after three cycles
            end
        end
    end

    always_comb begin
        next_state = state;
        z = 0; // Default output
        case (state)
            A: begin
                if (s) begin
                    next_state = B;
                end
            end
            B: begin
                if (count == 2) begin
                    z = (w == 1) ? 1 : 0; // Set z to 1 if exactly two 1's are found
                end else if (count == 3) begin
                    next_state = B; // Remain in state B to continue cycle
                end
            end
        endcase
    end
endmodule