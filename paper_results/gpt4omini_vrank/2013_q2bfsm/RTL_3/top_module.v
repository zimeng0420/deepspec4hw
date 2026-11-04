module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum reg [1:0] {
        state_A,
        state_B,
        state_C,
        state_g_one,
        state_g_zero
    } state_t;

    state_t current_state, next_state;
    reg [1:0] x_count; // Keeps track of x pattern
    reg y_flag; // Flag to determine if y was 1 within 2 cycles

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= state_A;
            f <= 0;
            g <= 0;
            x_count <= 0;
            y_flag <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(posedge clk) begin
        case (current_state)
            state_A: begin
                f <= 0;
                g <= 0;
                x_count <= 0;
                y_flag <= 0;
                next_state <= state_B; // Move to state B after reset
            end
            state_B: begin
                f <= 1; // Set f to 1 for one clock cycle
                next_state <= state_C; // Move to state C after first clock
            end
            state_C: begin
                f <= 0;
                if (x_count == 2'b01 && x) begin
                    next_state <= state_g_one; // Detected 1, 0, 1 pattern
                end else if (x_count == 2'b00 && !x) begin
                    x_count <= x_count + 1;
                end else if (x_count == 2'b01 && !x) begin
                    x_count <= x_count + 1;
                end else if (x_count == 2'b10 && x) begin
                    x_count <= 2'b00; // Reset count
                end else begin
                    x_count <= 0; // Reset count if pattern does not match
                end
            end
            state_g_one: begin
                g <= 1;
                if (y) begin
                    y_flag <= 1; // y is 1, maintain g=1
                end else begin
                    if (!y_flag) begin
                        next_state <= state_g_zero; // Transition to check y
                    end else begin
                        next_state <= state_g_one; // Maintain g=1
                    end
                end
            end
            state_g_zero: begin
                g <= 0; // Set g to 0
                next_state <= state_g_zero; // Remain in state
            end
            default: next_state <= state_A; // Default to state A
        endcase
    end
endmodule