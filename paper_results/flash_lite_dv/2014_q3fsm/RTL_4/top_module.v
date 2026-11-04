module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State Definition
    parameter A = 2'b00;
    parameter B = 2'b01;

    // State Register
    reg [1:0] state;

    // Internal Signals
    reg [2:0] w_history; // Shift register to store the last three values of w
    reg [1:0] count;     // Counter for the number of 1s in w_history

    // State Transition Logic and Output Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_history <= 3'b000;
            count <= 2'b00;
        end else begin
            case (state)
                A: begin
                    z <= 0;
                    if (s) begin
                        state <= B;
                        w_history <= 3'b000;
                        count <= 2'b00;
                    end else begin
                        state <= A;
                    end
                end

                B: begin
                    // Shift w into the history
                    w_history <= {w_history[1:0], w};

                    // Count the number of 1s in w_history
                    count <= (w_history[2] == 1) + (w_history[1] == 1) + (w_history[0] == 1);

                    if (count == 2'b10) begin // Count == 2
                        z <= 1;
                    end else if (count != 2'b10) begin
                        z <= 0;
                    end
                    state <= B;
                end

                default: begin
                    state <= A;
                    z <= 0;
                    w_history <= 3'b000;
                    count <= 2'b00;
                end
            endcase
        end
    end

endmodule