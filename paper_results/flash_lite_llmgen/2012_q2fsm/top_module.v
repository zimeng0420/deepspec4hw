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

    // State Register (6-bit one-hot encoded)
    reg [5:0] state;
    reg [5:0] next_state;

    // Output Signal (z)
    assign z = (state == E || state == F) ? 1'b1 : 1'b0; // Moore output: z = 1 in states E and F, otherwise z = 0

    // State Flip-Flops (Synchronous)
    always @(posedge clk) begin
        if (reset) begin
            state <= A; // Reset to state A
        end else begin
            state <= next_state; // Update state on clock edge
        end
    end

    // State Table (Next State Logic)
    always @(*) begin
        case (state)
            A: begin
                next_state = (w) ? B : A;
            end
            B: begin
                next_state = (w) ? C : D;
            end
            C: begin
                next_state = (w) ? E : D;
            end
            D: begin
                next_state = (w) ? F : A;
            end
            E: begin
                next_state = (w) ? E : D;
            end
            F: begin
                next_state = (w) ? C : D;
            end
            default: begin // Should never happen, but good practice
                next_state = A; // Default to state A
            end
        endcase
    end

endmodule