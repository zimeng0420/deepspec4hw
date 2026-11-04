# Messages for Task: history_shift

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate only a technical specification for the given task. I will tip you $200 if you can fulfill the tasks I give you.Build a 32-bit global history shift register, including support for rolling back state in response to a pipeline flush caused by a branch misprediction. When a branch prediction is made (predict_valid = 1), shift in predict_taken from the LSB side to update the branch history for the predicted branch. (predict_history[0] is the direction of the youngest branch.) When a branch misprediction occurs (train_mispredicted = 1), load the branch history register with the history after the completion of the mispredicted branch. This is the history before the mispredicted branch (train_history) concatenated with the actual result of the branch (train_taken). If both a prediction and misprediction occur at the same time, the misprediction takes precedence, because the pipeline flush will also flush out the branch that is currently making a prediction. predict_history is the value of the branch history register. areset is a positive edge triggered asynchronous reset that resets the history counter to zero.




```

## User Message

```
The header you have already known is:module top_module
(
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    output logic [31:0] predict_history,
    
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history
);

```

