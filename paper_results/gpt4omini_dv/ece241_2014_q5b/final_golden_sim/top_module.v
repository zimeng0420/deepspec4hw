module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    // State encoding
    reg state_A, state_B;
    
    // Output logic
    assign z = (state_A && !x) || (state_B && !x) || (state_A && x);

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1;
            state_B <= 0;
        end else begin
            case ({state_A, state_B})
                2'b10: begin // State A
                    state_A <= (x == 1);
                    state_B <= (x == 1);
                end
                2'b01: begin // State B
                    state_A <= (x == 0);
                    state_B <= 1; // remains in State B
                end
                default: begin
                    state_A <= 0; 
                    state_B <= 0; 
                end
            endcase
        end
    end

endmodule