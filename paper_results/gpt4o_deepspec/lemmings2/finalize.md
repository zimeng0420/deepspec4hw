#  Task: lemmings2

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
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	output walk_left,
	output walk_right,
	output aaah
);

- Analyze Report: Top_Analyze="Analyze the task's header, ports, and overall behavior, highlighting how each key port interacts with the specified functionality described in the task." Topic_Analyze='Provide a structured, aggregated answer for each research query by synthesizing the problem description with relevant web-researched findings, ensuring a precise and focused analysis of the research topic.' Solving_Strategies='Outline the overall reasoning strategies and detailed step-by-step methodology, explicitly mapping how each reasoning step relates to the top-level module and its sub-modules.'
- Original Task Description: User: SEQ
The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. 
// In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say "aaah!". When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), or when the ground reappears while still falling, also does not affect the walking direction.
// Implement a Moore state machine that models this behaviour. areset is positive edge triggered asynchronous reseting the Lemming machine to walk left.
module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	output walk_left,
	output walk_right,
	output aaah
);


- Others:{"web_research_result": "A Moore state machine is a finite-state machine (FSM) where the output depends only on the current state of the machine. The input to a Moore machine influences the next state.\n\nKey aspects of Moore state machines:\n*   **Output Determination**: The output is solely a function of the current state.\n*   **Formal Definition**: A Moore machine can be defined as a 6-tuple: (Q, Σ, q0, Δ, δ, λ), where:\n    *   Q is a finite set of states.\n    *   q0 is the initial state.\n    *   Σ is the input alphabet.\n    *   Δ is the output alphabet.\n    *   δ is the transition function mapping Q × Σ → Q.\n    *   λ is the output function mapping Q → Δ.\n*   **Clocked Sequential Systems**: Digital electronic systems are often designed as clocked sequential systems, a restricted form of the Moore machine where state changes occur only with a global clock signal.\n*   **Hardware Implementation**: Moore machines can be implemented using block RAM for the next state logic and state register, and distributed RAM as a lookup table for output logic.\n\n**Moore vs. Mealy State Machines**\n\nThe primary distinction lies in how the output is determined:\n\n*   **Moore Machine**: Output depends only on the current state.\n*   **Mealy Machine**: Output depends on both the current state and the current input.\n\n| Aspect          | Moore Machine                                  | Mealy Machine                                            |\n| --------------- | ---------------------------------------------- | -------------------------------------------------------- |\n| Output          | Depends only on the current state | Depends on both current state and input   |\n| States          | Generally, more states are required.        | Generally, fewer states are required.                |\n| Reaction to Inputs | Slower response to input changes.          | Faster response to input changes.                    |\n| Response Time   | Reacts one clock cycle later.              | Reacts in the same clock cycle.                      |\n"}
{"web_research_result": "When designing a finite state machine (FSM) to handle asynchronous resets, here's what you should consider:\n\n*   **Asynchronous vs. Synchronous Resets**:\n    *   **Asynchronous Reset**: The reset signal immediately affects the state of the FSM, regardless of the clock signal. This is useful for bringing the FSM to a known state during power-up or when the clock isn't running.\n    *   **Synchronous Reset**: The reset is synchronized with the clock signal, meaning the FSM resets only on the active edge of the clock.\n\n*   **Asynchronous Reset Design Considerations**:\n\n    *   **Priority**: In asynchronous state machines, the reset signal takes precedence over the clock. The output state changes as soon as the reset is asserted.\n    *   **Clock Availability**: Use an asynchronous reset if the clock isn't guaranteed to be running during power-up. This allows you to set the FSM to a known state even without a clock.\n    *   **Metastability**: Be mindful of metastability issues when designing with asynchronous resets, especially concerning the rise time of the asynchronous signal. Ensure you follow guidelines for generating a clean asynchronous signal to avoid these problems.\n    *   **Reset State**: Design your FSM to have a defined reset state. When the reset is activated, the FSM should enter this state. You can achieve this using the reset and preset lines of D flip-flops.\n    *   **Initialization**: Ensure your FSM starts in a known state after reset. If your reset state requires a specific code (e.g., 00), the reset button can handle it. However, if your start state requires a different code (e.g., 100), you might need to use preset lines on flip-flops.\n\n*   **Verilog Implementation**:\n\n    *   When using Verilog, be aware of how asynchronous resets are handled, particularly with regards to output assignments.\n    *   If you're using a single `always` block, the outputs might be registered (clocked). Ensure these output registers are also asynchronously reset within the same `always` block. Forgetting to do so can lead to the state register resetting asynchronously while the output registers remain in a hold state.\n\n*   **Reset Synchronizers**:\n\n    *   Asynchronous resets often require synchronization to prevent issues related to asynchronous assertion and deassertion.\n    *   A reset synchronizer ensures the reset deassertion is synchronized with the clock domain. This usually involves using a couple of flip-flops to synchronize the reset signal.\n\n*   **Potential Issues**:\n\n    *   **Glitches**: Asynchronous resets can be sensitive to short duration spurious signals or glitches, potentially causing unintended resets.\n    *   **Minimum Width**: Ensure the reset signal meets a minimum pulse width requirement.\n"}
{"web_research_result": "Implementing state transitions based on multiple input conditions in Verilog often involves using a Finite State Machine (FSM). Here's a summary of best practices for this:\n\n*   **FSM Design:** FSMs are mathematical models used to design digital circuits exhibiting specific behaviors. They can be Moore or Mealy machines.\n\n    *   **Moore Machine:** The output depends solely on the current state.\n    *   **Mealy Machine:** The output depends on both the current state and the input.\n*   **Verilog Coding:**\n    *   Use `case` statements or `if-else` structures to describe the logic within a state machine. Enumerate all possible combinations of current state and inputs to specify the next state and outputs.\n    *   A single `case` statement might be preferred for Mealy machines where outputs depend on the state transition.\n*   **State Definition:**\n    *   Define states using an `enum`.\n    *   Use parameters to name each of your states. This makes the code more readable (e.g., `IDLE` instead of `2'b10`).\n*   **Sequential Logic:** Use non-blocking assignments (`<=`) within `always` blocks for sequential logic to ensure accurate simulation of the resulting logic. Avoid using `#1` delays in RTL code.\n*   **Input Handling:** Read sensor inputs to determine state transitions.\n*   **Output Logic:** Define outputs based on the current state and inputs. Consider registering module outputs to meet timing goals and avoid glitches.\n*   **Reset Signal:** Provide a reset signal to initialize all internal variables.\n*   **Edge Detection:** Use edge detectors to detect rising or falling edges of a signal.\n    *   **Falling Edge Detector:** Detects when a signal changes from high to low.\n*   **Coding Style:**\n    *   If many outputs are only asserted in a few states, define default output values and then modify them within specific states.\n    *   For real-world product development, prioritize code maintainability.\n*   **State Transition Diagrams:** Use state transition diagrams to visualize the FSM.\n"}
{"web_research_result": "A finite state machine (FSM) is a computational model that can be implemented in hardware or software. It is an abstract machine that can exist in only one of a finite number of states at any given time. The FSM can change from one state to another in response to inputs; this change is called a transition. FSMs are used for creating sequential logic and some computer programs and can be applied to problem solving in mathematics, games, linguistics, and artificial intelligence.\n\nHere's how to approach modeling the falling state and reactivation within a Finite State Machine (FSM) for the Lemmings game:\n\n**Core Concepts**\n\n*   **States:** The FSM has a finite number of states. The Lemmings FSM includes `walking_left`, `walking_right`, and `falling`.\n*   **Transitions:** Transitions occur when specific conditions are met. For the Lemmings, these conditions include hitting an obstacle (`bump_left`, `bump_right`) or the ground disappearing (`ground = 0`).\n*   **Inputs:** Inputs trigger the transitions. The Lemmings FSM uses `clk`, `areset`, `bump_left`, `bump_right`, and `ground` as inputs.\n*   **Outputs:** Outputs are the actions or behaviors that the FSM exhibits based on its current state. The Lemmings FSM has `walk_left`, `walk_right`, and `aaah` as outputs.\n\n**Modeling the Falling State**\n\n1.  **Introduce a `falling` State:** When `ground = 0`, the FSM transitions to the `falling` state. While in this state, the `aaah` output is asserted.\n2.  **Reactivation Conditions:** When `ground = 1` (the ground reappears), the FSM needs to transition back to either the `walking_left` or `walking_right` state. The Lemming resumes walking in the same direction as before the fall.\n\n**Additional Considerations**\n\n*   **Moore vs. Mealy Machines:** An FSM can be implemented as a Moore or Mealy machine. In a Moore machine, the outputs depend only on the current state. In a Mealy machine, the outputs depend on both the current state and the inputs.\n*   **Reset State:** An asynchronous reset (`areset`) is used to return the FSM to a known initial state (walking left in this case).\n*   **Ignoring Bumps During Fall:** Bumps received while falling do not change the walking direction. Bumps in the same cycle as ground disappearing or reappearing also don't affect the walking direction.\n*   **State Diagrams and Tables:** Use state diagrams and tables to visualize and define the FSM's behavior.\n*   **Hardware Implementation:** In digital circuits, FSMs can be built using programmable logic devices, logic gates, and flip-flops. A register stores the state variables, combinational logic determines the state transition, and another block of combinational logic determines the output.\n*   **Verilog Implementation:** Use `case` statements to describe the logic within the FSM. Enumerate all possible combinations of current state and inputs to specify the next state and outputs. Use non-blocking assignments (`<=`) in sequential logic blocks.\n"}
{"web_research_result": "When designing a finite state machine (FSM) with mutually exclusive output signals, several considerations are essential. The primary goal is to ensure that only one output is active at any given time, which is crucial for avoiding conflicts and ensuring predictable system behavior. Here's a breakdown of the key considerations:\n\n**1. State Definition and Encoding**\n*   **Clear State Definitions**: Each state in the FSM should represent a unique condition or mode of operation. The states must be defined clearly to ensure that the FSM's behavior is well understood and predictable.\n*   **State Encoding**: Choose an appropriate state encoding method. Common techniques include binary, one-hot, and Gray coding. One-hot encoding, where each state is represented by a single active bit, can simplify the output logic and guarantee mutually exclusive outputs. However, it may require more flip-flops. Binary encoding is more compact but might require more complex decoding logic.\n\n**2. Output Logic Implementation**\n\n*   **Moore vs. Mealy Machines**: Decide whether to use a Moore or Mealy machine. In a Moore machine, the outputs depend solely on the current state, simplifying output logic and inherently ensuring that outputs are mutually exclusive. In a Mealy machine, outputs depend on both the current state and the inputs, which can lead to more complex output logic and require careful design to maintain mutual exclusivity.\n*   **Output Decoding**: Implement the output logic to ensure that only one output is active for each state. This can be achieved through a decoder or a case statement in hardware description languages like Verilog or SystemVerilog. Using a case statement, you can explicitly define the output values for each state, ensuring that only one output is asserted at a time.\n*   **Default Assignments**: Assign default values to all outputs to ensure that they are deasserted unless explicitly activated by a specific state. This helps prevent unintended activation of multiple outputs.\n\n**3. Transition Design**\n\n*   **Mutually Exclusive Transitions**: Ensure that the transitions between states are mutually exclusive. For each state, only one transition should be possible for any given input condition. This prevents the FSM from entering multiple states simultaneously, which could lead to multiple active outputs.\n*   **Collectively Exhaustive Transitions**: For each state, define a transition for every possible input combination. This ensures that the FSM always has a defined next state, avoiding undefined behavior.\n*   **Guard Conditions**: Incorporate guard conditions to prevent illegal or unexpected transitions. These conditions act as checks that must be satisfied before a transition can occur, ensuring that the FSM only enters valid states.\n\n**4. Implementation Considerations**\n\n*   **HDL Coding**: Use clear and structured coding practices in Verilog or SystemVerilog. Employ case statements or other conditional constructs to explicitly define the outputs for each state.\n*   **Asynchronous vs Synchronous Outputs**: Be mindful of whether the outputs need to be synchronous or asynchronous. Moore machines have synchronous outputs, which change only with the clock edge. Mealy machines can have asynchronous outputs, which can change as soon as the inputs change. If synchronous outputs are required, ensure that the output logic is properly synchronized with the clock signal.\n*    **Minimization**: Reduce the number of states where possible to simplify the design and reduce the number of flip-flops required.\n\n**5. Verification and Testing**\n\n*   **Simulation**: Thoroughly simulate the FSM to verify its behavior under all possible input conditions. Check that the outputs are indeed mutually exclusive and that the FSM transitions correctly between states.\n*   **Formal Verification**: Use formal verification techniques to mathematically prove that the FSM meets its specifications, including the mutual exclusivity of outputs.\n*   **Testing**: Implement comprehensive testing procedures to validate the FSM's behavior in the target hardware environment.\n\nBy carefully considering these aspects, you can design a robust FSM with mutually exclusive output signals, ensuring reliable and predictable operation in your digital system.\n"}

