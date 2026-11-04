module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);
    reg [1:0] state; // 2-bit state variable
    reg [2:0] count; // Count of w = 1 over three cycles

    parameter A = 2'b00, B = 2'b01; // State encoding

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 3'b000;
            z <= 0;
        end else begin
            case (state)
                A: begin
                    z <= 0; // Output z is set to 0 in state A
                    if (s) begin
                        state <= B; // Transition to state B
                        count <= 3'b000; // Reset count
                    end
                end
                B: begin
                    count <= {count[1:0], w}; // Shift in the current value of w
                    if (w) begin
                        if (count[2] + count[1] + count[0] == 2) begin
                            z <= 1; // Set z if exactly 2 w's are 1
                        end else begin
                            z <= 0; // Else z is 0
                        end
                    end
                end
            endcase
        end
    end
endmodule