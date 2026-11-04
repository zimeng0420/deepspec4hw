# Messages for Task: bugs_addsubz

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog, Python and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can reply with the Verilog code after syntax check.
The following adder-subtractor with zero flag doesn't work. Fix the bug(s).

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


Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. The following adder-subtractor with zero flag doesn't work. Fix the bug(s).

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

// endmodulemodule top_module (
	input do_sub,
	input [7:0] a,
	input [7:0] b,
	output reg [7:0] out,
	output reg result_is_zero
);

```

