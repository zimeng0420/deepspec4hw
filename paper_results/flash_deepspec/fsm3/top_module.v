module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;
    wire out;

    // Next state logic
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
            default: next_state = A; // Default state
        endcase
    end

    // Output logic
    assign out = (current_state == D) ? 1'b1 : 1'b0;

    // State update logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

endmodule