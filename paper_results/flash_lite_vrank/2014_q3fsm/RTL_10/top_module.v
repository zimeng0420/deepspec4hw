module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    parameter A = 0;
    parameter B = 1;
    parameter C = 2;
    parameter D = 3;
    parameter E = 4;

    reg [2:0] state;
    reg [2:0] count;
    reg [2:0] w_history;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 0;
            w_history <= 0;
            z <= 0;
        end else begin
            case (state)
                A: begin
                    z <= 0;
                    if (s) begin
                        state <= B;
                        count <= 0;
                        w_history <= 0;
                    end else begin
                        state <= A;
                    end
                end
                B: begin
                    w_history <= {w_history[1:0], w};
                    count <= count + w;
                    state <= C;
                    z <= 0;

                end
                C: begin
                     w_history <= {w_history[1:0], w};
                     count <= count + w;
                     state <= D;
                     z <= 0;

                end
                D: begin
                     w_history <= {w_history[1:0], w};
                     count <= count + w;
                     state <= E;
                     z <= 0;
                end
                E: begin
                    if (count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    state <= B;
                    count <= 0;
                    w_history <= 0;
                end
                default: begin
                    state <= A;
                    count <= 0;
                    w_history <= 0;
                    z <= 0;
                end
            endcase
        end
    end
endmodule