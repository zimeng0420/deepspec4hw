module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);
    reg current_state;

    parameter OFF = 1'b0, ON = 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= OFF;
        end else begin
            case (current_state)
                OFF: begin
                    if (j) 
                        current_state <= ON;
                    else 
                        current_state <= OFF;
                end
                ON: begin
                    if (k) 
                        current_state <= OFF;
                    else 
                        current_state <= ON;
                end
            endcase
        end
    end

    always @(*) begin
        out = (current_state == ON) ? 1'b1 : 1'b0;
    end
endmodule