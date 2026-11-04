# Web Research Results

Total Results: 1

## Result 1

The gshare branch predictor is a type of dynamic branch predictor that uses global branch history to predict the outcome of conditional branch instructions. It aims to improve prediction accuracy in pipelined processors.

Here's a breakdown of its design and functionality:

**Core Components:**

*   **Global History Register (GHR):** A shift register that stores the recent history of branch outcomes (taken or not taken). For example, a GHR with a size of 4 might hold "1101" where each bit represents the outcome of a branch.
*   **Pattern History Table (PHT):** A table of two-bit saturating counters used for branch predictions. Each entry in the PHT stores a 2-bit saturating counter, which determines the branch prediction.
    *   The counters have four states: strongly taken, weakly taken, weakly not taken, and strongly not taken.
*   **Indexing/Hashing:** The gshare predictor computes an index into the PHT by combining the branch address (PC) and the global branch history. This is commonly done by XORing the program counter (PC) with the GHR. The result is used to index the table of prediction bits.

**Functionality:**

1.  **Prediction:**
    *   When a branch instruction is encountered, the gshare predictor uses the current PC and the contents of the GHR to calculate an index.
    *   This index is used to access a specific entry in the PHT.
    *   The value of the two-bit saturating counter in the PHT entry is used to predict whether the branch will be taken or not taken. For example, 0 or 1 may indicate 'not taken', while 2 or 3 indicates 'taken'.
2.  **Training:**
    *   After the branch instruction is executed, the actual outcome (taken or not taken) is known.
    *   The predictor is then "trained" to improve future predictions.
    *   The PHT entry that was used for the prediction is updated based on the actual outcome.
    *   If the branch was taken, the counter is incremented (unless it's already at the maximum value). If it was not taken, the counter is decremented (unless it's already at the minimum value).
    *   The GHR is updated by shifting in the new branch outcome (1 for taken, 0 for not taken).
3.  **Branch History Update:** The branch history register is updated at the next positive clock edge.

**Advantages of Gshare:**

*   **Improved Accuracy:** By incorporating global branch history, gshare can capture dependencies between different branches, leading to better prediction accuracy compared to simpler predictors.
*   **Reduced Aliasing:** XORing the PC with the global history helps to distribute the PHT index, reducing aliasing (where different branches map to the same PHT entry).

**Specific Implementation Details for your task:**

*   **7-bit PC and 7-bit global history:** The predictor uses 7 bits from the program counter and a 7-bit global branch history.
*   **7-bit index:** The 7-bit PC and 7-bit global history are combined (hashed using XOR) to produce a 7-bit index.
*   **128-entry table:** This 7-bit index is used to access a table with 128 entries (2<sup>7</sup> = 128), where each entry is a two-bit saturating counter.
*   **Two Interfaces:** The branch predictor has two sets of interfaces: One for doing predictions and one for doing training.
    *   The prediction interface is used in the processor's Fetch stage to ask the branch predictor for branch direction predictions for the instructions being fetched.
    *   The branch predictor is then trained using the actual branch direction outcomes.

**Module Interface**

```verilog
module top_module(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);
```

**Interface Signals:**

*   **Inputs:**
    *   `clk`: Clock signal.
    *   `areset`: Asynchronous reset signal (active-high).
    *   `predict_valid`: Indicates a valid prediction request.
    *   `predict_pc`: The program counter value for the prediction request.
    *   `train_valid`: Indicates a valid training request.
    *   `train_taken`: The actual outcome of the branch (1 for taken, 0 for not taken) for training.
    *   `train_mispredicted`: Indicates whether the branch was mispredicted.
    *   `train_history`: The branch history register value for the branch being trained.
    *   `train_pc`: The program counter value for the branch being trained.
*   **Outputs:**
    *   `predict_taken`: The predicted branch direction (1 for taken, 0 for not taken).
    *   `predict_history`: The state of the branch history register used to make the prediction.


---

