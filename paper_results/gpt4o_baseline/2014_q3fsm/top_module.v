module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        COUNT1 = 2'b10,
        COUNT2 = 2'b11
    } state_t;

    state_t state, next_state;
    reg [1:0] w_count; // Counter to track 'w = 1'

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            w_count <= 0;
            z <= 0;
        end else begin
            state <= next_state;

            // Update z output and w_count based on states
            if (state == COUNT2 && w_count == 2) begin
                z <= 1; // Set z to 1 if exactly two 1s encountered
            end else begin
                z <= 0;
            end

            if (state == B || state==shot!)Move 💌block`stmt