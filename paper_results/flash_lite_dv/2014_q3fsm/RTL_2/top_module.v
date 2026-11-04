module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State definition
    parameter A = 2'b00;
    parameter B = 2'b01;

    // Internal state register
    reg [1:0] state;

    // Internal registers for state B logic
    reg [1:0] count; // Counter for w=1 in state B
    reg [2:0] w_history; // Shift register to store w values
    reg z_next; // Next value of z

    // State transition logic and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
            count <= 2'b00;
            w_history <= 3'b000;
            z_next <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        count <= 2'b00;
                        w_history <= 3'b000;
                        z_next <= 1'b0;
                    end else begin
                        state <= A;
                        z <= 1'b0;
                        count <= 2'b00;
                        w_history <= 3'b000;
                    end
                end
                B: begin
                    // Shift w into the history
                    w_history <= {w_history[1:0], w};

                    // Count the number of 1s in w_history
                    count <= 0;
                    if (w_history[0]) count <= count + 1;
                    if (w_history[1]) count <= count + 1;
                    if (w_history[2]) count <= count + 1;

                    // Determine the output z in the next cycle
                    z_next <= (count == 2);
                    state <= B;
                    z <= z_next;
                end
                default: begin
                    state <= A;
                    z <= 1'b0;
                    count <= 2'b00;
                    w_history <= 3'b000;
                    z_next <= 1'b0;
                end
            endcase
        end
    end

endmodule