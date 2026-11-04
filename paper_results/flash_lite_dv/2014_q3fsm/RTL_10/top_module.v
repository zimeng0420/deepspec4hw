module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State Definition
    parameter A = 0;
    parameter B = 1;

    // State Register
    reg [1:0] state;

    // Internal Signals
    reg [1:0] count;
    reg [2:0] w_history; // Stores the past 3 values of w

    // State Transition Logic and Output Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            count <= 0;
            w_history <= 3'b000;
        end else begin
            case (state)
                A: begin
                    z <= 0;
                    if (s) begin
                        state <= B;
                        count <= 0;
                        w_history <= 3'b000;
                    end else begin
                        state <= A;
                    end
                end
                B: begin
                    // Shift w into the history
                    w_history <= {w_history[1:0], w};

                    // Count the number of 1s in w_history, only increment if in first 3 clock cycles
                    if(w_history[2]) count <= count + 1'b1;
                    if(w_history[1]) count <= count + 1'b1;
                    if(w_history[0]) count <= count + 1'b1;


                    if (count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end

                    // Prepare for next window
                     if(w_history == 3'b000 || w_history == 3'b111) begin
                         count <= 0;
                     end
                     else if (w_history[2] != w_history[1] || w_history[1] != w_history[0]) begin
                       count <= 0;
                     end

                    state <= B;

                end
            endcase
        end
    end

endmodule