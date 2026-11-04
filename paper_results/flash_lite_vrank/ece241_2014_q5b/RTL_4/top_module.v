module top_module (
	input clk,
	input areset,
	input x,
	output z
);

    // State declaration using one-hot encoding
    parameter A = 3'b001;
    parameter B = 3'b010;

    reg [2:0] state, next_state;
    reg z_reg;

    // State transition logic
    always @(*) begin
        case (state)
            A: begin
                if (x)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (x)
                    next_state = B;
                else
                    next_state = B;
            end
            default:
                next_state = A; // Default state
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            A: begin
                if (x)
                  z_reg = 1'b1;
                else
                  z_reg = 1'b0;
            end
            B: begin
              if(x)
                z_reg = 1'b0;
              else
                z_reg = 1'b1;

            end
            default:
                z_reg = 1'b0;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output register
    always @(posedge clk) begin
        z <= z_reg;
    end

endmodule