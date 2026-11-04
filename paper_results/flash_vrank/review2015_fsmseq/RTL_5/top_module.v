module top_module(
    input clk,
    input reset,
    input data,
    output start_shifting);

    reg start_shifting;

    reg [2:0] state;
    localparam S0 = 3'b000; // Initial state
    localparam S1 = 3'b001; // Saw 1
    localparam S2 = 3'b010; // Saw 11
    localparam S3 = 3'b011; // Saw 110
    localparam S4 = 3'b100; // Saw 1101

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 0;
        end else begin
            if (start_shifting) begin
                // Once the sequence is found, stay asserted until reset
                start_shifting <= 1;
            end else begin
                case (state)
                    S0: begin
                        if (data) begin
                            state <= S1;
                        end else begin
                            state <= S0;
                        end
                    end
                    S1: begin
                        if (data) begin
                            state <= S2;
                        end else begin
                            state <= S0;
                        end
                    end
                    S2: begin
                        if (data) begin
                            state <= S1; // 111 acts as 1
                        end else begin
                            state <= S3;
                        end
                    end
                    S3: begin
                        if (data) begin
                            state <= S4;
                        end else begin
                            state <= S0;
                        end
                    end
                    S4: begin
                        start_shifting <= 1;
                        state <= S4; //Hold until reset. This is probably not necessary since start_shifting is set.
                    end
                    default: begin
                        state <= S0;
                    end
                endcase
            end
        end
    end

endmodule