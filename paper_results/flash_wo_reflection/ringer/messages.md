# Messages for Task: ringer

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Suppose you are designing a circuit to control a cellphone's ringer and vibration motor. Whenever the phone needs to ring from an incoming call (input ring), your circuit must either turn on the ringer (output ringer = 1) or the motor (output motor = 1), but not both. If the phone is in vibrate mode (input vibrate_mode = 1), turn on the motor. Otherwise, turn on the ringer.

The compressed specification is as follows: ```json
{
  "header": "The top module header definition is:\n\n```verilog\nmodule top_module(\n input ring,\n input vibrate_mode,\n output ringer,\n output motor\n);\n```\n\nThis module controls a cellphone's ringer and vibration motor. It has two inputs: `ring` (indicates an incoming call) and `vibrate_mode` (indicates whether the phone is in vibrate mode). It has two outputs: `ringer` (activates the ringer) and `motor` (activates the vibration motor). The module ensures that only one of the outputs, `ringer` or `motor`, is active at any given time.",
  "combinational_logic_function": "The combinational logic function is defined as follows:\n\n*   **motor**: The `motor` output is activated if `vibrate_mode` is active (1). If `vibrate_mode` is inactive (0), the `motor` is inactive (0) unless `ring` is active (1).\n*   **ringer**: The `ringer` output is activated only if `ring` is active (1) and `vibrate_mode` is inactive (0).\n\nBoolean expressions for the outputs are:\n\n*   `motor = vibrate_mode | (ring & ~vibrate_mode);`\n*   `ringer = ring & ~vibrate_mode;`\n\nTruth Table:\n\n| ring | vibrate_mode | ringer | motor |\n|---|---|---|---|\n| 0 | 0 | 0 | 0 |\n| 0 | 1 | 0 | 1 |\n| 1 | 0 | 1 | 0 |\n| 1 | 1 | 0 | 1 |\n\nThis ensures mutually exclusive outputs for `ringer` and `motor`.",
  "enhanced_combinational_description": "This specification details the combinational logic for a cellphone ringer/vibration motor control circuit. The circuit's primary function is to activate either the ringer or the vibration motor based on the `ring` (incoming call) and `vibrate_mode` inputs, ensuring that only one is active at any given time. The module `top_module` encapsulates this logic.\n\n**Inputs:**\n\n*   `ring`: A single-bit input signal. When `ring` is asserted (1), it indicates an incoming call.\n*   `vibrate_mode`: A single-bit input signal. When `vibrate_mode` is asserted (1), it indicates that the phone is in vibrate mode.\n\n**Outputs:**\n\n*   `ringer`: A single-bit output signal. When `ringer` is asserted (1), it activates the phone's ringer.\n*   `motor`: A single-bit output signal. When `motor` is asserted (1), it activates the phone's vibration motor.\n\n**Functional Specification:**\n\nThe circuit operates according to the following rules:\n\n1.  **Vibrate Mode Priority:** If the `vibrate_mode` input is asserted (1), the `motor` output *must* be asserted (1), and the `ringer` output *must* be de-asserted (0). This takes precedence over the `ring` input.\n2.  **Ringer Activation:** If the `vibrate_mode` input is de-asserted (0), the `ringer` output is asserted (1) *only* when the `ring` input is also asserted (1). If `vibrate_mode` is de-asserted (0) and `ring` is de-asserted (0), the `ringer` output *must* be de-asserted (0).\n3.  **Mutual Exclusivity:** The `ringer` and `motor` outputs *must* be mutually exclusive. They *cannot* be asserted (1) simultaneously under any input conditions. This is a critical requirement for the circuit's correct operation.\n\n**Logic Equations:**\n\nThe behavior can be expressed using the following Boolean equations:\n\n*   `motor = vibrate_mode OR (ring AND NOT vibrate_mode)`\n*   `ringer = ring AND NOT vibrate_mode`\n\nThese equations directly translate the functional specification into a logical representation. The `motor` is activated if the phone is in vibrate mode *or* if there's an incoming call and the phone is *not* in vibrate mode. The `ringer` is activated only if there's an incoming call and the phone is *not* in vibrate mode.\n\n**Truth Table:**\n\nThe following truth table summarizes the circuit's behavior for all possible input combinations:\n\n| ring | vibrate_mode | ringer | motor |\n|---|---|---|---|\n| 0 | 0 | 0 | 0 |\n| 0 | 1 | 0 | 1 |\n| 1 | 0 | 1 | 0 |\n| 1 | 1 | 0 | 1 |\n\nThis truth table provides a complete and unambiguous definition of the circuit's combinational logic function."
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

