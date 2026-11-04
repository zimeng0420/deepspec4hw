Certainly! Below is the technical specification for implementing a D latch using an `always` block as per your requirements.

### Verilog Code Specification for D Latch

```verilog
module top_module (
    input d,        // Data input
    input ena,      // Enable input
    output logic q  // Output logic
);

    // Always block triggered on changes to 'ena' or 'd'
    always @* begin 
        if (ena) begin
            q = d;   // When enabled, output follows input 'd'
        end else begin
            q = q;   // When not enabled, output holds its previous value
        end
    end 

endmodule
```

### Description:
1. **Inputs:**
   - `d`: The data input for the latch.
   - `ena`: The enable control signal, which determines when the latch captures the value of `d`.

2. **Output:**
   - `q`: The current output of the latch, which can hold its state based on the value of `d` and the `ena` signal.

3. **Behavior:**
   - The `always @*` block is used to create combinational logic that responds to changes in `ena` or `d`.
   - When `ena` is high (1), the latch captures the value of `d` and updates `q`.
   - When `ena` is low (0), the output `q` maintains its previous value, effectively holding the last captured state.

### Assumptions:
- The design uses SystemVerilog `logic` type for `q` to simplify multi-driver behavior.
- The latch remains sensitive to both inputs dynamically.

This specification and implementation fulfill the task of creating a D latch using an `always` block.