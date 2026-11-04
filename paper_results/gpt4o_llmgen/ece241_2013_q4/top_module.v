module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    // State Definitions
    typedef enum reg [1:0] {
        H  = 2'b00,  // High Water Level State
        MU = 2'b01,  // Medium Upper State
        ML = 2'b10,  // Medium Lower State
        L  = 2'b11   // Low Water Level State
    } state_t;

    state_t current_state, next_state;
    reg prev_level_higher;

    // State Transition Logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= L;
            prev_level_higher <= 0;
        end else begin
            current_state <= next_state;
            if (current_state < next_state) begin
                prev_level_higher <= 1;
            end else if (current_state > next_state) begin
                prev_level_higher <= 0;
            end
        end
    end

    // Next State Logic and Output Assignments
    always @(*) begin
        // Defaults
        next_state = current_state;
        {fr3, fr2, fr1, dfr} = 4'b0000;

        case (current_state)
            H: begin
                if (!s[3]) begin
                    next_state = MU;
                end
            end

            MU: begin
                fr1 = 1;
                if (s[3]) begin
                    next_state = H;
                end else if (!s[2]) begin
                    next_state = ML;
                end
            end

            ML: begin
                fr1 = 1;
                fr2 = 1;
                if (s[2]) begin
                    next_state = MU;
                    dfr = prev_level_higher;
                end else if (!s[1]) begin
                    next_state = L;
                end
            end

            L: begin
                fr1 = 1;
                fr2 = 1;
                fr3 = 1;
                if (s[1]) begin
                    next_state = ML;
                    dfr = prev_level_higher;
                end
            end
        endcase
    end

    // Reset Logic
    always @(posedge clk) begin
        if (reset) begin
            fr1 <= 1;
            fr2 <= 1;
            fr3 <= 1;
            dfr <= 1;
        end
    end

endmodule