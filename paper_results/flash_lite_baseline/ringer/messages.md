# Messages for Task: ringer

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Suppose you are designing a circuit to control a cellphone's ringer and vibration motor. Whenever the phone needs to ring from an incoming call (input ring), your circuit must either turn on the ringer (output ringer = 1) or the motor (output motor = 1), but not both. If the phone is in vibrate mode (input vibrate_mode = 1), turn on the motor. Otherwise, turn on the ringer.

The header you have already known is:module top_module(
	input ring, 
	input vibrate_mode,
	output ringer,
	output motor
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

