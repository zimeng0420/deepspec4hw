module top_module (
	input in,
	input [9:0] state,
	output [9:0] next_state,
	output out1,
	output out2
);

  // Define states using parameters for readability (optional but recommended)
  parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9;

  // Next state logic
  always @(*) begin
    case (1'b1)  // using a constant expression for case selection so the default case will be always executed.
      (state[S0]): next_state[S0] = ~in;  // Equivalent to (state[S0] && !in)
                  next_state[S1] = in;   // Equivalent to (state[S0] && in)
                  next_state[S2] = 0;
                  next_state[S3] = 0;
                  next_state[S4] = 0;
                  next_state[S5] = 0;
                  next_state[S6] = 0;
                  next_state[S7] = 0;
                  next_state[S8] = 0;
                  next_state[S9] = 0;
      (state[S1]): next_state[S0] = ~in;  // Equivalent to (state[S1] && !in)
                  next_state[S2] = in;   // Equivalent to (state[S1] && in)
                  next_state[S1] = 0;
                  next_state[S3] = 0;
                  next_state[S4] = 0;
                  next_state[S5] = 0;
                  next_state[S6] = 0;
                  next_state[S7] = 0;
                  next_state[S8] = 0;
                  next_state[S9] = 0;
      (state[S2]): next_state[S0] = ~in;  // Equivalent to (state[S2] && !in)
                  next_state[S3] = in;   // Equivalent to (state[S2] && in)
                  next_state[S1] = 0;
                  next_state[S2] = 0;
                  next_state[S4] = 0;
                  next_state[S5] = 0;
                  next_state[S6] = 0;
                  next_state[S7] = 0;
                  next_state[S8] = 0;
                  next_state[S9] = 0;
      (state[S3]): next_state[S0] = ~in;  // Equivalent to (state[S3] && !in)
                  next_state[S4] = in;   // Equivalent to (state[S3] && in)
                  next_state[S1] = 0;
                  next_state[S2] = 0;
                  next_state[S3] = 0;
                  next_state[S5] = 0;
                  next_state[S6] = 0;
                  next_state[S7] = 0;
                  next_state[S8] = 0;
                  next_state[S9] = 0;
      (state[S4]): next_state[S0] = ~in;  // Equivalent to (state[S4] && !in)
                  next_state[S5] = in;   // Equivalent to (state[S4] && in)
                  next_state[S1] = 0;
                  next_state[S2] = 0;
                  next_state[S3] = 0;
                  next_state[S4] = 0;
                  next_state[S6] = 0;
                  next_state[S7] = 0;
                  next_state[S8] = 0;
                  next_state[S9] = 0;
      (state[S5]): next_state[S8] = ~in;  // Equivalent to (state[S5] && !in)
                  next_state[S6] = in;   // Equivalent to (state[S5] && in)
                  next_state[S1] = 0;
                  next_state[S2] = 0;
                  next_state[S3] = 0;
                  next_state[S4] = 0;
                  next_state[S5] = 0;
                  next_state[S7] = 0;
                  next_state[S9] = 0;
      (state[S6]): next_state[S9] = ~in;  // Equivalent to (state[S6] && !in)
                  next_state[S7] = in;   // Equivalent to (state[S6] && in)
                  next_state[S1] = 0;
                  next_state[S2] = 0;
                  next_state[S3] = 0;
                  next_state[S4] = 0;
                  next_state[S5] = 0;
                  next_state[S6] = 0;
                  next_state[S8] = 0;
      (state[S7]): next_state[S0] = ~in;  // Equivalent to (state[S7] && !in)
                  next_state[S7] = in;   // Equivalent to (state[S7] && in)
                  next_state[S1] = 0;
                  next_state[S2] = 0;
                  next_state[S3] = 0;
                  next_state[S4] = 0;
                  next_state[S5] = 0;
                  next_state[S6] = 0;
                  next_state[S8] = 0;
                  next_state[S9] = 0;
      (state[S8]): next_state[S0] = ~in;  // Equivalent to (state[S8] && !in)
                  next_state[S1] = in;   // Equivalent to (state[S8] && in)
                  next_state[S2] = 0;
                  next_state[S3] = 0;
                  next_state[S4] = 0;
                  next_state[S5] = 0;
                  next_state[S6] = 0;
                  next_state[S7] = 0;
                  next_state[S8] = 0;
                  next_state[S9] = 0;
      (state[S9]): next_state[S0] = ~in;  // Equivalent to (state[S9] && !in)
                  next_state[S1] = in;   // Equivalent to (state[S9] && in)
                  next_state[S2] = 0;
                  next_state[S3] = 0;
                  next_state[S4] = 0;
                  next_state[S5] = 0;
                  next_state[S6] = 0;
                  next_state[S7] = 0;
                  next_state[S8] = 0;
                  next_state[S9] = 0;
      default:  // Should not happen in a properly designed one-hot FSM, but good practice
                  next_state = 10'b0;
    endcase
  end


  // Output logic
  assign out1 = state[S8] | state[S9];
  assign out2 = state[S7] | state[S9];

endmodule