module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State Encoding
    typedef enum reg [1:0] {S0, S1, S2, S3} state_t;
    state_t current_state, next_state;

    // State Transition Logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= S0;
            f <= 0;
            g <= 0;
        end else begin
            current_state <= next_state;
            f <= (current_state == S0) ? 1 : 0; // Set f to 1 for one clock cycle after resetn is de-asserted
        end
    end

    // Next State Logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            S0: if (f == 1) begin
                    if (x == 1) next_state = S1; // Transition to S1 when x is 1
                end
            S1: if (x == 0) next_state = S2; // Transition to S2 when x is 0
                else if (x != 1) next_state = S0; // If x is neither 1 nor 0, go back to S0
            S2: if (x == 1) next_state = S3; // Transition to S3 when x is 1
                else if (x != 0) next_state = S0; // If x is neither 0 nor 1, go back to S0
            S3: begin
                    g <= 1; // Set g to 1 when the sequence 1, 0, 1 is detected
                    next_state = S3; // Stay in S3
                end
            default: next_state = S0;
        endcase
    end
    
    // Output Logic for g based on y
    reg [1:0] y_counter; // Counter to monitor y input
    
    always @(posedge clk) begin
        if (current_state == S3) begin
            if (y == 1) begin
                g <= 1; // Maintain g = 1
                y_counter <= 0; // Reset y_counter
            end else if (y_counter < 2) begin
                y_counter <= y_counter + 1; // Increment counter if y is not 1
            end else begin
                g <= 0; // Set g = 0 if y is not 1 within two clock cycles
            end
        end
    end
    
endmodule