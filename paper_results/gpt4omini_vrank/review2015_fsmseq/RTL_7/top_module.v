module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    typedef enum reg [2:0] {
        S0, // Initial state
        S1, // Detected '1'
        S2, // Detected '11'
        S3, // Detected '110'
        S4  // Detected '1101'
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            start_shifting <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            S0: begin
                if (data) 
                    next_state = S1;
                else 
                    next_state = S0;
                start_shifting = 0;
            end
            S1: begin
                if (data) 
                    next_state = S2;
                else 
                    next_state = S0;
                start_shifting = 0;
            end
            S2: begin
                if (data) 
                    next_state = S3;
                else 
                    next_state = S0;
                start_shifting = 0;
            end
            S3: begin
                if (data) 
                    next_state = S4;
                else 
                    next_state = S0;
                start_shifting = 0;
            end
            S4: begin
                next_state = S4; // Remains in this state
                start_shifting = 1; // Sequence found
            end
            default: begin
                next_state = S0;
                start_shifting = 0;
            end
        endcase
    end
endmodule