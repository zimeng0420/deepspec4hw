module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

    parameter A = 0, B = 1, C = 2, D = 3, E = 4;
    reg [2:0] state;
    reg [2:0] w_count;
    reg [2:0] w_buffer;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 0;
            w_buffer <= 0;
        end else begin
            case (state)
                A: begin
                    z <= 0;
                    if (s) begin
                        state <= B;
                        w_count <= 0;
                        w_buffer <= 0;
                    end else begin
                        state <= A;
                    end
                end
                B: begin
                    w_buffer <= {w_buffer[1:0], w};
                    if(w_buffer[2] & w_buffer[1] | w_buffer[2] & w_buffer[0] | w_buffer[1] & w_buffer[0]) begin
                        w_count <= 1;
                    end else begin
                        w_count <= 0;
                    end
                    state <= C;
                end
                C: begin
                    z <= w_count;
                    state <= B;
                end
            endcase
        end
    end
endmodule