Output Format:
Format your response as a JSON object with the following structure:

```json
{
  "header": "The top module header definition from module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	output walk_left,
	output walk_right,
	output aaah
);
, including the interface definition and their behavior.",

  "combinational_logic_function": "Describe how outputs derive from inputs (e.g., Boolean expressions, truth table patterns). Provide a systematic breakdown of the combinational logic structure optimized for performance and area. Include: logic organization with clear functional boundaries, signal flow optimization and critical path identification, operator sharing and resource utilization strategies, logic level balancing and delay equalization techniques, output multiplexing and selection logic organization.",

  "enhanced_combinational_description": "Comprehensive combinational logic specification derived from User: SEQ
The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. 
// In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say "aaah!". When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), or when the ground reappears while still falling, also does not affect the walking direction.
// Implement a Moore state machine that models this behaviour. areset is positive edge triggered asynchronous reseting the Lemming machine to walk left.
module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	output walk_left,
	output walk_right,
	output aaah
);

. All details must be comprehensive and tailored for LLM models."
}






```

## CMB Logic Summary

```
```json
{
  "header": "The top module header definition from module top_module (\n\tinput clk,\n\tinput areset,\n\tinput bump_left,\n\tinput bump_right,\n\tinput ground,\n\toutput walk_left,\n\toutput walk_right,\n\toutput aaah\n);\n\nThis module defines the interface for a combinational logic circuit that models the behavior of a Lemming in a 2D world. The inputs include:\n- `clk`: Clock signal (not relevant for combinational logic but part of the interface).\n- `areset`: Asynchronous reset signal to initialize the system to a known state (walking left).\n- `bump_left`: Indicates a collision on the left side.\n- `bump_right`: Indicates a collision on the right side.\n- `ground`: Indicates whether the ground is present (1) or absent (0).\n\nThe outputs include:\n- `walk_left`: Asserted (1) when the Lemming is walking left.\n- `walk_right`: Asserted (1) when the Lemming is walking right.\n- `aaah`: Asserted (1) when the Lemming is falling (ground = 0).",

  "combinational_logic_function": "The combinational logic determines the outputs (`walk_left`, `walk_right`, `aaah`) based on the current inputs (`bump_left`, `bump_right`, `ground`) and the previous state of the system. The logic is structured as follows:\n\n1. **Output Logic for Falling (`aaah`):**\n   - `aaah` is asserted (1) when `ground = 0`.\n   - Boolean expression: `aaah = ~ground`.\n\n2. **Output Logic for Walking Left (`walk_left`) and Walking Right (`walk_right`):**\n   - If `ground = 1` (Lemming is not falling):\n     - If `bump_left = 1`, the Lemming switches to walking right (`walk_right = 1`, `walk_left = 0`).\n     - If `bump_right = 1`, the Lemming switches to walking left (`walk_left = 1`, `walk_right = 0`).\n     - If both `bump_left` and `bump_right` are 1, the Lemming switches direction (toggle behavior).\n   - If `ground = 0` (Lemming is falling):\n     - The walking direction remains unchanged from the last known state before the fall.\n\n3. **Direction Preservation Logic:**\n   - When transitioning from falling (`ground = 0`) back to walking (`ground = 1`), the Lemming resumes walking in the same direction as before the fall.\n\n4. **Reset Logic (`areset`):**\n   - When `areset = 1`, the system initializes to the state where the Lemming is walking left (`walk_left = 1`, `walk_right = 0`, `aaah = 0`).\n\n**Critical Path Identification:**\n- The critical path involves evaluating the conditions for switching directions (`bump_left`, `bump_right`) and determining the output states (`walk_left`, `walk_right`, `aaah`).\n\n**Logic Organization:**\n- The logic is organized into three main blocks:\n  1. Falling detection (`aaah` output).\n  2. Direction switching based on bumps and ground presence.\n  3. Reset logic to initialize the system state.\n\n**Output Multiplexing:**\n- A multiplexer-like structure is used to select the appropriate walking direction based on the bump inputs and the ground signal.",

  "enhanced_combinational_description": "The combinational logic specification for the Lemming's behavior is derived from the problem description and is implemented as a Moore state machine. The outputs depend solely on the current state, which is determined by the inputs and the previous state. The detailed behavior is as follows:\n\n1. **State Definitions:**\n   - `Walking_Left`: The Lemming is walking left (`walk_left = 1`, `walk_right = 0`, `aaah = 0`).\n   - `Walking_Right`: The Lemming is walking right (`walk_left = 0`, `walk_right = 1`, `aaah = 0`).\n   - `Falling`: The Lemming is falling (`walk_left = 0`, `walk_right = 0`, `aaah = 1`).\n\n2. **State Transitions:**\n   - From `Walking_Left`:\n     - If `ground = 0`, transition to `Falling`.\n     - If `bump_left = 1`, transition to `Walking_Right`.\n     - If `bump_right = 1`, remain in `Walking_Left`.\n   - From `Walking_Right`:\n     - If `ground = 0`, transition to `Falling`.\n     - If `bump_right = 1`, transition to `Walking_Left`.\n     - If `bump_left = 1`, remain in `Walking_Right`.\n   - From `Falling`:\n     - If `ground = 1`, transition back to the previous walking state (`Walking_Left` or `Walking_Right`).\n\n3. **Output Logic:**\n   - The outputs are determined solely by the current state:\n     - `Walking_Left`: `walk_left = 1`, `walk_right = 0`, `aaah = 0`.\n     - `Walking_Right`: `walk_left = 0`, `walk_right = 1`, `aaah = 0`.\n     - `Falling`: `walk_left = 0`, `walk_right = 0`, `aaah = 1`.\n\n4. **Reset Behavior:**\n   - When `areset = 1`, the system initializes to the `Walking_Left` state (`walk_left = 1`, `walk_right = 0`, `aaah = 0`).\n\n5. **Combinational Logic Implementation:**\n   - The logic is implemented using Boolean expressions and conditional statements to evaluate the inputs (`bump_left`, `bump_right`, `ground`) and determine the next state and outputs.\n   - Example Boolean expressions:\n     - `next_state = (ground == 0) ? Falling : (bump_left ? Walking_Right : (bump_right ? Walking_Left : current_state));`\n     - `walk_left = (current_state == Walking_Left);`\n     - `walk_right = (current_state == Walking_Right);`\n     - `aaah = (current_state == Falling);`\n\n6. **Design Considerations:**\n   - The logic ensures that the outputs are mutually exclusive (only one of `walk_left`, `walk_right`, or `aaah` is asserted at any time).\n   - The direction is preserved during the falling state and restored when the ground reappears.\n   - The reset signal (`areset`) takes precedence over all other inputs to initialize the system to a known state.\n\nThis combinational logic specification provides a clear and systematic approach to implementing the Lemming's behavior in a purely combinational manner, ensuring correctness and predictability."
}
```
```

