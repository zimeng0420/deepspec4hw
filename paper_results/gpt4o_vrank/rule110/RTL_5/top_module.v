module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q);

    reg [511:0] next_state;
    integer i;
    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            next_state[0] = q[1];  // Considering q[-1] as 0
            next_state[511] = q[510];  // Considering q[512] as 0
            
            for (i = 1; i < 511; i = i + 1) begin
                case ({q[i+1], q[i], q[i-1]})
                    3'b111: next_state[i] = 0;
                    3'b110: next_state[i] = 1;
                    3'b101: next_state[i] = 1;
                    3'b100: next_state[i] = 0;
                    3'b011: next_state[i] = 1;
                    3'b010: next_state[i] = 1;
                    3'b001: next_state[i] = 1;
                    3'b000: next_state[i] = 0;
                    default: next_state[i] = 0;
                endcase
            end
            
            q <= next_state;
        end
    end
endmodule