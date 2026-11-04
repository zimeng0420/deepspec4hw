module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State definition
    typedef enum logic [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01,
        STATE_COUNT1 = 2'b10,
        STATE_COUNT2 = 2'b11
    } state_type;
    
    state_type state, next_state;
    reg [1:0] w_count;

    // State register logic
    always @(posedge clk) begin
        if (reset)
            state <= STATE_A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_A: begin
                if (s)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end
            STATE_B: begin
                next_state = STATE_COUNT1;
            end
            STATE_COUNT1: begin
                next_state = STATE_COUNT2;
            end
            STATE_COUNT2: begin
                next_state = STATE_B;
            end
            default: next_state = STATE_A; // fallback state
        endcase
    end

    // Output logic and counter update
    always @(posedge clk) begin
        if (state == STATE_A) begin
            w_count <= 0;
            z <= 0;
        end else if (state == STATE_B || state == STATE_COUNT1 || state == STATE_COUNT2) begin
            if (w)
                w_count <= w_count + 1;
            if (state == STATE_COUNT2) begin
                z <= (w_count == 2);
                w_count <= 0;
            end else
                z <= 0;
        end
    end

endmodule