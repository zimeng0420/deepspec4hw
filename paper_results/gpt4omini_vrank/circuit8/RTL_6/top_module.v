module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);
    reg [1:0] state; 
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    always @(posedge clock) begin
        case(state)
            S0: begin
                p <= 0;
                q <= 0;
                if (a) state <= S1;
                else state <= S0;
            end
            S1: begin
                p <= 0;
                q <= 0;
                state <= S2;
            end
            S2: begin
                p <= a;
                q <= !a;
                state <= S3;
            end
            S3: begin
                p <= a;
                q <= a;
                if (a) state <= S0;
            end
            default: state <= S0;
        endcase
    end

    initial begin
        state = S0;
    end
endmodule