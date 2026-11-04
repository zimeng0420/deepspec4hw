module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);
    
    reg [1:0] state;
    
    always @(posedge clock) begin
        case (state)
            2'b00: begin
                p <= 0;
                q <= 0;
                if (a) state <= 2'b01;
            end
            2'b01: begin
                if (a) begin
                    p <= 1;
                    q <= 0;
                    state <= 2'b10;
                end else begin
                    p <= 0;
                    q <= 0;
                end
            end
            2'b10: begin
                p <= 1;
                q <= 0;
                if (a) state <= 2'b11;
                else state <= 2'b01;
            end
            2'b11: begin
                p <= 1;
                q <= 1;
                if (!a) state <= 2'b00;
            end
        endcase
    end
    
    initial begin
        state = 2'b00;
    end
    
endmodule