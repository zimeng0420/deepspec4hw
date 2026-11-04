module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    typedef enum logic [3:0] {
        S0 = 4'b0000, // No ones detected yet
        S1 = 4'b0001, // 1 one detected
        S2 = 4'b0010, // 2 consecutive ones
        S3 = 4'b0011, // 3 consecutive ones
        S4 = 4'b0100, // 4 consecutive ones
        S5 = 4'b0101, // 5 consecutive ones
        S6 = 4'b0110, // 0111110 detected (disallow)
        S7 = 4'b0111, // 01111110 detected (flag)
        S8 = 4'b1000  // 7 or more consecutive ones (error)
    } state_t;

    state_t present_state, next_state;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            present_state <= S0;
        end else begin
            present_state <= next_state;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        // Default outputs
        disc = 0;
        flag = 0;
        err = 0;
        
        case (present_state)
            S0: begin
                if (in) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                if (in) next_state = S2;
                else next_state = S0;
            end
            S2: begin
                if (in) next_state = S3;
                else next_state = S0;
            end
            S3: begin
                if (in) next_state = S4;
                else next_state = S0;
            end
            S4: begin
                if (in) next_state = S5;
                else next_state = S0;
            end
            S5: begin
                if (in) next_state = S6;
                else next_state = S0;
            end
            S6: begin
                if (in) next_state = S7;
                else begin
                    next_state = S0;
                    disc = 1; // 0111110 detected
                end
            end
            S7: begin
                if (in) next_state = S8;
                else begin
                    next_state = S0;
                    flag = 1; // 01111110 detected
                end
            end
            S8: begin
                if (in) begin
                    next_state = S8;
                    err = 1; // 01111111... detected (error)
                end else begin
                    next_state = S0;
                    err = 1; // 01111111... ends
                end
            end
            default: next_state = S0;
        endcase
    end

endmodule