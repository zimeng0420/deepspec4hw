module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        CHECK1 = 2'b10,
        CHECK2 = 2'b11
    } state_t;

    state_t state, next_state;
    reg [2:0] count_w;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(state or s or w) begin
        case (state)
            A: begin
                if (s) begin
                    next_state = B;
                    count_w = 0;
                end else begin
                    next_state = A;
                end
                z = 0;
            end
            
            B: begin
                next_state = CHECK1;
                count_w = 0;
                z = 0;
            end
            
            CHECK1: begin
                if (w) count_w = 1; else count_w = 0;
                next_state = CHECK2;
                z = 0;
            end
            
            CHECK2: begin
                if (w) count_w = count_w + 1;
                next_state = B;
                z = (count_w == 2) ? 1 : 0;
            end
            
            default: begin
                next_state = A;
                z = 0;
            end
        endcase
    end
endmodule