module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State definitions
    typedef enum logic [2:0] {
        ST_0,  // 0 consecutive 1s
        ST_1,  // 1 consecutive 1s
        ST_2,  // 2 consecutive 1s
        ST_3,  // 3 consecutive 1s
        ST_4,  // 4 consecutive 1s
        ST_5,  // 5 consecutive 1s
        ST_6,  // 6 consecutive 1s
        ST_7   // 7 or more consecutive 1s
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            ST_0: next_state = in ? ST_1 : ST_0;
            ST_1: next_state = in ? ST_2 : ST_0;
            ST_2: next_state = in ? ST_3 : ST_0;
            ST_3: next_state = in ? ST_4 : ST_0;
            ST_4: next_state = in ? ST_5 : ST_0;
            ST_5: next_state = in ? ST_6 : ST_0;
            ST_6: next_state = in ? ST_7 : ST_0;
            ST_7: next_state = in ? ST_7 : ST_0;
            default: next_state = ST_0;
        endcase
    end

    // Output logic
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err = 1'b0;
        case (current_state)
            ST_5: disc = (in == 1'b0);
            ST_6: flag = (in == 1'b0);
            ST_7: err = 1'b1;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= ST_0;
        end else begin
            current_state <= next_state;
        end
    end

endmodule