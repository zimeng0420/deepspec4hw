module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'b000, // Initial state (0)
        S1 = 3'b001, // 0 followed by 1
        S2 = 3'b010, // 01 followed by 1
        S3 = 3'b011, // 011 followed by 1
        S4 = 3'b100, // 0111 followed by 1
        S5 = 3'b101, // 01111 followed by 1
        S6 = 3'b110, // 011111 followed by 0 (disc)
        S7 = 3'b111  // 0111111 (err)
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @* begin
        next_state = current_state; // Default to hold state
        disc = 0;
        flag = 0;
        err = 0;

        case (current_state)
            S0: begin
                if (in) next_state = S1; // 0 followed by 1
            end
            S1: begin
                if (in) next_state = S2; // 01 followed by 1
                else  next_state = S0;   // 0 followed by 0
            end
            S2: begin
                if (in) next_state = S3; // 011 followed by 1
                else  next_state = S0;   // 01 followed by 0
            end
            S3: begin
                if (in) next_state = S4; // 0111 followed by 1
                else  next_state = S0;   // 011 followed by 0
            end
            S4: begin
                if (in) next_state = S5; // 01111 followed by 1
                else  next_state = S0;   // 0111 followed by 0
            end
            S5: begin
                if (in) next_state = S6; // 011111 followed by 1 (disc)
                else  next_state = S0;   // 01111 followed by 0
            end
            S6: begin
                if (in) next_state = S7; // 0111110 followed by 1 (flag)
                else  next_state = S0;   // 011111 followed by 0
            end
            S7: begin
                err = 1;                 // Error state for 7+ consecutive 1s
                if (~in) next_state = S0; // Reset on 0
            end
        endcase
    end

    // State memory
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0; // Reset to initial state
        end else begin
            current_state <= next_state; // Transition to next state
        end
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Outputs are asserted one cycle after the condition occurs
            if (next_state == S6) 
                disc <= 1;
            else if (next_state == S7) 
                err <= 1;
            else if (next_state == S6 && current_state == S7) 
                flag <= 1;
            else begin
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
        end
    end

endmodule