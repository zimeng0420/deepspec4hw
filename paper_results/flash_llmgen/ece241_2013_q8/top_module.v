module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg [1:0] state;  // 3 states: 00, 01, 10

    // State definitions
    localparam S_INIT = 2'b00;
    localparam S_ONE  = 2'b01;
    localparam S_ONEZERO = 2'b10;

    always @(posedge clk or negedge aresetn) 
    begin
        if (!aresetn) 
        begin
            state <= S_INIT;
            z <= 0;
        end
        else 
        begin
            case (state)
                S_INIT: 
                begin
                    if (x) 
                    begin
                        state <= S_ONE;
                        z <= 0;
                    end
                    else 
                    begin
                        state <= S_INIT;
                        z <= 0;
                    end
                end
                S_ONE: 
                begin
                    if (x) 
                    begin
                        state <= S_ONE;
                        z <= 0;
                    end
                    else 
                    begin
                        state <= S_ONEZERO;
                        z <= 0;
                    end
                end
                S_ONEZERO: 
                begin
                    if (x) 
                    begin
                        state <= S_ONE;
                        z <= 1;
                    end
                    else 
                    begin
                        state <= S_INIT;
                        z <= 0;
                    end
                end
                default: 
                begin
                    state <= S_INIT;
                    z <= 0;
                end
            endcase
        end
    end

endmodule