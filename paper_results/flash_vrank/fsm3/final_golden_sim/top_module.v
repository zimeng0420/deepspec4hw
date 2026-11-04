module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    // Define the states
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // State register
    reg current_state;
    reg next_state;

    // Output register
    reg out;

    // State transition logic
    always @(*) begin
        case (current_state)
            A: begin
                if (in == 0)
                    next_state = A;
                else
                    next_state = B;
            end
            B: begin
                if (in == 0)
                    next_state = C;
                else
                    next_state = B;
            end
            C: begin
                if (in == 0)
                    next_state = A;
                else
                    next_state = D;
            end
            D: begin
                if (in == 0)
                    next_state = C;
                else
                    next_state = B;
            end
            default: next_state = A;  // Should not happen, but good to have
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            D: out = 1;
            default: out = 0;
        endcase
    end

    // State update logic (sequential)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

endmodule