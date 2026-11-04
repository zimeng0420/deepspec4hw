module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    // Define state encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg state;
    reg next_state;

    // Output register
    reg out;

    // State transition logic
    always @(*) begin
        case (state)
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
            default: next_state = A; // Should not happen, but good practice
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            D: out = 1;
            default: out = 0;
        endcase
    end

    // State update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state = A;
        end else begin
            state = next_state;
        end
    end

endmodule