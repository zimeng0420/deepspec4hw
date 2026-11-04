module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    reg [2:0] state, next_state;
    reg [1:0] w_count;
    reg [1:0] cycle_count;

    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 2'd0;
            cycle_count <= 2'd0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    z <= 0;
                    w_count <= 2'd0;
                    cycle_count <= 2'd0;
                end
                B: begin
                    cycle_count <= cycle_count + 2'd1;
                    if (w == 1)
                        w_count <= w_count + 2'd1;
                    if (cycle_count == 2'd2)
                        z <= (w_count == 2'd2);
                end
                C, D, E: begin
                    cycle_count <= cycle_count + 2'd1;
                    if (w == 1)
                        w_count <= w_count + 2'd1;
                    if (cycle_count == 2'd2) begin
                        z <= (w_count == 2'd2);
                        w_count <= 2'd0;
                        cycle_count <= 2'd0;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            A: next_state = (s == 1) ? B : A;
            B: next_state = (cycle_count == 2'd2) ? C : B;
            C: next_state = (cycle_count == 2'd2) ? D : C;
            D: next_state = (cycle_count == 2'd2) ? E : D;
            E: next_state = (cycle_count == 2'd2) ? B : E;
            default: next_state = A;
        endcase
    end

endmodule