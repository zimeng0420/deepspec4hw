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
    reg [1:0] w_count; // Counter for w=1 in state B
    reg [2:0] w_history; // Shift register to store previous w values

    // State Transition Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 0;
            w_history <= 3'b000;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        w_count <= 0;
                        w_history <= 3'b000;
                    end else begin
                        state <= A;
                    end
                    z <= 0; // Ensure z is reset in state A
                end
                B: begin
                    // Shift in w
                    w_history <= {w_history[1:0], w};

                    // Count w=1 in the last 3 cycles
                    if (w_history[2]) w_count <= w_count + 1;
                    if (w_history[1]) w_count <= w_count + 1;
                    if (w_history[0]) w_count <= w_count + 1;

                    // Determine output z after 3 cycles
                    if (w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    if(w_history == 3'b111 || w_history == 3'b110 || w_history == 3'b101 || w_history == 3'b011) begin
                      w_count <= 0;
                    end

                    if(w_history == 3'b100 || w_history == 3'b010 || w_history == 3'b001 || w_history == 3'b000) begin
                      w_count <= 0;
                    end

                    state <= B;
                end
                default: begin
                    state <= A;
                    z <= 0;
                    w_count <= 0;
                    w_history <= 3'b000;
                end
            endcase
        end
    end

endmodule