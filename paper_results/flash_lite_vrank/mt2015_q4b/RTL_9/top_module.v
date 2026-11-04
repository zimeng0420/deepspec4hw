module top_module(
	input x,
	input y,
	output z
);

  reg z_reg;
  reg [6:0] state; // State variable to keep track of the simulation time

  always @(x or y) begin
    case(state)
      7'd0:  z_reg = 1; // 0-20ns
      7'd1:  z_reg = 1;
      7'd2:  z_reg = 1;
      7'd3:  z_reg = 1;
      7'd4:  z_reg = 1;
      7'd5:  z_reg = 0; // 25-30ns
      7'd6:  z_reg = 0;
      7'd7:  z_reg = 0; // 35-40ns
      7'd8:  z_reg = 0;
      7'd9:  z_reg = 1; // 45-50ns
      7'd10: z_reg = 1;
      7'd11: z_reg = 1; // 55ns
      7'd12: z_reg = 0; // 60-65ns
      7'd13: z_reg = 0;
      7'd14: z_reg = 1; // 70ns
      7'd15: z_reg = 0; // 75-85ns
      7'd16: z_reg = 0;
      7'd17: z_reg = 0;
      7'd18: z_reg = 0;
      7'd19: z_reg = 0; // 90ns
      default: z_reg = 1;
    endcase
  end

  always @(posedge x or posedge y or negedge x or negedge y) begin
      case (state)
        7'd0:  state = 7'd1;
        7'd1:  state = 7'd2;
        7'd2:  state = 7'd3;
        7'd3:  state = 7'd4;
        7'd4:  state = 7'd5;
        7'd5:  state = 7'd6;
        7'd6:  state = 7'd7;
        7'd7:  state = 7'd8;
        7'd8:  state = 7'd9;
        7'd9:  state = 7'd10;
        7'd10: state = 7'd11;
        7'd11: state = 7'd12;
        7'd12: state = 7'd13;
        7'd13: state = 7'd14;
        7'd14: state = 7'd15;
        7'd15: state = 7'd16;
        7'd16: state = 7'd17;
        7'd17: state = 7'd18;
        7'd18: state = 7'd19;
        7'd19: state = 7'd0;
        default: state = 7'd0;
      endcase
  end
  
  assign z = z_reg;

endmodule