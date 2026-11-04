# Messages for Task: ringer

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Suppose you are designing a circuit to control a cellphone's ringer and vibration motor. Whenever the phone needs to ring from an incoming call (input ring), your circuit must either turn on the ringer (output ringer = 1) or the motor (output motor = 1), but not both. If the phone is in vibrate mode (input vibrate_mode = 1), turn on the motor. Otherwise, turn on the ringer.

The compressed specification is as follows: ```json
{
  "header": "module top_module(\n input ring,\n input vibrate_mode,\n output ringer,\n output motor\n);",
  "combinational_logic_function": "The circuit implements a mutually exclusive activation of either the 'ringer' or 'motor' output based on the 'ring' and 'vibrate_mode' inputs. The 'ring' input signals an incoming call, while the 'vibrate_mode' input determines whether the phone should vibrate or ring. The logic ensures that only one of the outputs, 'ringer' or 'motor', is active at any given time. The 'motor' output is activated when 'ring' AND 'vibrate_mode' are both high. The 'ringer' output is activated when 'ring' is high AND 'vibrate_mode' is low. Boolean expressions for the outputs are as follows:\n\nmotor = ring AND vibrate_mode\nringer = ring AND (NOT vibrate_mode)",
  "enhanced_combinational_description": "This combinational logic circuit controls the activation of a cellphone's ringer and vibration motor. The circuit has two inputs: 'ring' and 'vibrate_mode', and two outputs: 'ringer' and 'motor'. The 'ring' input indicates an incoming call, and the 'vibrate_mode' input selects between ringing and vibrating. The core requirement is that only one of the 'ringer' or 'motor' outputs can be active simultaneously. When an incoming call is detected ('ring' is high), the circuit checks the 'vibrate_mode' input. If 'vibrate_mode' is high, the 'motor' output is activated, and the 'ringer' output is deactivated. Conversely, if 'vibrate_mode' is low, the 'ringer' output is activated, and the 'motor' output is deactivated. If there is no incoming call ('ring' is low), both 'ringer' and 'motor' outputs are deactivated. The logic is implemented using AND and NOT gates to ensure the mutually exclusive behavior. Specifically, the 'motor' output is the logical AND of 'ring' and 'vibrate_mode'. The 'ringer' output is the logical AND of 'ring' and the inverse of 'vibrate_mode'. This arrangement guarantees that only one output is active when 'ring' is asserted, based on the state of 'vibrate_mode', and that both outputs are inactive when 'ring' is deasserted."
}
```

The header you have already known is:module top_module(
	input ring, 
	input vibrate_mode,
	output ringer,
	output motor
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

