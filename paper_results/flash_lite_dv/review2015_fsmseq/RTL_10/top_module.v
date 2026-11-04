module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Define states
    localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;

    // State register
    reg [2:0] current_state, next_state;

    // Combinational logic for state transition
    always @(*) begin
        case (current_state)
            S0: begin
                if (data)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (data)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (data)
                    next_state = S2;
                else
                    next_state = S3;
            end
            S3: begin
                if (data)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S4: begin
                if (reset)
                    next_state = S0;
                else
                    next_state = S4;
            end
            default: next_state = S0;
        endcase
    end

    // Sequential logic for state update and start_shifting
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            start_shifting <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == S4)
                start_shifting <= 1;
        end
    end

endmodule