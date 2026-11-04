module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);
    reg [1:0] state;
    reg [1:0] count;

    localparam A = 2'b00, 
               B = 2'b01, 
               COUNT_1 = 2'b10, 
               COUNT_2 = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            z <= 0;
            count <= 0;
        end else begin
            case (state)
                A: begin
                    z <= 0;
                    if (s) begin
                        state <= B;
                        count <= 0;
                    end
                end

                B: begin
                    if (count < 2) begin
                        count <= count + w;
                        if (count == 2) begin
                            z <= 1; // Signal z will be set next clock cycle
                        end
                    end
                    if (count == 3) begin
                        state <= B; // Reset count, stay in state B
                        count <= 0;
                    end
                end

                default: begin
                    state <= A; // Default to reset state
                    z <= 0;
                end
            endcase
        end
    end
endmodule