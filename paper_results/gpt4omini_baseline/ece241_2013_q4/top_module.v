module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    reg [1:0] state, prev_state;

    localparam STATE_HIGH = 2'b00;
    localparam STATE_MED_HIGH = 2'b01;
    localparam STATE_MED_LOW = 2'b10;
    localparam STATE_LOW = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_LOW;
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 0;
            prev_state <= STATE_LOW;
        end else begin
            prev_state <= state;
            case (s)
                3'b111: begin // Above s[3]
                    state <= STATE_HIGH;
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 0;
                    dfr <= 0;
                end
                3'b110: begin // Between s[3] and s[2]
                    state <= STATE_MED_HIGH;
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 1;
                    dfr <= (prev_state == STATE_MED_LOW) ? 1 : 0;
                end
                3'b100: begin // Between s[2] and s[1]
                    state <= STATE_MED_LOW;
                    fr3 <= 0;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= (prev_state == STATE_LOW) ? 1 : 0;
                end
                3'b000: begin // Below s[1]
                    state <= STATE_LOW;
                    fr3 <= 1;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= 1;
                end
                default: begin
                    state <= STATE_LOW;
                    fr3 <= 1;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= 0;
                end
            endcase
        end
    end
endmodule