## Mindtrace Prompt

```
You are a senior hardware engineer with expertise in analyzing and clarifying ambiguous technical specifications.


Instructions:
Your goal is to make the research topic clear and unambiguous.
Perform analysis on the provided research topic to clarify misleading or unclear statements. Reconstruct the complete reasoning chain by filling in missing details and making well-grounded inferences.

Checklist for Mindtrace Analysis:
1. Extract unclear or misleading text from RESEARCH TOPIC as follows.
2. Explain why the text is ambiguous or problematic.
3. Infer the corrected meaning using context and domain knowledge.
4. Rebuild the research topic into a clear, complete description. 
5. Use the **mindtrace_schemas** structure to present findings. Each schema should include: original_text, misleading_rationale, corrected_inference, and confidence_level.

6. Think step by step.
RESEARCH TOPIC:
User: SEQ
The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. 
// In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say "aaah!". When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), or when the ground reappears while still falling, also does not affect the walking direction.
// Implement a Moore state machine that models this behaviour. areset is positive edge triggered asynchronous reseting the Lemming machine to walk left.
module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	output walk_left,
	output walk_right,
	output aaah
);



OUTPUT FORMAT:  
Return a valid JSON object following the structure below:  

{
  "mindtrace_schemas": [
    {
      "original_text": "Exact quote from the research topic that contains misleading or unclear information",
      "misleading_rationale": "Detailed explanation of why this text is misleading, incomplete, or ambiguous",
      "corrected_inference": "Accurate inference or interpretation that clarifies the intended meaning and makes the reasoning explicit",
      "confidence_level": "Value between 0 and 1 indicating certainty of the correction (e.g., 0.85)"
    }
  ],
  "mindtraced_research_topic": "The unambiguous and clear CoT of the given research topic"
}

```

