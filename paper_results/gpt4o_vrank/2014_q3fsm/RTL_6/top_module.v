module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    reg [1:0] state, next_state;
    reg [1:0] w_count;

    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 0;
        end else begin
            state <= next_state;
            
            if (state == B || state == C || state == D) begin
                if (w) w_count <= w_count + 1;
            end else begin
                w_count <= 0;
            end

            if (state == D) begin
                if (w_count == 2) z <= 1;
                else z <= 0;
            end else begin
                z <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            A: begin
                if (s) next_state = B;
                else next_state = A;
            end
            B: next_state = C;
            C: next_state = D;
            D: next_state = B;
            default: next_state = A;
        endcase
    end

endmodule