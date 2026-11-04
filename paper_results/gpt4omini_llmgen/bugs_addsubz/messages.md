# Messages for Task: bugs_addsubz

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate only a technical specification for the given task. I will tip you $200 if you can fulfill the tasks I give you.The following adder-subtractor with zero flag doesn't work. Fix the bug(s).

// synthesis verilog_input_version verilog_2001
// module top_module ( 
//     input do_sub,
//     input [7:0] a,
//     input [7:0] b,
//     output reg [7:0] out,
//     output reg result_is_zero
// );//

//     always @(*) begin
//         case (do_sub)
//           0: out = a+b;
//           1: out = a-b;
//         endcase

//         if (~out)
//             result_is_zero = 1;
//     end

// endmodule


```

## User Message

```
The header you have already known is:module top_module (
	input do_sub,
	input [7:0] a,
	input [7:0] b,
	output reg [7:0] out,
	output reg result_is_zero
);

```

