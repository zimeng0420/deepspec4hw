module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    reg [1:0] current_state, next_state;
    parameter LOW = 2'b00, BETWEEN_1_2 = 2'b01, BETWEEN_2_3 = 2'b10, HIGH = 2'b11;

    always @(posedge clk or posedge reset) begin
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

    always @(*) begin
        case (current_state)
            LOW: begin
                if (s[1] == 0 && s[2] == 0 && s[3] == 0) begin
                    next_state = LOW;
                    fr3 = 1; fr2 = 1; fr1 = 1; dfr = 0;
                end else if (s[1] == 1) begin
                    next_state = BETWEEN_1_2;
                end else if (s[2] == 1) begin
                    next_state = BETWEEN_2_3;
                end else if (s[3] == 1) begin
                    next_state = HIGH;
                end
            end
            BETWEEN_1_2: begin
                next_state = (s[2] == 0) ? LOW : (s[3] == 1) ? HIGH : BETWEEN_1_2;
                fr3 = 0; fr2 = 1; fr1 = 1; dfr = 0;
            end
            BETWEEN_2_3: begin
                next_state = (s[1] == 0) ? LOW : (s[3] == 1) ? HIGH : BETWEEN_2_3;
                fr3 = 0; fr2 = 1; fr1 = 1; dfr = 1;
            end
            HIGH: begin
                next_state = (s[3] == 0) ? BETWEEN_2_3 : HIGH;
                fr3 = 0; fr2 = 0; fr1 = 0; dfr = 0;
            end
            default: begin
                next_state = LOW;
                fr3 = 1; fr2 = 1; fr1 = 1; dfr = 0;
            end
        endcase
    end
endmodule