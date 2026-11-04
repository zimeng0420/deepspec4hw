module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);
    typedef enum logic [1:0] {
        LOW = 2'b00,
        BETWEEN_2_1 = 2'b01,
        BETWEEN_3_2 = 2'b10,
        ABOVE_3 = 2'b11
    } state_t;

    state_t current_state, next_state;
    logic [3:1] sensors_last;

    always_ff @ (posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= LOW;
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @ (posedge clk) begin
        sensors_last <= s;
    end

    always_comb begin
        fr3 = 0;
        fr2 = 0;
        fr1 = 0;
        dfr = 0;

        case (current_state)
            LOW: begin
                if (sensors_last[1] == 0 && sensors_last[2] == 0 && sensors_last[3] == 0) begin
                    fr3 = 1;
                    fr2 = 1;
                    fr1 = 1;
                    dfr = 0;
                end
            end
            BETWEEN_2_1: begin
                fr1 = 1;
                fr2 = 1;
                dfr = (sensors_last < s) ? 1 : 0;
            end
            BETWEEN_3_2: begin
                fr1 = 1;
                dfr = (sensors_last < s) ? 1 : 0;
            end
            ABOVE_3: begin
                // Do nothing, all flow rates are zero
            end
        endcase

        if (s[3]) 
            next_state = ABOVE_3;
        else if (s[2] && !s[1])
            next_state = BETWEEN_3_2;
        else if (s[1])
            next_state = BETWEEN_2_1;
        else
            next_state = LOW;
    end
endmodule