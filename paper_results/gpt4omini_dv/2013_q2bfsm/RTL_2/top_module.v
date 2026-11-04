module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    // State encoding
    typedef enum reg [1:0] {
        A = 2'b00, // state A (waiting for reset)
        S0 = 2'b01, // state S0 (waiting for 1)
        S1 = 2'b10, // state S1 (detected 1)
        S2 = 2'b11  // state S2 (detected 0)
    } state_t;

    state_t current_state, next_state;
    reg [1:0] y_counter;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= A;
            f <= 0;
            g <= 0;
            y_counter <= 0;
        end else begin
            current_state <= next_state;
            f <= (current_state == A) ? 1 : 0; // f = 1 for one clock cycle after reset 
            // Reset the y_counter if we transition to g = 1
            if (g) begin
                if (y == 1) begin
                    y_counter <= 0; // reset y_counter if y is detected
                end else if (y_counter < 2) begin
                    y_counter <= y_counter + 1; // increment counter if y is not 1
                end
            end
        end
    end

    always @(*) begin
        case (current_state)
            A: begin
                g = 0;
                if (!resetn) begin
                    next_state = S0; // Move to S0 after reset is de-asserted
                end else begin
                    next_state = A; // Stay in state A
                end
            end
            S0: begin
                if (x) begin
                    next_state = S1; // Transition to S1 if x is 1
                end else begin
                    next_state = S0; // Stay in S0
                end
            end
            S1: begin
                if (!x) begin
                    next_state = S2; // Transition to S2 if x is 0
                end else begin
                    next_state = S1; // Stay in S1
                end
            end
            S2: begin
                if (x) begin
                    g = 1; // Set g to 1
                    next_state = S0; // Return to S0 for the next sequence
                end else begin
                    next_state = S0; // Stay in S0
                end
            end
            default: next_state = A; // Default to state A
        endcase
    end

    always @(posedge clk) begin
        if (y_counter >= 2) begin
            g <= 0; // Set g to 0 if y is not 1 within two clock cycles
        end else if (g && (y == 1)) begin
            g <= 1; // Maintain g = 1 if y is detected
        end
    end
endmodule