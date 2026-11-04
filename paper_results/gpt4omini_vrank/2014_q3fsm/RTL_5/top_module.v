module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum reg [1:0] {
        A = 2'b00, // state A
        B = 2'b01, // state B
        COUNT = 2'b10 // counting state
    } state_t;

    state_t current_state, next_state;
    reg [1:0] count_w;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= A; 
            count_w <= 2'b00; 
            z <= 0; 
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            A: begin
                z = 0;
                if (s) begin
                    next_state = B;
                end
            end
            B: begin
                count_w = 0;
                next_state = COUNT;
            end
            COUNT: begin
                if (count_w < 2) begin
                    if (w) begin
                        count_w = count_w + 1;
                    end
                    next_state = (count_w == 2) ? A : COUNT;
                end else begin
                    z = 1;
                    next_state = A;
                end
            end
        endcase
        
        if (current_state == COUNT) begin
            z = (count_w == 2) ? 1 : 0;
        end
    end

endmodule