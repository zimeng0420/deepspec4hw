Here are the technical specifications for implementing a 2-to-1 multiplexer (MUX) in Verilog using both assign statements and a procedural if statement:

### Technical Specifications

1. **Input/Output Ports**:
   - **Inputs**:
     - `input a;`  // First input to the MUX
     - `input b;`  // Second input to the MUX
     - `input sel_b1;`  // Selection signal bit 1
     - `input sel_b2;`  // Selection signal bit 2
   - **Outputs**:
     - `output out_assign;`  // Output using continuous assignment
     - `output reg out_always;`  // Output using a procedural assignment

2. **MUX Logic**:
   - The MUX should select `b` as the output if both `sel_b1` and `sel_b2` are true (i.e., both signals are high). Otherwise, it should select `a` as the output.

3. **Implementation Using Assign Statements**:
   - Use a continuous assignment to set `out_assign` based on the values of `sel_b1`, `sel_b2`, `a`, and `b`. 
   ```verilog
   assign out_assign = (sel_b1 && sel_b2) ? b : a;
   ```

4. **Implementation Using Procedural If Statement**:
   - Use an `always` block with a procedural `if` statement to implement the MUX logic for `out_always`.
   ```verilog
   always @(*) begin
       if (sel_b1 && sel_b2) begin
           out_always = b;
       end else begin
           out_always = a;
       end
   end
   ```

### Example Code Snippet:
```verilog
module top_module (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);

    // Using assign statements
    assign out_assign = (sel_b1 && sel_b2) ? b : a;

    // Using procedural if statement
    always @(*) begin
        if (sel_b1 && sel_b2) begin
            out_always = b;
        end else begin
            out_always = a;
        end
    end

endmodule
```

This implementation captures the requirements specified for the 2-to-1 multiplexer using both methods effectively.