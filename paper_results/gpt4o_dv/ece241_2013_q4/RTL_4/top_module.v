module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    // Declare state encoding
    typedef enum reg [1:0] {
        LOW  = 2'b00, // Below s[1]
        MID1 = 2'b01, // Between s[2] and s[1]
        MID2 = 2'b10, // Between s[3] and s[2]
        HIGH = 2'b11  // Above s[3]
    } water_level_t;

    water_level_t current_level, previous_level;

    // Update current_level based on sensor input
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_level <= LOW;
            previous_level <= LOW;
            {fr3, fr2, fr1, dfr} <= 4'b1111;
        end else begin
            previous_level <= current_level;
            case (s)
                3'b111: current_level <= HIGH;
                3'b011: current_level <= MID2;
                3'b001: current_level <= MID1;
                default: current_level <= LOW;
            endcase
            
            // Determine outputs based on current and previous levels
            case (current_level)
                HIGH: begin
                    {fr3, fr2, fr1} <= 3'b000;
                    dfr <= 0;
                end
                MID2: begin
                    {fr3, fr2, fr1} <= 3'b001;
                    dfr <= (previous_level < current_level) ? 1 : 0;
                end
                MID1: begin
                    {fr3, fr2, fr1} <= 3'b011;
                    dfr <= (previous_level < current_level) ? 1 : 0;
                end
                LOW: begin
                    {fr3, fr2, fr1} <= 3'b111;
                    dfr <= (previous_level < current_level) ? 1 : 0;
                end
            endcase
        end
    end

endmodule