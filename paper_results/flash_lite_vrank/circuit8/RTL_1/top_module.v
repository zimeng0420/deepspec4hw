module top_module (
	input clock,
	input a, 
	output reg p,
	output reg q
);
    reg state;

    always @(posedge clock) begin
        if (a) begin
            if (state == 0) begin
                state <= 1;
                p <= 1;
                q <= 0;
            end else if (state == 1) begin
                state <= 0;
                p <= 1;
                q <= 1;
            end
        end else begin
            if (state == 0) begin
                p <= 0;
                q <= 0;
            end else begin
                p <= 0;
                q <= 1;
            end
        end
    end

    always @(posedge clock) begin
        if(!a && q)
            state <= 0;
        else if(!a && !q)
            state <= 0;

    end

    always @(posedge clock) begin
      if (a && !q) begin
        
      end
    end
endmodule