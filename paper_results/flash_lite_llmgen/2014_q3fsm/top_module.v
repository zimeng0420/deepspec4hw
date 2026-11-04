module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

    // State Definitions
    parameter A = 2'b00; // Reset/Idle
    parameter B = 2'b01; // Pattern Detection
    parameter C = 2'b10; // Output Generation

    // State Register
    reg [1:0] state;

    // Internal Registers
    reg [1:0] count; // Counter for 'w' values
    reg [2:0] w_history; // Stores the last three 'w' values (shifted)
    reg z_temp; // Temporary register for z

    // State Transition Logic and Output Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            count <= 0;
            w_history <= 0;
            z_temp <= 0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        count <= 0;
                        w_history <= 0;
                    end else begin
                        state <= A;
                        z <= 0;
                    end
                end

                B: begin
                    // Shift w into history
                    w_history <= {w_history[1:0], w};

                    // Count the number of 1s in w_history
                    count <= w_history[0] + w_history[1] + w_history[2];

                    if (count == 2) begin
                        z_temp <= 1;
                    end else begin
                        z_temp <= 0;
                    end

                    if (count >= 3) begin
                        state <= C;
                    end else if (count < 3) begin
                        if(w_history[0] + w_history[1] + w_history[2] >= 3)
                            state <= C;
                        else
                            state <= B;
                    end
                end

                C: begin
                    z <= z_temp;
                    state <= B;
                end

                default: begin
                    state <= A;
                    z <= 0;
                    count <= 0;
                    w_history <= 0;
                    z_temp <= 0;
                end
            endcase
        end
    end

endmodule