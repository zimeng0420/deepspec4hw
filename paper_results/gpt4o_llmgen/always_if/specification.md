### Technical Specification for 2-to-1 Multiplexer Design

#### Objective
Design a 2-to-1 multiplexer in Verilog that outputs a signal `out_assign` based on assign statements and `out_always` using procedural if statements. The selection between inputs `a` and `b` is controlled by the combination of signals `sel_b1` and `sel_b2`.

#### Inputs
- `a`: 1-bit input signal.
- `b`: 1-bit input signal.
- `sel_b1`: 1-bit select signal.
- `sel_b2`: 1-bit select signal.

#### Outputs
- `out_assign`: Output signal based on assign statement methodology.
- `out_always`: Output signal based on procedural if statement methodology.

#### Functional Specification

1. **Logic Behavior:**
   - If both `sel_b1` and `sel_b2` are true (high), the multiplexer will select the input `b`.
   - If not both `sel_b1` and `sel_b2` are true, the multiplexer will select the input `a`.

2. **Implementation:**
   
   **Assign Statement Mux Logic:**
   - Implement the multiplexer logic for `out_assign` using continuous assignment statements.
   - Use a logical AND operation on `sel_b1` and `sel_b2` for selection.

   **Procedural If Statement Mux Logic:**
   - Implement the multiplexer logic for `out_always` using an always block.
   - Use an explicit if-else construct to evaluate the condition and assign the appropriate signal to `out_always`.

#### Verilog Module Structure

**Assign Statement Implementation:**
```verilog
assign out_assign = (sel_b1 && sel_b2) ? b : a;
```

**Procedural If Statement Implementation:**
```verilog
always @(*) begin
    if (sel_b1 && sel_b2) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end
```

### Constraints
- The design must ensure minimal propagation delay with a straightforward logic circuit.
- Use of blocking or non-blocking assignments is as specified; logic should maintain intended functionality with consistent signal behavior.

### Verification
- Use a testbench to simulate various scenarios including:
  - Both `sel_b1` and `sel_b2` false.
  - Either `sel_b1` or `sel_b2` true.
  - Both `sel_b1` and `sel_b2` true.

These will verify the correct operation of both the `out_assign` and `out_always` logic under all expected signal conditions.