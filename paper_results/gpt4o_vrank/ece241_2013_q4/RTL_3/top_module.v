module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    reg [1:0] state, next_state;
    reg prev_level_higher;

    localparam BELOW_S1   = 2'b00;
    localparam BETWEEN_S1_S2 = 2'b01;
    localparam BETWEEN_S2_S3 = 2'b10;
    localparam ABOVE_S3   = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= BELOW_S1;
            prev_level_higher <= 1'b0;
        end else begin
            state <= next_state;
            if (s[3:1] == 3'b111) // Above s[3]
                prev_level_higher <= 1'b1;
            else if (s[3:1] == 3'b000) // Below s[1]
                prev_level_higher <= 1'b0;
            else // Transition between levels
                prev_level_higher <= (state < next_state);
        end
    end

    always @(*) begin
        case (state)
            BELOW_S1: begin
                fr3 = 1'b1;
                fr2 = 1'b1;
                fr1 = 1'b1;
                dfr = 1'b1;
                if (s[1]) next_state = BETWEEN_S1_S2;
                else next_state = BELOW_S1;
            end
            BETWEEN_S1_S2: begin
                fr3 = 1'b0;
                fr2 = 1'b1;
                fr1 = 1'b1;
                dfr = prev_level_higher;
                if (s[2]) next_state = BETWEEN_S2_S3;
                else if (!s[1]) next_state = BELOW_S1;
                else next_state = BETWEEN_S1_S2;
            end
            BETWEEN_S2_S3: begin
                fr3 = 1'b0;
                fr2 = 1'b0;
                fr1 = 1'b1;
                dfr = prev_level_higher;
                if (s[3]) next_state = ABOVE_S3;
                else if (!s[2]) next_state = BETWEEN_S1_S2;
                else next_state = BETWEEN_S2_S3;
            end
            ABOVE_S3: begin
                fr3 = 1'b0;
                fr2 = 1'b0;
                fr1 = 1'b0;
                dfr = 1'b0;
                if (!s[3]) next_state = BETWEEN_S2_S3;
                else next_state = ABOVE_S3;
            end
            default: begin
                fr3 = 1'b1;
                fr2 = 1'b1;
                fr1 = 1'b1;
                dfr = 1'b1;
                next_state = BELOW_S1;
            end
        endcase
    end

endmodule