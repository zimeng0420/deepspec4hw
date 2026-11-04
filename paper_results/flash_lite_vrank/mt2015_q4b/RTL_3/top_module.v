module top_module(
	input x,
	input y,
	output z);

	reg z_reg;
	reg [6:0] state;

	always @(x or y) begin
		case (state)
			0: begin
				z_reg = 1;
				if (x == 1 && y == 0)
					state <= 1;
				else
					state <= 0;
			end
			1: begin
				z_reg = 0;
				if (x == 0 && y == 1)
					state <= 2;
				else
					state <= 1;
			end
			2: begin
				z_reg = 0;
				if (x == 1 && y == 1)
					state <= 3;
				else
					state <= 2;
			end
			3: begin
				z_reg = 1;
				if (x == 0 && y == 0)
					state <= 4;
				else
					state <= 3;
			end
            4: begin
                z_reg = 1;
                if(x==0 && y==1)
                    state <= 5;
                else
                    state <= 4;
            end
            5: begin
                z_reg = 0;
                if (x==1 && y == 1)
                    state <= 6;
                else
                    state <=5;
            end
            6: begin
                z_reg = 1;
                if (x==0 && y==1)
                    state <= 7;
                else
                    state <=6;
            end
            7: begin
                z_reg = 0;
                if (x==0 && y==1)
                    state <= 7;
                else if (x == 1 && y==0)
                    state <= 8;
                else
                    state <=7;
            end
            8: begin
                z_reg = 0;
                state <=8;
            end

			default: begin
				z_reg = 1;
				state <= 0;
			end
		endcase
	end

	assign z = z_reg;

endmodule