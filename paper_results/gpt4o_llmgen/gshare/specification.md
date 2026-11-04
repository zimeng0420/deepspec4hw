## Technical Specification for GShare Branch Predictor

### Module: top_module

This module implements a gshare branch predictor with the following specifications:

#### Inputs:
1. **clk**: Clock signal.
2. **areset**: Asynchronous active-high reset signal.

3. **predict_valid**: Signal indicating a valid prediction is to be made.
4. **predict_pc**: 7-bit program counter value used for prediction.
5. **train_valid**: Signal indicating a valid training is to be performed.
6. **train_taken**: Indicates if the actual branch outcome was taken.
7. **train_mispredicted**: Indicates if the branch was mispredicted.

8. **train_history**: 7-bit global history register value for the branch being trained.
9. **train_pc**: 7-bit program counter value for the branch being trained.

#### Outputs:
1. **predict_taken**: Predicted branch direction (1 if taken, 0 if not taken).
2. **predict_history**: The branch history register used to make the prediction.

#### Internal Components:
1. **Global History Register (GHR)**:
   - Width: 7 bits.
   - Function: Holds the global branch history.

2. **Pattern History Table (PHT)**:
   - Entries: 128.
   - Each Entry: 2-bit saturating counter.
   - Addressing: Uses a 7-bit index derived by XORing the `predict_pc` with `GHR`.

#### Operation:

- **Prediction Process**:
  1. When `predict_valid` is high, XOR the 7-bit `predict_pc` with the current `GHR` to generate a 7-bit index.
  2. Use this index to access the PHT and retrieve the 2-bit counter value.
  3. The most significant bit (MSB) of the counter determines `predict_taken`.
  4. Output the current `GHR` as `predict_history`.
  5. Update `GHR` by shifting in the prediction (`predict_taken`) at the next positive clock edge.

- **Training Process**:
  1. When `train_valid` is high, XOR the `train_pc` with the `train_history` to generate a 7-bit index.
  2. Use this index to access and update the PHT:
     - If `train_taken` and PHT counter is less than 3, increment the counter.
     - If not `train_taken` and PHT counter is greater than 0, decrement the counter.
  3. If `train_mispredicted` is true, update the GHR with `train_history` immediately after the mispredicting branch.
  4. Update operations happen at the next positive clock edge.

- **Arbitration**:
  - If both training and prediction requests depend on the same PHT entry in the same cycle, prioritize training.
  - Predictions use the pre-training state of the PHT.

- **Reset Behavior**:
  - On `areset` high, reset the GHR to zero and initialize all PHT entries to a weakly taken state (`2'b01`).

### Timing Considerations:
- The PHT access for prediction responds in the cycle it is requested.
- Training updates the PHT in the cycle following a training request.
- When misprediction recovery is needed, ensure `GHR` state is correctly restored.

This specification outlines the design and operational details of a gshare branch predictor suitable for integration into a processor pipeline to enhance branch prediction accuracy and efficiency.