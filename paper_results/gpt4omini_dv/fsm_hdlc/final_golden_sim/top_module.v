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
        S0 = 3'b000, // Initial state or receiving 0
        S1 = 3'b001, // 0
        S2 = 3'b010, // 01
        S3 = 3'b011, // 011
        S4 = 3'b100, // 0111
        S5 = 3'b101, // 01111
        S6 = 3'b110, // 011111
        S7 = 3'b111  // 0111111 (error state)
    } state_t;

    state_t state, next_state;

    // Sequential logic: State transition
    always @(posedge clk) begin
        if (reset) 
            state <= S0;
        else 
            state <= next_state;
    end

    // Combinational logic: Next state and outputs
    always @(*) begin
        disc = 0;
        flag = 0;
        err = 0;
        case (state)
            S0: begin
                if (in) next_state = S1; else next_state = S0;
            end
            S1: begin
                if (in) next_state = S2; else next_state = S0;
            end
            S2: begin
                if (in) next_state = S3; else next_state = S0;
            end
            S3: begin
                if (in) next_state = S4; else next_state = S0;
            end
            S4: begin
                if (in) next_state = S5; else next_state = S0;
            end
            S5: begin
                if (in) next_state = S6; else next_state = S0;
            end
            S6: begin
                if (in) begin
                    next_state = S7; // More than 6 consecutive 1s
                    err = 1;
                end else begin
                    next_state = S0; // Transition back to S0
                    flag = 1; // Found the flag 01111110
                end
            end
            S7: begin
                // Stay in error state for continuous 1s
                if (!in) 
                    next_state = S0; 
                else 
                    next_state = S7;
            end
            default: next_state = S0;
        endcase
    end

    // Handle the discard condition
    always @(posedge clk) begin
        if (state == S5 && in) begin
            disc <= 1; // Detected 0111110
        end else begin
            disc <= 0; // Clear disc signal
        end
    end
endmodule