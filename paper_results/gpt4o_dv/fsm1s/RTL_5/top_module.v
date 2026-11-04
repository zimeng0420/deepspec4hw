module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State encoding
    localparam B = 1'b0, A = 1'b1;
    
    reg current_state, next_state;
    
    // Synchronous state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= B;
        end else begin
            current_state <= next_state;
        end
    end
    
    always @(*) begin
        case (current_state)
            B: begin
                out = 1'b1;
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            A: begin
                out = 1'b0;
                if (in == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end
            default: begin
                next_state = B;
                out = 1'b1;
            end
        endcase
    end

endmodule