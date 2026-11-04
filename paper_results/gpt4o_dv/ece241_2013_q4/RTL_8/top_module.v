module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    // State encoding
    reg [1:0] current_state, next_state;
    reg [1:0] previous_state;

    // State Definitions
    localparam ABOVE_S3 = 2'b11;
    localparam BETWEEN_S3_S2 = 2'b10;
    localparam BETWEEN_S2_S1 = 2'b01;
    localparam BELOW_S1 = 2'b00;

    // State Machine: Next State Logic
    always @(*) begin
        case (s)
            3'b111: next_state = ABOVE_S3;      // Above s[3]
            3'b011: next_state = BETWEEN_S3_S2; // Between s[3] and s[2]
            3'b001: next_state = BETWEEN_S2_S1; // Between s[2] and s[1]
            3'b000: next_state = BELOW_S1;      // Below s[1]
            default: next_state = BELOW_S1;     // Default state
        endcase
    end

    // Output Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, all outputs are set to 1
            current_state <= BELOW_S1;
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 1;
        end else begin
            current_state <= next_state;
            case (next_state)
                ABOVE_S3: begin
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 0;
                    dfr <= 0;
                end
                BETWEEN_S3_S2: begin
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 1;
                    dfr <= (previous_state < next_state);
                end
                BETWEEN_S2_S1: begin
                    fr3 <= 0;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= (previous_state < next_state);
                end
                BELOW_S1: begin
                    fr3 <= 1;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= (previous_state < next_state);
                end
                default: begin
                    fr3 <= 1;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= 1;
                end
            endcase
            previous_state <= current_state;
        end
    end

endmodule