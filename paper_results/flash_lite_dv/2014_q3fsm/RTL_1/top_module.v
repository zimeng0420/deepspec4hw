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

    // Internal state register
    reg [1:0] state;

    // Internal registers for state B logic
    reg [2:0] w_history; // Shift register to store past w values
    reg [1:0] count;     // Counter for number of 1s in w_history

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_history <= 3'b000;
            count <= 2'b00;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        w_history <= 3'b000; // Reset w history when entering B
                        count <= 2'b00;
                    end else begin
                        state <= A;
                        z <= 0; // Ensure z is 0 in state A
                    end
                end
                B: begin
                    // Shift w into history
                    w_history <= {w, w_history[2:1]};

                    // Count the number of 1s in w_history
                    count <= (w_history[0] ? count + 1 : count) + (w_history[1] ? 1 : 0) + (w_history[2] ? 1 : 0) - ((w_history[0]? 0: count[0]) + (w_history[0]? 0: count[1]));

                    // Determine z based on the count
                    if (count == 2'b10) begin // Modified condition: count == 2
                        z <= 1;
                    end else if (count != 2'b10 && count != 2'b00 && count != 2'b01 && count != 2'b11) begin
                        z <= 0;
                    end
                    else begin
                         z <= 0;
                    end
                     if ((w_history[2] == 1 && w_history[1] == 1 && w_history[0] == 0 ) || (w_history[2] == 1 && w_history[1] == 0 && w_history[0] == 1 ) || (w_history[2] == 0 && w_history[1] == 1 && w_history[0] == 1 )){
                            z <=1;
                         }else{
                            z <=0;
                         }

                    if(count == 2'b11)
                    begin
                        z <= 0;
                    end
                    // Stay in state B for the next three cycles, then reset
                    if(w_history == 3'b000)
                    begin
                    state <= B;
                    end
                    else if(w_history == 3'b001)
                    begin
                    state <= B;
                    end
                    else if(w_history == 3'b010)
                    begin
                    state <= B;
                    end
                     else if(w_history == 3'b100)
                    begin
                    state <= B;
                    end
                     else if(w_history == 3'b110)
                    begin
                    state <= B;
                    end
                     else if(w_history == 3'b101)
                    begin
                    state <= B;
                    end
                     else if(w_history == 3'b011)
                    begin
                    state <= B;
                    end
                    else if(w_history == 3'b111)
                    begin
                    state <= B;
                    end

                end
                default: begin
                    state <= A;
                    z <= 0;
                    w_history <= 3'b000;
                    count <= 2'b00;
                end
            endcase
        end
    end

endmodule