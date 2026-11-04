module top_module(
    input x,
    input y,
    output z
);

    reg [6:0] state;
    reg z_reg;
    
    assign z = z_reg;
    
    initial begin
        state = 7'b0000001;
        z_reg = 1;
    end
    
    always @(posedge x or posedge y) begin
        case(state)
            7'b0000001: if (x) state <= 7'b0000010; else if (y) state <= 7'b0000100; else state <= 7'b0000001;
            7'b0000010: if (x) state <= 7'b0000010; else if (y) state <= 7'b0001000; else state <= 7'b0000001;
            7'b0000100: if (x) state <= 7'b0010000; else if (y) state <= 7'b0000100; else state <= 7'b0000001;
            7'b0001000: if (x & y) state <= 7'b1000000; else state <= 7'b0000001;
            7'b0010000: if (x) state <= 7'b0100000; else state <= 7'b0000001;
            7'b0100000: if (x & y) state <= 7'b1000000; else state <= 7'b0000001;
            7'b1000000: state <= 7'b0000001;
            default: state <= 7'b0000001;
        endcase
    end
    
    always @(state) begin
        case(state)
            7'b0000001: z_reg <= 1;
            7'b0000010: z_reg <= 0;
            7'b0000100: z_reg <= 0;
            7'b0001000: z_reg <= 1;
            7'b0010000: z_reg <= 0;
            7'b0100000: z_reg <= 1;
            7'b1000000: z_reg <= 1;
            default: z_reg <= 1;
        endcase
    end
    
endmodule