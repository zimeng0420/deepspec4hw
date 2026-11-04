#  Task: always_nolatches

## CMB Logic Prompt

```
Generate a high-quality technical specification for a combinational logic circuit based on the provided summaries.

Instructions:

- Your goal is to focus exclusively on the combinational logic aspects of the task and generate a comprehensive technical specification for a pure combinational logic design.
- Your report should serve as a comprehensive technical specification for pure combinational logic implementation.
- No words about sequential logic or timing analysis.
- No words about resource utilization or optimization.
- No words about clock frequencies or timing constraints.
- Do not include any code implementation details or formal verification steps in your response.
Available Information:

- RTL Top Module Header: module top_module (
	input [15:0] scancode,
	output reg left,
	output reg down,
	output reg right,
	output reg up
);

- Analyze Report: Top_Analyze="Analyze the module header, input port 'scancode', and output ports 'left', 'down', 'right', and 'up'. Focus on how the 16-bit scancode input is mapped to the four output signals, each representing an arrow key. The module's overall behavior is to decode the scancode and assert the corresponding output." Topic_Analyze='Provide a structured analysis of the research topic by addressing the following queries: 1) "PS/2 keyboard scancode structure and arrow key codes" to understand the specific scancodes for arrow keys; 2) "Verilog implementation of case statement for scancode decoding" to find efficient ways to implement the decoding logic; 3) "handling \'e0\' prefix in PS/2 scancodes" to understand the meaning of the prefix; 4) "debouncing PS/2 keyboard input in Verilog" to address potential issues with noisy inputs; and 5) "Verilog coding style for lookup tables" to explore alternative implementations. Synthesize the findings to provide a focused analysis of the research topic, considering the date September 12, 2025.' Solving_Strategies="Outline the overall reasoning strategies and methodology: 1) Decompose the problem into identifying the correct scancodes and implementing the decoding logic. 2) Create a case statement that maps each scancode to its corresponding output. 3) Consider the 'e0' prefix and ensure it is handled correctly. 4) Implement the logic in Verilog, ensuring that the correct output is asserted for each arrow key scancode. 5) Test the implementation with different scancodes to verify its correctness."
- Original Task Description: User: CMB
Suppose you're building a circuit to process scancodes from a PS/2 keyboard for a game. Given the last two bytes of scancodes received, you need to indicate whether one of the arrow keys on the keyboard have been pressed. This involves a fairly simple mapping, which can be implemented as a case statement (or if-elseif) with four cases.
// Scancode[15:0] | Arrow key
// 16'he06b | left arrow
// 16'he072 | down arrow
// 16'he074 | right arrow
// 16'he075 | up arrow
// Anything else | none
// Your circuit has one 16-bit input, and four outputs. Build this circuit that recognizes these four scancodes and asserts the correct output.


module top_module (
	input [15:0] scancode,
	output reg left,
	output reg down,
	output reg right,
	output reg up
);


- Others:{"web_research_result": "Okay, I will perform multiple searches to gather information about PS/2 keyboard scancodes, focusing on the structure, arrow key codes, hardware design, digital circuits, and Verilog implementations. Then, I will use this information to address the user's task of building a circuit to process scancodes and identify arrow key presses, while adhering to the provided interface definitions.\n\nBased on the search results, here's information relevant to the PS/2 keyboard scancode structure and arrow key codes, useful for building the requested circuit:\n\n*   **Scancodes:** When a key is pressed (make code) or released (break code), the PS/2 keyboard sends scancodes. Most make codes consist of a single byte. However, some extended keys send a two-byte sequence, starting with `0xE0`. When a key is held down, the make code is repeatedly sent.\n*   **Break Codes:** When a key is released, a break code is transmitted. For single-byte scancodes, the break code is `0xF0` followed by the make code. For extended keys, the break code is `0xE0 F0` followed by the key's code.\n*   **Scan Code Sets:** There are three scan code sets. Scan code set 2 is the default for modern keyboards.\n*   **Arrow Key Scancodes (Scan Code Set 2):** The following make codes (when key is pressed) are used for arrow keys:\n    *   Left Arrow: `E0 6B`\n    *   Down Arrow: `E0 72`\n    *   Right Arrow: `E0 74`\n    *   Up Arrow: `E0 75`\n*   **PS/2 Protocol:** The PS/2 keyboard communicates using a serial protocol. Data is transmitted in 11-bit packets, including a start bit, 8 data bits (LSB first), an odd parity bit, and a stop bit. The keyboard provides a clock signal, and data is read on the falling edge of the clock.\n\nWith this information, here's the Verilog code that recognizes the four scancodes and asserts the correct output:\n\n```verilog\nmodule top_module (\n    input [15:0] scancode,\n    output reg left,\n    output reg down,\n    output reg right,\n    output reg up\n);\n\nalways @(*) begin\n    left = (scancode == 16'he06b);\n    down = (scancode == 16'he072);\n    right = (scancode == 16'he074);\n    up = (scancode == 16'he075);\nend\n\nendmodule\n```"}

Output Format:
Format your response as a JSON object with the following structure:

```json
{
  "header": "The top module header definition from module top_module (
	input [15:0] scancode,
	output reg left,
	output reg down,
	output reg right,
	output reg up
);
, including the interface definition and their behavior.",

  "combinational_logic_function": "Describe how outputs derive from inputs (e.g., Boolean expressions, truth table patterns). Provide a systematic breakdown of the combinational logic structure optimized for performance and area. Include: logic organization with clear functional boundaries, signal flow optimization and critical path identification, operator sharing and resource utilization strategies, logic level balancing and delay equalization techniques, output multiplexing and selection logic organization.",

  "enhanced_combinational_description": "Comprehensive combinational logic specification derived from User: CMB
