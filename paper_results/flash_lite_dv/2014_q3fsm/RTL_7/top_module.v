module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State definition
    parameter A = 2'b00;
    parameter B = 2'b01;

    // Internal signals
    reg [1:0] state;
    reg [2:0] w_history; // Shift register to store past w values
    reg [1:0] count;

    // State transition logic and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_history <= 3'b000;
            count <= 2'b00;
        end else begin
            case (state)
                A: begin
                    z <= 0;
                    if (s) begin
                        state <= B;
                        w_history <= 3'b000; // Reset history when entering B
                        count <= 2'b00;
                    end
                end
                B: begin
                    // Shift w into the history
                    w_history <= {w, w_history[2:1]};

                    // Count the number of 1s in w_history
                    count <= (w_history[0] ? count + 1 : count) + (w_history[1] ? 1 : 0) + (w_history[2] ? 1 : 0);
                    if (count == 2'b10) begin
                        z <= 1;
                    end else if (count == 2'b11) begin
                      z <= 1;
                    end else begin
                        z <= 0;
                    end

                    if(count >= 3) begin
                        count <= 2'b00;
                    end


                end
            endcase
        end
    end

endmodule