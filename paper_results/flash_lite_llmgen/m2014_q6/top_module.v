module top_module (
    input clk,
    input reset,
    input w,
    output z
);

    // State Encoding (One-Hot)
    parameter A = 6'b000001;
    parameter B = 6'b000010;
    parameter C = 6'b000100;
    parameter D = 6'b001000;
    parameter E = 6'b010000;
    parameter F = 6'b100000;

    // State Register
    reg [5:0] current_state, next_state;

    // Output Register
    reg z_reg;

    // State Transition Logic (Combinational)
    always @(*) begin
        case (current_state)
            A:  next_state = (w == 0) ? B : A;
            B:  next_state = (w == 0) ? C : D;
            C:  next_state = (w == 0) ? E : D;
            D:  next_state = (w == 0) ? F : A;
            E:  next_state = (w == 0) ? E : D;
            F:  next_state = (w == 0) ? C : D;
            default: next_state = A; // Default to A for safety
        endcase
    end

    // Output Logic (Combinational)
    always @(*) begin
        case (current_state)
            E, F: z_reg = 1'b1;
            default: z_reg = 1'b0;
        endcase
    end

    // State Update (Sequential)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Output Assignment
    assign z = z_reg;

endmodule