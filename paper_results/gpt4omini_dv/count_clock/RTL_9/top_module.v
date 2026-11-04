module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss);

	reg [5:0] seconds = 0;
	reg [5:0] minutes = 0;
	reg [3:0] hours = 0;

	always @(posedge clk) begin
		if (reset) begin
			hh <= 8'd12;
			mm <= 8'd0;
			ss <= 8'd0;
			pm <= 0;
			seconds <= 0;
			minutes <= 0;
		end else if (ena) begin
			if (seconds == 59) begin
				seconds <= 0;
				if (minutes == 59) begin
					minutes <= 0;
					if (hours == 12) begin
						hours <= 1;
						pm <= ~pm; // Toggle AM/PM
					end else begin
						hours <= hours + 1;
					end
				end else begin
					minutes <= minutes + 1;
				end
			end else begin
				seconds <= seconds + 1;
			end
		end
	end

	always @* begin
		hh = hours + (hours == 0 ? 8'd12 : 0); // Convert 0 hour to 12
		mm = minutes;
		ss = seconds;
	end

endmodule