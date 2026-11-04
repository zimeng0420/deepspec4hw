module top_module (
	input clock,
	input a, 
	output reg p,
	output reg q
);

    reg state;

    always @(posedge clock) begin
        if (a) begin
            state <= 1;
        end else begin
            state <= state;
        end
    end
    
    always @(posedge clock) begin
        if (a) begin
            p <= 1;
        end else begin
            if (state == 1)
                p <= 0;
            else
                p <= 0;
        end
    end
    
    always @(posedge clock) begin
        if(a)
          q <= 1;
        else begin
            if(p==1 && !a)
              q <= 1;
            else
              q <= 0;
        end
    end

endmodule