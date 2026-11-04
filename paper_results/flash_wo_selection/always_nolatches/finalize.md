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

- Analyze Report: 
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


- Others:{"web_research_result": "A PS/2 keyboard scancode processing circuit deals with interpreting the data stream from a PS/2 keyboard. The PS/2 interface uses two wires for communication: one for data and one for the clock signal. The clock signal indicates when the data is valid. The data is transmitted serially in 11-bit packets, including a start bit, 8 data bits, a parity bit, and a stop bit. The keyboard sends a scan code when a key is pressed (make code) and when it's released (break code).\n\nHere's a breakdown of the key aspects:\n\n**Concept and Working Principles:**\n\n*   **Serial Communication:** PS/2 keyboards communicate using a serial protocol, sending data bit by bit.\n*   **Scan Codes:** When a key is pressed or released, the keyboard sends a scan code to the host. These scan codes are unique to each key. Make codes indicate a key press, while break codes indicate a key release.\n*   **Make and Break Codes:** Pressing a key sends a \"make\" code, and releasing it sends a \"break\" code. The break code is often the make code preceded by a specific code (e.g., F0h).\n*   **Data Transmission:** Data is transmitted in 11-bit packets that include a start bit, 8 data bits (LSB first), an odd parity bit, and a stop bit. The data line is sampled on the falling edge of the clock signal.\n*   **PS/2 Controller:** A PS/2 controller handles the PS/2 protocol, managing data transmission, error detection, and timing. It provides an interface between the PS/2 device (keyboard/mouse) and the host system.\n*   **Scan Code Sets:** There are three scan code sets, but most keyboards use Scan Code Set 2.\n\n**Design Considerations:**\n\n*   **Clock Signal:** The keyboard generates a clock signal. The frequency typically ranges from 10 kHz to 16.7 kHz.\n*   **Data Validity:** The data must be valid on the falling edge of the clock signal.\n*   **Buffering:** Keyboard controllers often have an internal buffer to store keystroke data.\n*   **Error Handling:** The PS/2 protocol includes a parity bit for error detection. The keyboard can send a \"resend\" code (0xFE) if it detects an error.\n*   **Synchronization:** The PS/2 interface requires synchronization between the keyboard's clock and the system clock.\n*   **Debouncing:** It is necessary to debounce the PS/2 signals to filter out noise.\n\n**Additional points:**\n\n*   The host device is responsible for tracking the state of modifier keys like Shift to determine the correct case of characters.\n*   Some keys, like cursor control keys, send extended make codes, which are indicated by a preceding E0h.\n*   The keyboard may send commands to the host, and the host can send commands to the keyboard to control its behavior (e.g., setting LEDs).\n*   Scan codes represent the key position, not the character printed on the key, to accommodate international variations.\n*   A PS/2 keyboard interface often involves a state machine to manage the different stages of communication and data reception.\n"}
{"web_research_result": "The PS/2 keyboard sends scan codes when a key is pressed (make code) or released (break code). Most make codes are a single byte, but some extended keys, like the keypad \"/\", consist of a two-byte sequence starting with `0xE0`. Break codes for single-byte codes consist of `0xF0` followed by the make code. Extended keys have break codes consisting of `0xE0`, `0xF0`, and the key's code. The PS/2 protocol requires two pins for communication: CLK and DATA. The keyboard triggers the clock at 10-16.7 kHz, and data is sent on the falling edge of the PS/2 clock. The data is sent as an 11-bit packet containing a start bit, 8 data bits, an odd parity bit, and a stop bit.\n\nHere's how to approach the Verilog implementation for recognizing arrow key scancodes:\n\n1.  **PS/2 Scan Codes for Arrow Keys**: The specific scan codes for arrow keys are:\n    *   Left Arrow: `E0 6B`\n    *   Down Arrow: `E0 72`\n    *   Right Arrow: `E0 74`\n    *   Up Arrow: `E0 75`\n\n2.  **Module Definition**: Use the provided module definition:\n\n    ```verilog\n    module top_module (\n    input [15:0] scancode,\n    output reg left,\n    output reg down,\n    output reg right,\n    output reg up\n    );\n    ```\n\n3.  **Logic Implementation**: Implement the logic to assert the correct output based on the input `scancode`. This can be done using a `case` statement or `if-elseif` statements.\n\n4.  **Make and Break Codes**: The keyboard sends a make code when a key is pressed and a break code when it's released. For the arrow keys, you'll likely be interested in the make codes.\n\n5.  **State Machine**: Consider using a state machine to decode the serial PS/2 data. The CPLD monitors the PS/2 clock line, and as it toggles, scan codes are shifted into a register.\n\n6.  **Clock Domain**: Treat the PS/2 clock as another input pin and sample it from the CPU clock domain.\n\n7.  **Receiver Module**: Encapsulate the PS/2 protocol into a receiver module with an interface that includes a data output and a signal indicating data availability:\n\n    ```verilog\n    module ps2_rx (\n    input wire clk,\n    reset,\n    input wire ps2d, //PS2 data\n    input wire ps2c, //PS2 clock\n    input wire rx_en, //receiver enable\n    output reg rx_done_tick, //signal that data is available\n    output wire [7:0] dout //PS2 scancode\n    );\n    ```\n\n8.  **Key Press Handling**: Add a module to handle key presses, with an output to indicate make or break codes.\n\n9.  **Scan Code Sets**: Be aware of the different scan code sets. Scan Code Set 2 is often the default.\n\n10. **Data Transmission**: The keyboard transmits data serially, with the data valid on the falling edge of the clock. It sends an 11-bit word with a start bit, 8 data bits, a parity bit, and a stop bit.\n"}
{"web_research_result": "The Verilog case statement is a versatile construct for implementing conditional branching in digital circuit design. It allows you to select a block of code to execute based on the value of a given expression. The case statement is commonly used to create multiplexers and decoders.\n\nWhen using a case statement, you specify an input signal to monitor and evaluate. The value of this signal is then compared with the values specified in each branch of the case statement. Once a match is found for the input signal value, the branch associated with that value will execute.\n\nThe basic syntax of a case statement includes a case statement header, a case expression, a case item, a case item statement, and a case default. The case statement header consists of the `case`, `casez`, or `casex` keyword followed by the case expression. The case expression is the expression in parentheses immediately following the case keyword. The case item is the expression that is compared against the case expression. The case item statement is one or more statements that are executed if the case item matches the current case expression. The case default is optional, but can include statements to be executed if none of the defined case items match the current case expression.\n\nThere are three versions of the case statement in Verilog: `case`, `casez`, and `casex`. The `casez` statement allows \"Z\" and \"?\" to be treated as don't care values in either the case expression and/or the case item when doing case comparison. The `casex` statement considers all x and z values as don't care. It is generally recommended to use \"?\" characters instead of \"Z\" characters in the case item to indicate don't care bits.\n\nHere are some guidelines for using case statements in Verilog:\n\n*   Ensure that case statements are parallel, meaning only one case item evaluates to \"true\" for a given case expression.\n*   Include a case default to ensure the case statement is \"full\", meaning there is a case item for any case expression.\n*   Place the case default last, even though the Verilog standard does not require it.\n*   When coding a case statement with \"don't cares,\" use a casez statement and use \"?\" characters instead of \"z\" characters in the case items to indicate \"don't care\" bits.\n*   Do not use casex for synthesizable code.\n*   Review all synthesis case-statement reports.\n*   Avoid using the Synopsys directives \"full\\_case\" and/or \"parallel\\_case\" with any case statements.\n\nThe case statement is used inside a procedural block (always or initial block). If there is only one statement for a case statement, you can directly write the code. If there are multiple statements for a case statement, the entire if-else statement must be enclosed within `begin` and `end` keywords.\n"}
{"web_research_result": "A PS/2 keyboard communicates using scan codes, which are sets of codes that indicate when a key is pressed, repeated, or released. There are three scan code sets, with Scan Code Set 2 being the default for modern keyboards.\n\n**Scan Codes**\nWhen a key is pressed, the keyboard transmits a \"make code\". Most make codes are a single byte, but some extended keys use a two-byte sequence starting with `0xE0`. If a key is held down, the make code is repeatedly sent. When a key is released, a \"break code\" is transmitted. For single-byte make codes, the break code is `0xF0` followed by the make code. Extended keys have break codes of `0xE0`, `0xF0`, and then the key's code.\n\n**PS/2 Protocol**\nThe PS/2 keyboard uses a serial communication protocol. The keyboard transmits data in a clocked serial format, including a start bit, 8 data bits (LSB first), an odd parity bit, and a stop bit. The clock signal is active only during data transmission, typically ranging from 10 to 30 kHz. Data should be read on the falling edge of the clock.\n\n**Commands**\nThe PS/2 keyboard accepts commands from the host. Commands are single bytes, and some require additional data bytes. The keyboard responds with an ACK (0xFA) to acknowledge a command or Resend (0xFE) if there was an error.\n\nBased on the search results, here's information relevant to the user's task of building a circuit to process scancodes:\n\n*   **Make and Break Codes**: When a key is pressed, a make code is sent; when released, a break code is sent.\n*   **Extended Keys**: Some keys, like arrow keys, have extended make codes (e.g., `0xE0` followed by the key's specific code).\n*   **Scan Code Sets**: Modern keyboards default to Scan Code Set 2.\n*   **Serial Communication**: PS/2 uses a serial protocol with a clock and data line. Data is valid on the falling edge of the clock signal.\n\nGiven this information, the Verilog code provided by the user should function correctly, assuming the keyboard is using Scan Code Set 2 and the circuit correctly interprets the two-byte scancodes.\n"}

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
  "header": "The top module header definition is:\n\n```verilog\nmodule top_module (\n input [15:0] scancode,\n output reg left,\n output reg down,\n output reg right,\n output reg up\n);\n```\n\nThis module, `top_module`, takes a 16-bit input `scancode` and produces four 1-bit outputs: `left`, `down`, `right`, and `up`. These outputs indicate whether the received `scancode` corresponds to a specific arrow key press on a PS/2 keyboard. The outputs are declared as `reg` because they are assigned values within an `always` block (though this specification focuses solely on the combinational logic aspect, and the `reg` declaration is a consequence of typical Verilog coding style for such logic).",
  "combinational_logic_function": "The combinational logic function maps the 16-bit `scancode` input to the four arrow key outputs. The logic operates as a decoder, where specific `scancode` values activate corresponding output signals. The function can be described as follows:\n\n*   `left` = 1 if `scancode` == 16'he06b, otherwise `left` = 0.\n*   `down` = 1 if `scancode` == 16'he072, otherwise `down` = 0.\n*   `right` = 1 if `scancode` == 16'he074, otherwise `right` = 0.\n*   `up` = 1 if `scancode` == 16'he075, otherwise `up` = 0.\n\nThis can be implemented using a case statement or a series of if-else if statements. The logic organization is straightforward: the input `scancode` is compared against a set of predefined values, and the corresponding output is asserted if a match is found. No operator sharing or resource utilization strategies are explicitly defined at this level of abstraction. The signal flow is direct, from the input `scancode` to the output signals. There is no output multiplexing or selection logic beyond the basic decoding function.",
  "enhanced_combinational_description": "This specification details a combinational logic circuit designed to decode PS/2 keyboard scancodes and identify arrow key presses. The circuit, named `top_module`, receives a 16-bit input `scancode` representing the last two bytes of a PS/2 scancode. Based on the value of `scancode`, the circuit asserts one of four output signals: `left`, `down`, `right`, or `up`, indicating the corresponding arrow key has been pressed. If the `scancode` does not match any of the defined arrow key scancodes, all output signals remain deasserted.\n\nThe specific scancode mappings are as follows:\n\n*   `scancode` = 16'he06b: The `left` output is asserted (set to 1), indicating the left arrow key was pressed. All other outputs (`down`, `right`, `up`) are deasserted (set to 0).\n*   `scancode` = 16'he072: The `down` output is asserted (set to 1), indicating the down arrow key was pressed. All other outputs (`left`, `right`, `up`) are deasserted (set to 0).\n*   `scancode` = 16'he074: The `right` output is asserted (set to 1), indicating the right arrow key was pressed. All other outputs (`left`, `down`, `up`) are deasserted (set to 0).\n*   `scancode` = 16'he075: The `up` output is asserted (set to 1), indicating the up arrow key was pressed. All other outputs (`left`, `down`, `right`) are deasserted (set to 0).\n*   For any other value of `scancode`, all outputs (`left`, `down`, `right`, `up`) are deasserted (set to 0).\n\nThe circuit's functionality can be implemented using a case statement or a series of if-else if statements. The outputs are mutually exclusive; only one output can be asserted at any given time, or none if the input scancode does not match any of the specified arrow key scancodes. The circuit is purely combinational, meaning the outputs are a direct function of the current input `scancode` value. There is no internal state or memory. The outputs are registered, which is a common practice in digital design, but the core logic remains combinational. The registered outputs ensure a clean and stable output signal."
}
```
```

