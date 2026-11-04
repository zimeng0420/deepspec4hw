module top_module (
	input a,
	input b,
	input c,
	input d,
	output out_sop,
	output out_pos
);

wire [15:0] inputs = {a, b, c, d};

assign out_sop = (inputs == 4'b0010) || (inputs == 4'b0111) || (inputs == 4'b1111);

assign out_pos = (inputs[0] && inputs[1] && inputs[2] && inputs[3]) || 
                 (inputs[0] && !inputs[1] && inputs[2] && !inputs[3]) || 
                 (inputs[0] && !inputs[1] && !inputs[2] && inputs[3]) || 
                 (!inputs[0] && inputs[1] && !inputs[2] && inputs[3]);

endmodule