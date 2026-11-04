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
    reg previous_level, current_level;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fr3 <= 1'b1; // Max flow
            fr2 <= 1'b1; // Max flow
            fr1 <= 1'b1; // Max flow
            dfr <= 1'b1; // Supplemental flow is open
            current_level <= 1'b0; // Initializing level
        end else begin
            previous_level <= current_level; // Store previous state
            current_level <= s[1] | s[2] | s[3]; // Determine current level based on sensor

            // Combinational logic for flow rates
            if (s[3]) begin // Above s[3]
                fr1 <= 1'b0;
                fr2 <= 1'b0;
                fr3 <= 1'b0;
            end else if (s[2]) begin // Between s[3] and s[2]
                fr1 <= 1'b1;
                fr2 <= 1'b0;
                fr3 <= 1'b0;
            end else if (s[1]) begin // Between s[2] and s[1]
                fr1 <= 1'b1;
                fr2 <= 1'b1;
                fr3 <= 1'b0;
            end else begin // Below s[1]
                fr1 <= 1'b1;
                fr2 <= 1'b1;
                fr3 <= 1'b1;
            end
            
            // Control Supplemental flow valve
            dfr <= (previous_level < current_level) ? 1'b1 : 1'b0;
        end
    end
endmodule