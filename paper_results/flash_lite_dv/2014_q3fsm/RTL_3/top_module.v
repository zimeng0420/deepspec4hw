module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State definition
    parameter A = 0;
    parameter B = 1;

    // State register
    reg [1:0] state;

    // Internal signals
    reg [2:0] w_history; // Shift register to store previous w values
    reg [1:0] count;     // Counter for the number of 1s in w_history
    reg z_next;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                    end
                end
                B: begin
                    // w_history is updated in parallel.
                    // No need for additional pipeline stages in this design.
                    
                    w_history <= {w_history[1:0], w};

                    if(w_history[0] + w_history[1] + w_history[2] == 2) begin
                      z_next <= 1;
                    end
                    else begin
                      z_next <= 0;
                    end
                    
                    
                    if (w_history[0] && w_history[1] && !w_history[2] || w_history[0] && !w_history[1] && w_history[2] || !w_history[0] && w_history[1] && w_history[2]) begin
                    //z_next <= 1;
                    end
                    
                    state <= B; // Stay in state B
                end
            endcase
            z <= z_next;
        end
    end

endmodule