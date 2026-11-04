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
        S0 = 3'b000, // Initial/Reset state
        S1 = 3'b001, // Read 1
        S2 = 3'b010, // Read 2
        S3 = 3'b011, // Read 3
        S4 = 3'b100, // Read 4
        S5 = 3'b101, // Read 5
        S6 = 3'b110  // Read 6
    } state_t;

    state_t current_state, next_state;

    // Sequential block for state transition
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end
    end

    // Combinational block for FSM
    always @(*) begin
        next_state = current_state;
        
        case (current_state)
            S0: begin
                if (in == 1) next_state = S1;
            end
            S1: begin
                if (in == 1) next_state = S2;
                else next_state = S0; // reset on 0
            end
            S2: begin
                if (in == 1) next_state = S3;
                else next_state = S0; // reset on 0
            end
            S3: begin
                if (in == 1) next_state = S4;
                else next_state = S0; // reset on 0
            end
            S4: begin
                if (in == 1) next_state = S5;
                else next_state = S0; // reset on 0
            end
            S5: begin
                if (in == 1) next_state = S6; // Error state on the next 1
                else begin
                    disc <= 1; // Signal for disc
                    next_state = S0; // Reset state on 0
                end
            end
            S6: begin
                if (in == 1) begin
                    err <= 1; // Signal for err
                end else begin
                    flag <= 1; // Signal for flag
                    next_state = S0; // Reset state on 0
                end
            end
            default: next_state = S0; // Default state
        endcase
    end
endmodule