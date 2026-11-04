module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    // Define the states
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg current_state;
    reg next_state;

    // Output register
    reg out_r;

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
            default: next_state = A; // Should not happen, but good practice
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            A: out_r = 0;
            B: out_r = 0;
            C: out_r = 0;
            D: out_r = 1;
            default: out_r = 0; // Should not happen, but good practice
        endcase
    end

    // State update logic (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Assign output
    assign out = out_r;

endmodule