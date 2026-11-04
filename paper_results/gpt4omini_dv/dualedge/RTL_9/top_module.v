module top_module(
    input clk,
    input d,
    output reg q
);
    reg d_reg_pos; // register to hold value on posedge
    reg d_reg_neg; // register to hold value on negedge
    
    always @(posedge clk) begin
        d_reg_pos <= d; // capture d on rising edge
    end
    
    always @(negedge clk) begin
        d_reg_neg <= d; // capture d on falling edge
    end

    always @(*) begin
        q = (clk) ? d_reg_pos : d_reg_neg; // output based on clock state
    end
endmodule