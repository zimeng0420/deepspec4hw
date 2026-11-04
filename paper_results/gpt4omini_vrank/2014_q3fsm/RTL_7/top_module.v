module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        COUNT_0 = 2'b10,
        COUNT_1 = 2'b11
    } state_t;

    state_t state, next_state;
    reg [1:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            z <= 0;
            count <= 0;
        end else begin
            state <= next_state;
            if (next_state == COUNT_1) begin
                if (count == 2) z <= 1;
                else z <= 0;
            end
        end
    end

    always @(*) begin
        case(state)
            A: begin
                if (s) next_state = B;
                else next_state = A;
            end
            B: begin
                count = 0;
                next_state = COUNT_0;
            end
            COUNT_0: begin
                if (count < 3) begin
                    count = count + w;
                    next_state = COUNT_1;
                end else begin
                    next_state = COUNT_0;
                end
            end
            COUNT_1: begin
                if(count < 3) next_state = COUNT_0; // stay in counting state
                else next_state = B; // reset to B after checking
            end
         endcase 
     end
endmodule