module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // States
    parameter A = 2'b00;
    parameter B = 2'b01;

    // State register
    reg [1:0] state;

    // Internal signals for state B
    reg [1:0] w_count; // Counter for w=1 in state B
    reg [2:0] cycle_count; // Counter for the three clock cycles in state B
    reg w1, w2, w3; // Store the values of w for the last three cycles

    // State transition logic and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 2'b00;
            cycle_count <= 3'b000;
            w1 <= 0;
            w2 <= 0;
            w3 <= 0;
        end else begin
            case (state)
                A: begin
                    z <= 0;
                    if (s) begin
                        state <= B;
                        w_count <= 2'b00;
                        cycle_count <= 3'b000;
                        w1 <= 0;
                        w2 <= 0;
                        w3 <= 0;
                    end
                end
                B: begin
                    // Sample w over three cycles
                    w3 <= w2;
                    w2 <= w1;
                    w1 <= w;

                    // Cycle counter
                    if (cycle_count < 3'b011) begin
                        cycle_count <= cycle_count + 1'b1;
                    end else begin
                        cycle_count <= 3'b000;
                    end


                    // Count w=1 in the three cycles
                    w_count <= w_count + (w1 & !w2 & !w3) + (!w1 & w2 & !w3) + (!w1 & !w2 & w3) + (w1 & w2 & !w3) + (w1 & !w2 & w3) + (!w1 & w2 & w3) ;
                    // w_count <= w_count + w1 + w2 + w3 - (w1 & w2) - (w1 & w3) - (w2 & w3) + (w1 & w2 & w3);

                    // Assert z if exactly two w's are 1, after three cycles
                    if (cycle_count == 3'b011) begin
                        if (w_count == 2'b10) begin
                            z <= 1;
                        end else begin
                            z <= 0;
                        end
                        w_count <= 2'b00;
                    end else begin
                         z <= z; // Keep the current value of z
                    end
                   
                    if (cycle_count == 3'b011) begin
                         state <= B;
                    end
                end
                default: begin
                    state <= A;
                    z <= 0;
                    w_count <= 2'b00;
                    cycle_count <= 3'b000;
                    w1 <= 0;
                    w2 <= 0;
                    w3 <= 0;
                end
            endcase
        end
    end

endmodule