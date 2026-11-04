module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    // Define states
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg current_state, next_state;

    // Output register
    reg out_r;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: begin
                if (in == 0) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            B: begin
                if (in == 0) begin
                    next_state = C;
                end else begin
                    next_state = B;
                end
            end
            C: begin
                if (in == 0) begin
                    next_state = A;
                end else begin
                    next_state = D;
                end
            end
            D: begin
                if (in == 0) begin
                    next_state = C;
                end else begin
                    next_state = B;
                end
            end
            default: next_state = A; // Should never happen, but good practice
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            out_r <= 0;
        end else begin
            case (current_state)
                A: out_r <= 0;
                B: out_r <= 0;
                C: out_r <= 0;
                D: out_r <= 1;
                default: out_r <= 0; // Should never happen, but good practice
            endcase
        end
    end

    assign out = out_r;

endmodule