## Mindtraced Research Topic

```
The game Lemmings involves critters with simple brains modeled using a finite state machine. In their 2D world, Lemmings can walk left or right, switching directions upon encountering obstacles. Specific rules govern their behavior when falling or interacting with the ground. A Moore state machine is to be implemented to accurately represent these behaviors, with areset initializing the Lemming to walk left.
```

## Timing Logic Prompt

```


Goal:
Analyze a sequential circuit from waveforms or spec. Focus on timing, registers, and event ordering. Treat all combinational logic as black boxes.

Rules:
- Keep it simple. Think step by step.
- Combinational logic is a black box
- Use exact port names from the task.
- Avoid vague/general terms ("all", "most", "generally").


Required output:
1. header analysis: analyze the module header, ports, and overall behavior.
1. Circuit type: e.g., Combinational / Sequential (posedge / negedge?).
2. Timing Dependency : Interface behavior with exact timing characteristics,Delay,initialization/reset.
3. Timing Logic Implementation: pure timing logic behaviour descriptions, number of registers, clock edge, non-blocking assignments, reg declarations.

Input Variables:

- research_topic: User: SEQ
The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. 
// In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say "aaah!". When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), or when the ground reappears while still falling, also does not affect the walking direction.
// Implement a Moore state machine that models this behaviour. areset is positive edge triggered asynchronous reseting the Lemming machine to walk left.
module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	output walk_left,
	output walk_right,
	output aaah
);


- mindtraced_research_topic: The game Lemmings involves critters with simple brains modeled using a finite state machine. In their 2D world, Lemmings can walk left or right, switching directions upon encountering obstacles. Specific rules govern their behavior when falling or interacting with the ground. A Moore state machine is to be implemented to accurately represent these behaviors, with areset initializing the Lemming to walk left.
- others optional: {"web_research_result": "A Moore state machine is a finite-state machine (FSM) where the output depends only on the current state of the machine. The input to a Moore machine influences the next state.\n\nKey aspects of Moore state machines:\n*   **Output Determination**: The output is solely a function of the current state.\n*   **Formal Definition**: A Moore machine can be defined as a 6-tuple: (Q, Σ, q0, Δ, δ, λ), where:\n    *   Q is a finite set of states.\n    *   q0 is the initial state.\n    *   Σ is the input alphabet.\n    *   Δ is the output alphabet.\n    *   δ is the transition function mapping Q × Σ → Q.\n    *   λ is the output function mapping Q → Δ.\n*   **Clocked Sequential Systems**: Digital electronic systems are often designed as clocked sequential systems, a restricted form of the Moore machine where state changes occur only with a global clock signal.\n*   **Hardware Implementation**: Moore machines can be implemented using block RAM for the next state logic and state register, and distributed RAM as a lookup table for output logic.\n\n**Moore vs. Mealy State Machines**\n\nThe primary distinction lies in how the output is determined:\n\n*   **Moore Machine**: Output depends only on the current state.\n*   **Mealy Machine**: Output depends on both the current state and the current input.\n\n| Aspect          | Moore Machine                                  | Mealy Machine                                            |\n| --------------- | ---------------------------------------------- | -------------------------------------------------------- |\n| Output          | Depends only on the current state | Depends on both current state and input   |\n| States          | Generally, more states are required.        | Generally, fewer states are required.                |\n| Reaction to Inputs | Slower response to input changes.          | Faster response to input changes.                    |\n| Response Time   | Reacts one clock cycle later.              | Reacts in the same clock cycle.                      |\n"}
{"web_research_result": "When designing a finite state machine (FSM) to handle asynchronous resets, here's what you should consider:\n\n*   **Asynchronous vs. Synchronous Resets**:\n    *   **Asynchronous Reset**: The reset signal immediately affects the state of the FSM, regardless of the clock signal. This is useful for bringing the FSM to a known state during power-up or when the clock isn't running.\n    *   **Synchronous Reset**: The reset is synchronized with the clock signal, meaning the FSM resets only on the active edge of the clock.\n\n*   **Asynchronous Reset Design Considerations**:\n\n    *   **Priority**: In asynchronous state machines, the reset signal takes precedence over the clock. The output state changes as soon as the reset is asserted.\n    *   **Clock Availability**: Use an asynchronous reset if the clock isn't guaranteed to be running during power-up. This allows you to set the FSM to a known state even without a clock.\n    *   **Metastability**: Be mindful of metastability issues when designing with asynchronous resets, especially concerning the rise time of the asynchronous signal. Ensure you follow guidelines for generating a clean asynchronous signal to avoid these problems.\n    *   **Reset State**: Design your FSM to have a defined reset state. When the reset is activated, the FSM should enter this state. You can achieve this using the reset and preset lines of D flip-flops.\n    *   **Initialization**: Ensure your FSM starts in a known state after reset. If your reset state requires a specific code (e.g., 00), the reset button can handle it. However, if your start state requires a different code (e.g., 100), you might need to use preset lines on flip-flops.\n\n*   **Verilog Implementation**:\n\n    *   When using Verilog, be aware of how asynchronous resets are handled, particularly with regards to output assignments.\n    *   If you're using a single `always` block, the outputs might be registered (clocked). Ensure these output registers are also asynchronously reset within the same `always` block. Forgetting to do so can lead to the state register resetting asynchronously while the output registers remain in a hold state.\n\n*   **Reset Synchronizers**:\n\n    *   Asynchronous resets often require synchronization to prevent issues related to asynchronous assertion and deassertion.\n    *   A reset synchronizer ensures the reset deassertion is synchronized with the clock domain. This usually involves using a couple of flip-flops to synchronize the reset signal.\n\n*   **Potential Issues**:\n\n    *   **Glitches**: Asynchronous resets can be sensitive to short duration spurious signals or glitches, potentially causing unintended resets.\n    *   **Minimum Width**: Ensure the reset signal meets a minimum pulse width requirement.\n"}
{"web_research_result": "Implementing state transitions based on multiple input conditions in Verilog often involves using a Finite State Machine (FSM). Here's a summary of best practices for this:\n\n*   **FSM Design:** FSMs are mathematical models used to design digital circuits exhibiting specific behaviors. They can be Moore or Mealy machines.\n\n    *   **Moore Machine:** The output depends solely on the current state.\n    *   **Mealy Machine:** The output depends on both the current state and the input.\n*   **Verilog Coding:**\n    *   Use `case` statements or `if-else` structures to describe the logic within a state machine. Enumerate all possible combinations of current state and inputs to specify the next state and outputs.\n    *   A single `case` statement might be preferred for Mealy machines where outputs depend on the state transition.\n*   **State Definition:**\n    *   Define states using an `enum`.\n    *   Use parameters to name each of your states. This makes the code more readable (e.g., `IDLE` instead of `2'b10`).\n*   **Sequential Logic:** Use non-blocking assignments (`<=`) within `always` blocks for sequential logic to ensure accurate simulation of the resulting logic. Avoid using `#1` delays in RTL code.\n*   **Input Handling:** Read sensor inputs to determine state transitions.\n*   **Output Logic:** Define outputs based on the current state and inputs. Consider registering module outputs to meet timing goals and avoid glitches.\n*   **Reset Signal:** Provide a reset signal to initialize all internal variables.\n*   **Edge Detection:** Use edge detectors to detect rising or falling edges of a signal.\n    *   **Falling Edge Detector:** Detects when a signal changes from high to low.\n*   **Coding Style:**\n    *   If many outputs are only asserted in a few states, define default output values and then modify them within specific states.\n    *   For real-world product development, prioritize code maintainability.\n*   **State Transition Diagrams:** Use state transition diagrams to visualize the FSM.\n"}
{"web_research_result": "A finite state machine (FSM) is a computational model that can be implemented in hardware or software. It is an abstract machine that can exist in only one of a finite number of states at any given time. The FSM can change from one state to another in response to inputs; this change is called a transition. FSMs are used for creating sequential logic and some computer programs and can be applied to problem solving in mathematics, games, linguistics, and artificial intelligence.\n\nHere's how to approach modeling the falling state and reactivation within a Finite State Machine (FSM) for the Lemmings game:\n\n**Core Concepts**\n\n*   **States:** The FSM has a finite number of states. The Lemmings FSM includes `walking_left`, `walking_right`, and `falling`.\n*   **Transitions:** Transitions occur when specific conditions are met. For the Lemmings, these conditions include hitting an obstacle (`bump_left`, `bump_right`) or the ground disappearing (`ground = 0`).\n*   **Inputs:** Inputs trigger the transitions. The Lemmings FSM uses `clk`, `areset`, `bump_left`, `bump_right`, and `ground` as inputs.\n*   **Outputs:** Outputs are the actions or behaviors that the FSM exhibits based on its current state. The Lemmings FSM has `walk_left`, `walk_right`, and `aaah` as outputs.\n\n**Modeling the Falling State**\n\n1.  **Introduce a `falling` State:** When `ground = 0`, the FSM transitions to the `falling` state. While in this state, the `aaah` output is asserted.\n2.  **Reactivation Conditions:** When `ground = 1` (the ground reappears), the FSM needs to transition back to either the `walking_left` or `walking_right` state. The Lemming resumes walking in the same direction as before the fall.\n\n**Additional Considerations**\n\n*   **Moore vs. Mealy Machines:** An FSM can be implemented as a Moore or Mealy machine. In a Moore machine, the outputs depend only on the current state. In a Mealy machine, the outputs depend on both the current state and the inputs.\n*   **Reset State:** An asynchronous reset (`areset`) is used to return the FSM to a known initial state (walking left in this case).\n*   **Ignoring Bumps During Fall:** Bumps received while falling do not change the walking direction. Bumps in the same cycle as ground disappearing or reappearing also don't affect the walking direction.\n*   **State Diagrams and Tables:** Use state diagrams and tables to visualize and define the FSM's behavior.\n*   **Hardware Implementation:** In digital circuits, FSMs can be built using programmable logic devices, logic gates, and flip-flops. A register stores the state variables, combinational logic determines the state transition, and another block of combinational logic determines the output.\n*   **Verilog Implementation:** Use `case` statements to describe the logic within the FSM. Enumerate all possible combinations of current state and inputs to specify the next state and outputs. Use non-blocking assignments (`<=`) in sequential logic blocks.\n"}
{"web_research_result": "When designing a finite state machine (FSM) with mutually exclusive output signals, several considerations are essential. The primary goal is to ensure that only one output is active at any given time, which is crucial for avoiding conflicts and ensuring predictable system behavior. Here's a breakdown of the key considerations:\n\n**1. State Definition and Encoding**\n*   **Clear State Definitions**: Each state in the FSM should represent a unique condition or mode of operation. The states must be defined clearly to ensure that the FSM's behavior is well understood and predictable.\n*   **State Encoding**: Choose an appropriate state encoding method. Common techniques include binary, one-hot, and Gray coding. One-hot encoding, where each state is represented by a single active bit, can simplify the output logic and guarantee mutually exclusive outputs. However, it may require more flip-flops. Binary encoding is more compact but might require more complex decoding logic.\n\n**2. Output Logic Implementation**\n\n*   **Moore vs. Mealy Machines**: Decide whether to use a Moore or Mealy machine. In a Moore machine, the outputs depend solely on the current state, simplifying output logic and inherently ensuring that outputs are mutually exclusive. In a Mealy machine, outputs depend on both the current state and the inputs, which can lead to more complex output logic and require careful design to maintain mutual exclusivity.\n*   **Output Decoding**: Implement the output logic to ensure that only one output is active for each state. This can be achieved through a decoder or a case statement in hardware description languages like Verilog or SystemVerilog. Using a case statement, you can explicitly define the output values for each state, ensuring that only one output is asserted at a time.\n*   **Default Assignments**: Assign default values to all outputs to ensure that they are deasserted unless explicitly activated by a specific state. This helps prevent unintended activation of multiple outputs.\n\n**3. Transition Design**\n\n*   **Mutually Exclusive Transitions**: Ensure that the transitions between states are mutually exclusive. For each state, only one transition should be possible for any given input condition. This prevents the FSM from entering multiple states simultaneously, which could lead to multiple active outputs.\n*   **Collectively Exhaustive Transitions**: For each state, define a transition for every possible input combination. This ensures that the FSM always has a defined next state, avoiding undefined behavior.\n*   **Guard Conditions**: Incorporate guard conditions to prevent illegal or unexpected transitions. These conditions act as checks that must be satisfied before a transition can occur, ensuring that the FSM only enters valid states.\n\n**4. Implementation Considerations**\n\n*   **HDL Coding**: Use clear and structured coding practices in Verilog or SystemVerilog. Employ case statements or other conditional constructs to explicitly define the outputs for each state.\n*   **Asynchronous vs Synchronous Outputs**: Be mindful of whether the outputs need to be synchronous or asynchronous. Moore machines have synchronous outputs, which change only with the clock edge. Mealy machines can have asynchronous outputs, which can change as soon as the inputs change. If synchronous outputs are required, ensure that the output logic is properly synchronized with the clock signal.\n*    **Minimization**: Reduce the number of states where possible to simplify the design and reduce the number of flip-flops required.\n\n**5. Verification and Testing**\n\n*   **Simulation**: Thoroughly simulate the FSM to verify its behavior under all possible input conditions. Check that the outputs are indeed mutually exclusive and that the FSM transitions correctly between states.\n*   **Formal Verification**: Use formal verification techniques to mathematically prove that the FSM meets its specifications, including the mutual exclusivity of outputs.\n*   **Testing**: Implement comprehensive testing procedures to validate the FSM's behavior in the target hardware environment.\n\nBy carefully considering these aspects, you can design a robust FSM with mutually exclusive output signals, ensuring reliable and predictable operation in your digital system.\n"}

