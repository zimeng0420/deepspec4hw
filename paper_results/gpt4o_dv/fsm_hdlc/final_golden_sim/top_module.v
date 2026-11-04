module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] state, next_state;
    
    // State Encoding
    localparam STATE_0 = 3'd0,
               STATE_1 = 3'd1,
               STATE_2 = 3'd2,
               STATE_3 = 3'd3,
               STATE_4 = 3'd4,
               STATE_5 = 3'd5,
               STATE_6 = 3'd6,
               STATE_7 = 3'd7; // Error state (7 or more 1s)
    
    // State Transition Logic
    always @(*) begin
        case (state)
            STATE_0: next_state = in ? STATE_1 : STATE_0;
            STATE_1: next_state = in ? STATE_2 : STATE_0;
            STATE_2: next_state = in ? STATE_3 : STATE_0;
            STATE_3: next_state = in ? STATE_4 : STATE_0;
            STATE_4: next_state = in ? STATE_5 : STATE_0;
            STATE_5: next_state = in ? STATE_6 : STATE_0;
            STATE_6: next_state = in ? STATE_7 : STATE_0;
            STATE_7: next_state = in ? STATE_7 : STATE_0; // Stay in error if 1 continues
            default: next_state = STATE_0;
        endcase
    end
    
    // State Register Update
    always @(posedge clk) begin
        if (reset)
            state <= STATE_0;
        else
            state <= next_state;
    end
    
    // Output Logic
    always @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= (state == STATE_5 && in == 0);
            flag <= (state == STATE_6 && in == 0);
            err <= (state == STATE_7);
        end
    end

endmodule