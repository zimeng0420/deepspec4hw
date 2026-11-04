module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    reg [1:0] current_state, next_state;

    // Define state encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State transition logic
    always @(*) begin
        case (current_state)
            A: begin
                if (in == 0) next_state = A;
                else next_state = B;
            end
            B: begin
                if (in == 0) next_state = C;
                else next_state = B;
            end
            C: begin
                if (in == 0) next_state = A;
                else next_state = D;
            end
            D: begin
                if (in == 0) next_state = C;
                else next_state = B;
            end
            default: next_state = A; // Should never happen, but good practice
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset) current_state <= A;
        else current_state <= next_state;
    end

    // Output logic
    assign out = (current_state == D) ? 1 : 0;

endmodule