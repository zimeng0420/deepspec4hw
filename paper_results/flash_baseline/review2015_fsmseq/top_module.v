module top_module(
    input clk,
    input reset,
    input data,
    output start_shifting);

    reg [3:0] state;
    reg start_shifting;

    localparam S0 = 4'b0000; // Initial state
    localparam S1 = 4'b0001; // 1
    localparam S2 = 4'b0010; // 11
    localparam S3 = 4'b0011; // 110
    localparam S4 = 4'b0100; // 1101

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 0;
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
                    if (!data) begin
                        state <= S3;
                    end else begin
                        state <= S2;
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
                    state <= S4; // Stay in this state forever
                end
                default: begin
                    state <= S0;
                    start_shifting <= 0;
                end
            endcase
        end
    end

endmodule