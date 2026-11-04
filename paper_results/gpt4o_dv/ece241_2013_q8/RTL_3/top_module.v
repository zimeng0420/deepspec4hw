module top_module (
	input clk,
	input aresetn,
	input x,
	output reg z
);

    reg [1:0] current_state, next_state;
    
    // State encoding
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    // State transition on the clock's positive edge or async reset on negative edge
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state and output logic
    always @(*) begin
        // Default assignments
        next_state = current_state;
        z = 1'b0;

        case (current_state)
            S0: begin
                if (x) 
                    next_state = S1;
                else 
                    next_state = S0;
            end
            S1: begin
                if (!x) 
                    next_state = S2;
                else 
                    next_state = S1;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1;
                end
                else 
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

endmodule