Suppose you're building a circuit to process scancodes from a PS/2 keyboard for a game. Given the last two bytes of scancodes received, you need to indicate whether one of the arrow keys on the keyboard have been pressed. This involves a fairly simple mapping, which can be implemented as a case statement (or if-elseif) with four cases.
// Scancode[15:0] | Arrow key
// 16'he06b | left arrow
// 16'he072 | down arrow
// 16'he074 | right arrow
// 16'he075 | up arrow
// Anything else | none
// Your circuit has one 16-bit input, and four outputs. Build this circuit that recognizes these four scancodes and asserts the correct output.


module top_module (
	input [15:0] scancode,
	output reg left,
	output reg down,
	output reg right,
	output reg up
);

. All details must be comprehensive and tailored for LLM models."
}






```

## CMB Logic Summary

```
```json
{
  "header": "The top module header definition is:\n\n```verilog\nmodule top_module (\n    input [15:0] scancode,\n    output reg left,\n    output reg down,\n    output reg right,\n    output reg up\n);\n```\n\nThis defines a module named `top_module` with a 16-bit input `scancode` and four 1-bit output registers: `left`, `down`, `right`, and `up`. The `scancode` input represents the PS/2 keyboard scancode, and the outputs indicate whether the corresponding arrow key is pressed.",
  "combinational_logic_function": "The combinational logic function maps the 16-bit `scancode` input to the four output signals based on the following Boolean expressions:\n\n*   `left = (scancode == 16'he06b)`\n*   `down = (scancode == 16'he072)`\n*   `right = (scancode == 16'he074)`\n*   `up = (scancode == 16'he075)`\n\nEach output is asserted (set to 1) if the `scancode` input matches the specific hexadecimal value associated with that arrow key. Otherwise, the output is deasserted (set to 0). The logic organization consists of four independent comparators, each comparing the `scancode` input with a specific constant. The output of each comparator directly drives the corresponding output register. There is no operator sharing or output multiplexing. The signal flow is straightforward: the `scancode` input is broadcast to all four comparators, and the comparator outputs directly drive the output registers.",
  "enhanced_combinational_description": "This combinational logic circuit decodes PS/2 keyboard scancodes to detect arrow key presses. The circuit receives a 16-bit input, `scancode`, representing the last two bytes of the received scancode. The circuit has four 1-bit outputs: `left`, `down`, `right`, and `up`. Each output corresponds to a specific arrow key. The circuit's function is to assert the corresponding output if the `scancode` matches the scancode for that arrow key. The specific scancode mappings are as follows:\n\n*   If `scancode` is equal to `16'he06b`, then `left` is asserted (set to 1). Otherwise, `left` is deasserted (set to 0).\n*   If `scancode` is equal to `16'he072`, then `down` is asserted (set to 1). Otherwise, `down` is deasserted (set to 0).\n*   If `scancode` is equal to `16'he074`, then `right` is asserted (set to 1). Otherwise, `right` is deasserted (set to 0).\n*   If `scancode` is equal to `16'he075`, then `up` is asserted (set to 1). Otherwise, `up` is deasserted (set to 0).\n\nIf the `scancode` does not match any of the specified arrow key scancodes, all outputs (`left`, `down`, `right`, and `up`) are deasserted (set to 0). The circuit effectively implements a lookup table where the `scancode` is the key, and the outputs are the values. The implementation consists of four parallel comparators, each checking for a specific scancode. The outputs of the comparators directly drive the output registers. The circuit is purely combinational, meaning that the outputs are a direct function of the current input. There is no internal state or memory."
}
```
```

