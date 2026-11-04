module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);
    reg [1:0] state; // 0: A, 1: B
    reg [2:0] w_count; // Count of w = 1 over three cycles

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // State A
            z <= 0;
            w_count <= 0;
        end else begin
            case (state)
                2'b00: begin // State A
                    z <= 0; // Output remains 0 in state A
                    if (s) begin
                        state <= 2'b01; // Transition to State B
                        w_count <= 0; // Reset w_count
                    end
                end

                2'b01: begin // State B
                    w_count <= {w_count[1:0], w}; // Shift in the new value of w
                    if (w_count[2] + w_count[1] + w_count[0] == 2) begin
                        z <= 1; // Set z to 1 if exactly two w's are 1
                    end else begin
                        z <= 0; // Otherwise, z remains 0
                    end
                end
            endcase
        end
    end
endmodule