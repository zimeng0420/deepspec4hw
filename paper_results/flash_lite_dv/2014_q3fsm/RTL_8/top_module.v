module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    parameter A = 0;
    parameter B = 1;

    reg [1:0] state;
    reg [1:0] w_count;
    reg [2:0] w_history;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 0;
            w_history <= 0;
        end else begin
            case (state)
                A: begin
                    z <= 0;
                    if (s) begin
                        state <= B;
                        w_count <= 0;
                        w_history <= 0;
                    end else begin
                        state <= A;
                    end
                end
                B: begin
                    w_history <= {w_history[1:0], w};
                    if (w_history[2] & !w_history[1]) w_count <= w_count + 1;
                    else if (!w_history[2] & w_history[1]) w_count <= w_count + 1;
                    else w_count <= w_count;

                    if (w_history[0] & !w_history[1]) w_count <= w_count + 1;
                    else if (!w_history[0] & w_history[1]) w_count <= w_count + 1;
                    else w_count <= w_count;


                    if (w_history[2] & w_history[1] & w_history[0]) w_count <= 2;
                    else if (!w_history[2] & !w_history[1] & !w_history[0]) w_count <= 0;

                    if(w_count == 2)
                        z <= 1;
                    else
                        z <= 0;

                    if (w_history[0] == 1)
                    begin
                        w_count <= 0;
                    end

                    if (w_history == 3'b000)
                    begin
                      w_count <= 0;
                    end
                    
                    if(w_history == 3'b111)
                    begin
                        w_count <= 2;
                    end
                    
                    if(w_history == 3'b011)
                    begin
                        w_count <= 2;
                    end
                    
                    if(w_history == 3'b110)
                    begin
                        w_count <= 2;
                    end

                    state <= B;

                end
            endcase
        end
    end

endmodule