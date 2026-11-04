module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum logic [1:0] {
        S0, // Waiting for 1
        S1, // Detected 1
        S2, // Detected 0
        S3  // Detected 1
    } state_t;

    state_t current_state, next_state;
    integer count_y;

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= S0;
            f <= 0;
            g <= 0;
            count_y <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == S0 && !resetn) begin
                f <= 1;
            end else begin
                f <= 0;
            end
            
            if (current_state == S3) begin
                g <= 1;
            end else if (current_state == S2) begin
                if (count_y < 2) begin
                    count_y <= count_y + 1;
                end else begin
                    g <= 0;
                end
            end
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            S0: if (x) next_state = S1;
            S1: if (!x) next_state = S2;
            S2: if (x) next_state = S3;
            S3: if (y) g = 1; else next_state = S0;
            default: next_state = S0;
        endcase
    end

endmodule