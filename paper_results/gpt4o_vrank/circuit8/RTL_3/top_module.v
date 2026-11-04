module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);
    reg [1:0] state;

    always @(posedge clock) begin
        case (state)
            2'b00: state <= a ? 2'b01 : 2'b00;
            2'b01: state <= a ? 2'b10 : 2'b00;
            2'b10: state <= a ? 2'b10 : 2'b11;
            2'b11: state <= a ? 2'b01 : 2'b00;
        endcase
    end
    
    always @(*) begin
        case (state)
            2'b00: begin p = 0; q = 0; end
            2'b01: begin p = 1; q = 0; end
            2'b10: begin p = 1; q = 1; end
            2'b11: begin p = 0; q = 1; end
            default: begin p = 0; q = 0; end
        endcase
    end
endmodule