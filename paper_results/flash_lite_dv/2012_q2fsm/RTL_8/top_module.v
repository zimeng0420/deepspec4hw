module top_module (
    input clk,
    input reset,
    input w,
    output z
);

    // State Definition
    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;

    // State Register
    reg [2:0] current_state, next_state;

    // Output Register
    //reg z; // Option 1:  If you want to register the output

    // State Table (Combinational Logic for Next State)
    always @(*) begin
        case (current_state)
            A:  next_state = (w) ? B : A;
            B:  next_state = (w) ? C : D;
            C:  next_state = (w) ? E : D;
            D:  next_state = (w) ? F : A;
            E:  next_state = (w) ? E : D;
            F:  next_state = (w) ? C : D;
            default: next_state = A;
        endcase
    end

    // State Flip-Flops (Sequential Logic)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output Logic (Combinational Logic for Output)
    // Option 1: Continuous Assignment
    assign z = (current_state == E || current_state == F) ? 1'b1 : 1'b0;
    
    // Option 2:  Always Block for output (if you want to register the output, you would need this)
    // always @(*) begin
    //     case (current_state)
    //         E, F: z = 1'b1;
    //         default: z = 1'b0;
    //     endcase
    // end

endmodule