module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum logic [2:0] {
        STATE_A = 3'b000,
        STATE_B = 3'b001,
        STATE_C = 3'b010,
        STATE_D = 3'b011,
        STATE_E = 3'b100
    } state_t;

    state_t state, next_state;
    reg [1:0] w_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    always @(posedge clk) begin
        if (state == STATE_B || state == STATE_C || state == STATE_D) begin
            if (w) begin
                w_count <= w_count + 1;
            end
        end else begin
            w_count <= 2'b00;
        end
    end
    
    always @(*) begin
        next_state = state;
        z = 1'b0;  // Default value of z
        
        case (state)
            STATE_A: begin
                if (s) begin
                    next_state = STATE_B;
                end
            end
            STATE_B: begin
                next_state = STATE_C;
            end
            STATE_C: begin
                next_state = STATE_D;
            end
            STATE_D: begin
                next_state = STATE_E;
            end
            STATE_E: begin
                if (w_count == 2'b10) begin
                    z = 1'b1;
                end else begin
                    z = 1'b0;
                end
                next_state = STATE_B;  // Loop back to check w for another three cycles
            end
        endcase
    end
endmodule