Output Format:
```json
{
  "header": "header of the given task",
  "Interface Behavior": "Specific port timing characteristics with exact moments",
  "Timing Dependency": "Critical paths with specific signal names and timing values",
  "Timing logic": "PURE Timing logic & behavior analysis while taking combinational logic as black boxes",

}
```


```

## Timing Logic Summary

```
```json
{
  "header": "The module `top_module` implements a Moore finite state machine (FSM) to model the behavior of a Lemming in a 2D world. The FSM has the following ports: `clk` (clock input), `areset` (asynchronous reset input), `bump_left` (input indicating an obstacle on the left), `bump_right` (input indicating an obstacle on the right), `ground` (input indicating whether the ground is present), and outputs `walk_left`, `walk_right`, and `aaah` to represent the Lemming's current state. The FSM starts in the `walk_left` state upon reset and transitions between states based on the input conditions.",
  "Interface Behavior": {
    "clk": "The FSM transitions between states on the positive edge of the clock signal.",
    "areset": "Asynchronous reset signal, active high. When asserted, the FSM immediately transitions to the `walk_left` state regardless of the clock.",
    "bump_left": "Input signal that triggers a transition to the `walk_right` state if the Lemming is walking left and encounters an obstacle on the left.",
    "bump_right": "Input signal that triggers a transition to the `walk_left` state if the Lemming is walking right and encounters an obstacle on the right.",
    "ground": "Input signal that determines whether the Lemming is walking or falling. When `ground=0`, the FSM transitions to the `falling` state, and when `ground=1`, the FSM resumes walking in the previous direction."
  },
  "Timing Dependency": {
    "areset": "The asynchronous reset (`areset`) takes precedence over all other inputs and immediately sets the FSM to the `walk_left` state.",
    "clk": "State transitions occur on the positive edge of the clock signal. The FSM's outputs (`walk_left`, `walk_right`, `aaah`) are updated synchronously with the clock.",
    "ground": "The `ground` signal is sampled on the clock edge. If `ground=0`, the FSM transitions to the `falling` state on the next clock edge. If `ground=1` while in the `falling` state, the FSM transitions back to the previous walking state on the next clock edge.",
    "bump_left/bump_right": "The `bump_left` and `bump_right` signals are sampled on the clock edge. If either signal is asserted while the Lemming is walking, the FSM transitions to the opposite walking state on the next clock edge."
  },
  "Timing logic": {
    "State Register": "The FSM uses a state register to store the current state. The state register is updated on the positive edge of the clock signal.",
    "Number of States": "The FSM has three states: `walk_left`, `walk_right`, and `falling`.",
    "Output Logic": "The outputs (`walk_left`, `walk_right`, `aaah`) are determined solely by the current state, as this is a Moore machine. Outputs are updated synchronously with the clock.",
    "Non-blocking Assignments": "State transitions and output updates are implemented using non-blocking assignments (`<=`) to ensure correct sequential behavior.",
    "Reset Behavior": "When `areset` is asserted, the state register is asynchronously set to the `walk_left` state, and the outputs are updated accordingly."
  }
}
```
```

## Final Answer

```
Pure CMB Logic :
```json
{
  "header": "The top module header definition from module top_module (\n\tinput clk,\n\tinput areset,\n\tinput bump_left,\n\tinput bump_right,\n\tinput ground,\n\toutput walk_left,\n\toutput walk_right,\n\toutput aaah\n);\n\nThis module defines the interface for a combinational logic circuit that models the behavior of a Lemming in a 2D world. The inputs include:\n- `clk`: Clock signal (not relevant for combinational logic but part of the interface).\n- `areset`: Asynchronous reset signal to initialize the system to a known state (walking left).\n- `bump_left`: Indicates a collision on the left side.\n- `bump_right`: Indicates a collision on the right side.\n- `ground`: Indicates whether the ground is present (1) or absent (0).\n\nThe outputs include:\n- `walk_left`: Asserted (1) when the Lemming is walking left.\n- `walk_right`: Asserted (1) when the Lemming is walking right.\n- `aaah`: Asserted (1) when the Lemming is falling (ground = 0).",

  "combinational_logic_function": "The combinational logic determines the outputs (`walk_left`, `walk_right`, `aaah`) based on the current inputs (`bump_left`, `bump_right`, `ground`) and the previous state of the system. The logic is structured as follows:\n\n1. **Output Logic for Falling (`aaah`):**\n   - `aaah` is asserted (1) when `ground = 0`.\n   - Boolean expression: `aaah = ~ground`.\n\n2. **Output Logic for Walking Left (`walk_left`) and Walking Right (`walk_right`):**\n   - If `ground = 1` (Lemming is not falling):\n     - If `bump_left = 1`, the Lemming switches to walking right (`walk_right = 1`, `walk_left = 0`).\n     - If `bump_right = 1`, the Lemming switches to walking left (`walk_left = 1`, `walk_right = 0`).\n     - If both `bump_left` and `bump_right` are 1, the Lemming switches direction (toggle behavior).\n   - If `ground = 0` (Lemming is falling):\n     - The walking direction remains unchanged from the last known state before the fall.\n\n3. **Direction Preservation Logic:**\n   - When transitioning from falling (`ground = 0`) back to walking (`ground = 1`), the Lemming resumes walking in the same direction as before the fall.\n\n4. **Reset Logic (`areset`):**\n   - When `areset = 1`, the system initializes to the state where the Lemming is walking left (`walk_left = 1`, `walk_right = 0`, `aaah = 0`).\n\n**Critical Path Identification:**\n- The critical path involves evaluating the conditions for switching directions (`bump_left`, `bump_right`) and determining the output states (`walk_left`, `walk_right`, `aaah`).\n\n**Logic Organization:**\n- The logic is organized into three main blocks:\n  1. Falling detection (`aaah` output).\n  2. Direction switching based on bumps and ground presence.\n  3. Reset logic to initialize the system state.\n\n**Output Multiplexing:**\n- A multiplexer-like structure is used to select the appropriate walking direction based on the bump inputs and the ground signal.",

  "enhanced_combinational_description": "The combinational logic specification for the Lemming's behavior is derived from the problem description and is implemented as a Moore state machine. The outputs depend solely on the current state, which is determined by the inputs and the previous state. The detailed behavior is as follows:\n\n1. **State Definitions:**\n   - `Walking_Left`: The Lemming is walking left (`walk_left = 1`, `walk_right = 0`, `aaah = 0`).\n   - `Walking_Right`: The Lemming is walking right (`walk_left = 0`, `walk_right = 1`, `aaah = 0`).\n   - `Falling`: The Lemming is falling (`walk_left = 0`, `walk_right = 0`, `aaah = 1`).\n\n2. **State Transitions:**\n   - From `Walking_Left`:\n     - If `ground = 0`, transition to `Falling`.\n     - If `bump_left = 1`, transition to `Walking_Right`.\n     - If `bump_right = 1`, remain in `Walking_Left`.\n   - From `Walking_Right`:\n     - If `ground = 0`, transition to `Falling`.\n     - If `bump_right = 1`, transition to `Walking_Left`.\n     - If `bump_left = 1`, remain in `Walking_Right`.\n   - From `Falling`:\n     - If `ground = 1`, transition back to the previous walking state (`Walking_Left` or `Walking_Right`).\n\n3. **Output Logic:**\n   - The outputs are determined solely by the current state:\n     - `Walking_Left`: `walk_left = 1`, `walk_right = 0`, `aaah = 0`.\n     - `Walking_Right`: `walk_left = 0`, `walk_right = 1`, `aaah = 0`.\n     - `Falling`: `walk_left = 0`, `walk_right = 0`, `aaah = 1`.\n\n4. **Reset Behavior:**\n   - When `areset = 1`, the system initializes to the `Walking_Left` state (`walk_left = 1`, `walk_right = 0`, `aaah = 0`).\n\n5. **Combinational Logic Implementation:**\n   - The logic is implemented using Boolean expressions and conditional statements to evaluate the inputs (`bump_left`, `bump_right`, `ground`) and determine the next state and outputs.\n   - Example Boolean expressions:\n     - `next_state = (ground == 0) ? Falling : (bump_left ? Walking_Right : (bump_right ? Walking_Left : current_state));`\n     - `walk_left = (current_state == Walking_Left);`\n     - `walk_right = (current_state == Walking_Right);`\n     - `aaah = (current_state == Falling);`\n\n6. **Design Considerations:**\n   - The logic ensures that the outputs are mutually exclusive (only one of `walk_left`, `walk_right`, or `aaah` is asserted at any time).\n   - The direction is preserved during the falling state and restored when the ground reappears.\n   - The reset signal (`areset`) takes precedence over all other inputs to initialize the system to a known state.\n\nThis combinational logic specification provides a clear and systematic approach to implementing the Lemming's behavior in a purely combinational manner, ensuring correctness and predictability."
}
```

 With Timing Logic Summary:
