module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Define states
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;

    // Define state register
    reg [2:0] current_state;
    reg [2:0] next_state;

    // State transition logic
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
                if (!data)
                    next_state = S3;
                else
                    next_state = S2;
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

    // Output logic
    always @(*) begin
        if (current_state == S4)
            start_shifting = 1;
        else
            start_shifting = 0;
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

endmodule