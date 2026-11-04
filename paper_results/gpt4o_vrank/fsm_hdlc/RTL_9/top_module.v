module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'b000, // No 1s seen
        S1 = 3'b001, // One 1 seen
        S2 = 3'b010, // Two consecutive 1s seen
        S3 = 3'b011, // Three consecutive 1s seen
        S4 = 3'b100, // Four consecutive 1s seen
        S5 = 3'b101, // Five consecutive 1s seen
        S6 = 3'b110, // Six consecutive 1s seen
        S7 = 3'b111  // Seven consecutive 1s seen (error)
    } state_t;
    
    state_t current_state, next_state;

    // State transition
    always @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        // Default outputs
        next_state = current_state;
        disc = 1'b0;
        flag = 1'b0;
        err = 1'b0;
        
        case (current_state)
            S0: begin
                if (in)
                    next_state = S1;
            end
            S1: begin
                if (in)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (in)
                    next_state = S3;
                else
                    next_state = S0;
            end
            S3: begin
                if (in)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (in)
                    next_state = S5;
                else
                    next_state = S0;
            end
            S5: begin
                if (in)
                    next_state = S6;
                else
                    next_state = S0;
            end
            S6: begin
                if (in) begin
                    next_state = S7;
                    err = 1'b1;  // Error encountered
                end else begin
                    next_state = S0;
                    flag = 1'b1; // End of frame (flag detected)
                end
            end
            S7: begin
                if (in) begin
                    // Stay in error
                    next_state = S7;
                    err = 1'b1;
                end else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
            end
        endcase

        // Discard logic
        if (current_state == S5 && in && next_state == S6) begin
            disc = 1'b1; // Bit needs to be discarded
        end
    end
endmodule