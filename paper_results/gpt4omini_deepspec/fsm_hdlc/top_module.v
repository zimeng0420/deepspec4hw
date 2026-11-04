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
        S0, // Initial state or 0 received
        S1, // 1 received
        S2, // 11 received
        S3, // 111 received
        S4, // 1111 received
        S5, // 11111 received
        S6, // 0111110 received --> disc
        S7, // 01111110 received --> flag
        S8  // 1111111 received --> err
    } state_t;

    state_t current_state, next_state;

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state and outputs
    always @* begin
        // Default outputs
        disc = 0;
        flag = 0;
        err = 0;
        
        // State transition logic
        case (current_state)
            S0: begin
                if (in) next_state = S1; else next_state = S0; // Next state is S1 if in is 1
            end
            
            S1: begin
                if (in) next_state = S2; else next_state = S0; // Next state is S2 if in is 1, else reset
            end
            
            S2: begin
                if (in) next_state = S3; else next_state = S0; // Next state is S3 if in is 1, else reset
            end
            
            S3: begin
                if (in) next_state = S4; else next_state = S0; // Next state is S4 if in is 1, else reset
            end
            
            S4: begin
                if (in) next_state = S5; else next_state = S0; // Next state is S5 if in is 1, else reset
            end
            
            S5: begin
                if (in) next_state = S8; else next_state = S6; // 7 ones, go to err or handle 0
            end
            
            S6: begin
                disc = 1; // Output disc here
                next_state = (in) ? S1 : S0; // Reset or next state based on in
            end
            
            S7: begin
                flag = 1; // Output flag here
                next_state = (in) ? S1 : S0; // Reset or next state based on in
            end
            
            S8: begin
                err = 1; // Output err here
                next_state = (in) ? S8 : S0; // Loop in err state for 1's
            end
            
            default: begin
                next_state = S0; // Default case
            end
        endcase
    end

endmodule