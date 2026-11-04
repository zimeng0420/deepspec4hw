module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    typedef enum reg [1:0] {
        LOW = 2'b00,
        BETWEEN_S2_S3 = 2'b01,
        BETWEEN_S1_S2 = 2'b10,
        HIGH = 2'b11
    } state_type;

    state_type current_state, next_state;
    reg previous_level_signal;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= LOW;
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 0;
            previous_level_signal <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            LOW: begin
                if (s[1] == 1) begin
                    next_state = BETWEEN_S1_S2;
                end else begin
                    next_state = LOW;
                end
                fr3 = 1;
                fr2 = 1;
                fr1 = 1;
                dfr = 0;
            end
            BETWEEN_S1_S2: begin
                if (s[2] == 1) begin
                    next_state = BETWEEN_S2_S3;
                end else if (s[1] == 0) begin
                    next_state = LOW;
                end else begin
                    next_state = BETWEEN_S1_S2;
                end
                fr3 = 0;
                fr2 = 1;
                fr1 = 1;
                dfr = previous_level_signal ? 1 : 0;
            end
            BETWEEN_S2_S3: begin
                if (s[3] == 1) begin
                    next_state = HIGH;
                end else if (s[2] == 0) begin
                    next_state = BETWEEN_S1_S2;
                end else begin
                    next_state = BETWEEN_S2_S3;
                end
                fr3 = 0;
                fr2 = 0;
                fr1 = 1;
                dfr = previous_level_signal ? 1 : 0;
            end
            HIGH: begin
                if (s[3] == 0) begin
                    next_state = BETWEEN_S2_S3;
                end else begin
                    next_state = HIGH;
                end
                fr3 = 0;
                fr2 = 0;
                fr1 = 0;
                dfr = 0;
            end
        endcase
        
        previous_level_signal = (s[3] > s[2]) ? 1 : (s[2] > s[1]) ? 1 : 0;
    end
endmodule