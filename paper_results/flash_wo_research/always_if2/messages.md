# Messages for Task: always_if2

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Fix any and all bugs in this code:

// module top_module (
//     input      cpu_overheated,
//     output reg shut_off_computer,
//     input      arrived,
//     input      gas_tank_empty,
//     output reg keep_driving  ); //

//     always @(*) begin
//         if (cpu_overheated)
//            shut_off_computer = 1;
//     end

//     always @(*) begin
//         if (~arrived)
//            keep_driving = ~gas_tank_empty;
//     end

// endmodule


The compressed specification is as follows: ```json
{
  "header": "module top_module (\n input cpu_overheated,\n output reg shut_off_computer,\n input arrived,\n input gas_tank_empty,\n output reg keep_driving\n);",
  "combinational_logic_function": "The combinational logic function is defined by two independent Boolean expressions:\n\n1.  `shut_off_computer = cpu_overheated`\n2.  `keep_driving = ~arrived & ~gas_tank_empty`\n\nThese expressions can be implemented directly using AND and NOT gates. The logic organization consists of two separate paths, one for each output. The critical path is determined by the gate delays in each path. There is no opportunity for operator sharing or resource utilization strategies since the expressions are independent. Logic level balancing is not applicable here. Output multiplexing is not required as the outputs are independent.",
  "enhanced_combinational_description": "The `top_module` implements a combinational logic circuit with three inputs (`cpu_overheated`, `arrived`, `gas_tank_empty`) and two outputs (`shut_off_computer`, `keep_driving`). The `shut_off_computer` output is asserted (logic high) if and only if the `cpu_overheated` input is asserted. The `keep_driving` output is asserted if and only if the `arrived` input is deasserted (logic low) AND the `gas_tank_empty` input is deasserted (logic low). The logic can be described as follows:\n\n*   `shut_off_computer` is directly assigned the value of `cpu_overheated`. This implies a direct connection or a buffer.\n*   `keep_driving` is the logical AND of the inverse of `arrived` and the inverse of `gas_tank_empty`. This requires two inverters and one AND gate. The output `keep_driving` is asserted only when the car has not arrived AND the gas tank is not empty. The circuit can be implemented using standard AND and NOT gates. The `shut_off_computer` signal is independent of `arrived` and `gas_tank_empty`, and the `keep_driving` signal is independent of `cpu_overheated`. The outputs are registered, but the logic driving them is purely combinational."
}
```

The header you have already known is:module top_module (
	input cpu_overheated,
	output reg shut_off_computer,
	input arrived,
	input gas_tank_empty,
	output reg keep_driving
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

