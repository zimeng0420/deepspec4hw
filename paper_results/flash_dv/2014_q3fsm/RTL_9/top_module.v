module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // Define states
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // State register
    reg [1:0] state;
    reg [1:0] next_state;

    // Shift register to store last 3 values of w
    reg [2:0] w_history;

    // Combinational logic for next state and output
    always @(*) begin
        next_state = state;
        z = 0; // Default value

        case (state)
            A: begin
                if (s) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                next_state = C;
            end
            C: begin
                next_state = D;
            end
            D: begin
                next_state = B;

                // Count the number of 1s in w_history
                if ((w_history[0] + w_history[1] + w_history[2]) == 2) begin
                    z = 1;
                end
            end
            default: next_state = A; // Should not happen, but good practice
        endcase
    end

    // Sequential logic for state update and w_history
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_history <= 3'b000;
        end else begin
            state <= next_state;
            w_history <= {w_history[1:0], w};
        end
    end

endmodule