```json
{
  "header": "The module `top_module` implements a Moore finite state machine (FSM) to model the behavior of a Lemming in a 2D world. The FSM has the following ports: `clk` (clock input), `areset` (asynchronous reset input), `bump_left` (input indicating an obstacle on the left), `bump_right` (input indicating an obstacle on the right), `ground` (input indicating whether the ground is present), and outputs `walk_left`, `walk_right`, and `aaah` to represent the Lemming's current state. The FSM starts in the `walk_left` state upon reset and transitions between states based on the input conditions.",
  "Interface Behavior": {
    "clk": "The FSM transitions between states on the positive edge of the clock signal.",
    "areset": "Asynchronous reset signal, active high. When asserted, the FSM immediately transitions to the `walk_left` state regardless of the clock.",
    "bump_left": "Input signal that triggers a transition to the `walk_right` state if the Lemming is walking left and encounters an obstacle on the left.",
    "bump_right": "Input signal that triggers a transition to the `walk_left` state if the Lemming is walking right and encounters an obstacle on the right.",
    "ground": "Input signal that determines whether the Lemming is walking or falling. When `ground=0`, the FSM transitions to the `falling` state, and when `ground=1`, the FSM resumes walking in the previous direction."
  },
  "Timing Dependency": {
    "areset": "The asynchronous reset (`areset`) takes precedence over all other inputs and immediately sets the FSM to the `walk_left` state.",
    "clk": "State transitions occur on the positive edge of the clock signal. The FSM's outputs (`walk_left`, `walk_right`, `aaah`) are updated synchronously with the clock.",
    "ground": "The `ground` signal is sampled on the clock edge. If `ground=0`, the FSM transitions to the `falling` state on the next clock edge. If `ground=1` while in the `falling` state, the FSM transitions back to the previous walking state on the next clock edge.",
    "bump_left/bump_right": "The `bump_left` and `bump_right` signals are sampled on the clock edge. If either signal is asserted while the Lemming is walking, the FSM transitions to the opposite walking state on the next clock edge."
  },
  "Timing logic": {
    "State Register": "The FSM uses a state register to store the current state. The state register is updated on the positive edge of the clock signal.",
    "Number of States": "The FSM has three states: `walk_left`, `walk_right`, and `falling`.",
    "Output Logic": "The outputs (`walk_left`, `walk_right`, `aaah`) are determined solely by the current state, as this is a Moore machine. Outputs are updated synchronously with the clock.",
    "Non-blocking Assignments": "State transitions and output updates are implemented using non-blocking assignments (`<=`) to ensure correct sequential behavior.",
    "Reset Behavior": "When `areset` is asserted, the state register is asynchronously set to the `walk_left` state, and the outputs are updated accordingly."
  }
}
```
```

