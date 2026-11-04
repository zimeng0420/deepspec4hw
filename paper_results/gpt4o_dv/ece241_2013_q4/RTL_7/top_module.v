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
    reg [1:0] previous_state;
    
    // State encoding
    localparam ABOVE_S3 = 2'b11;   // All sensors asserted
    localparam BETWEEN_S3_S2 = 2'b10; // s[1] = 1, s[2] = 1, s[3] = 0
    localparam BETWEEN_S2_S1 = 2'b01; // s[1] = 1, s[2] = 0, s[3] = 0
    localparam BELOW_S1 = 2'b00;   // No sensors asserted

    // Combinational logic for next state and outputs
    always @(*) begin
        case (s)
            3'b111: next_state = ABOVE_S3;
            3'b110: next_state = BETWEEN_S3_S2;
            3'b100: next_state = BETWEEN_S2_S1;
            default: next_state = BELOW_S1;
        endcase
        
        case (next_state)
            ABOVE_S3: begin
                fr3 = 1'b0;
                fr2 = 1'b0;
                fr1 = 1'b0;
                dfr = 1'b0;
            end
            BETWEEN_S3_S2: begin
                fr3 = 1'b0;
                fr2 = 1'b0;
                fr1 = 1'b1;
                dfr = (next_state > previous_state) ? 1'b1 : 1'b0;
            end
            BETWEEN_S2_S1: begin
                fr3 = 1'b0;
                fr2 = 1'b1;
                fr1 = 1'b1;
                dfr = (next_state > previous_state) ? 1'b1 : 1'b0;
            end
            BELOW_S1: begin
                fr3 = 1'b1;
                fr2 = 1'b1;
                fr1 = 1'b1;
                dfr = (next_state > previous_state) ? 1'b1 : 1'b0;
            end
        endcase
    end

    // Sequential logic for state transition and reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= BELOW_S1;
            previous_state <= BELOW_S1;
            fr3 <= 1'b1;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            previous_state <= current_state;
            current_state <= next_state;
        end
    end

endmodule