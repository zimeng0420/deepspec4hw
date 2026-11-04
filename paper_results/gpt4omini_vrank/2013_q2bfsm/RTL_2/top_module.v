module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum logic [1:0] {
        A, // State A
        B, // State B
        C  // State C
    } state_t;

    state_t current_state, next_state;
    logic [2:0] x_count; // To count the sequence of x inputs
    logic y_flag;

    always_ff @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            current_state <= A;
            f <= 0;
            g <= 0;
            x_count <= 0;
            y_flag <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (current_state == A) begin
            f <= 0; // In state A, ensure f is 0
            g <= 0; // g is also 0 in state A
            x_count <= 0; // Reset count for x transitions
        end else if (current_state == B) begin
            f <= 1; // Set f to 1 for one cycle in state B
            x_count <= 0; // Reset sequence count
        end else if (current_state == C) begin
            g <= g; // Maintain g value in state C
            if (y_flag) begin
                if (y) begin
                    g <= 1; // Maintain g = 1 if y=1
                end else begin
                    g <= 0; // Otherwise set g=0
                end
            end else begin
                if (y) begin
                    g <= 1; // Set g to 1 if y=1
                end
                y_flag <= 1; // Set flag for y monitoring
            end
        end
    end

    always_comb begin
        case (current_state)
            A: begin
                next_state = B; // Move to state B on next clk after reset
            end
            B: begin
                if (x_count == 3) begin // Check for sequence 101 in terms of x_counts
                    next_state = C; // Move to state C
                end else begin
                    next_state = B; // Stay in state B
                end
            end
            C: begin
                next_state = C; // Stay in state C
            end
        endcase
    end

    // Monitor x input for the pattern 101
    always_ff @(posedge clk) begin
        if (current_state == B) begin
            if (x == 1) begin
                x_count <= x_count + 1; // Count 1s
            end else begin
                x_count <= 0; // Reset on 0
            end
        end else begin
            x_count <= x_count; // Hold count otherwise
        end
    end

endmodule