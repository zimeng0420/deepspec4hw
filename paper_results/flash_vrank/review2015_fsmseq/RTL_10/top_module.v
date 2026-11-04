module top_module(
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [3:0] state;
    reg start_shifting;

    parameter S0 = 4'b0000;
    parameter S1 = 4'b0001;
    parameter S2 = 4'b0010;
    parameter S3 = 4'b0011;
    parameter S4 = 4'b0100;
    parameter FOUND = 4'b0101; // Add a state to indicate sequence is found


    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 0;
        end else begin
            case (state)
                S0: begin
                    if (data == 1) begin
                        state <= S1;
                    end else begin
                        state <= S0;
                    end
                    start_shifting <= 0;
                end
                S1: begin
                    if (data == 1) begin
                        state <= S2;
                    end else begin
                        state <= S0;
                    end
                    start_shifting <= 0;
                end
                S2: begin
                    if (data == 0) begin
                        state <= S3;
                    end else if (data == 1) begin
                         state <= S2; //stay in this state
                    end else begin
                        state <= S0;
                    end
                    start_shifting <= 0;
                end
                S3: begin
                    if (data == 1) begin
                        state <= S4;
                    end else begin
                        state <= S0;
                    end
                    start_shifting <= 0;
                end
                S4: begin
                    state <= FOUND;
                    start_shifting <= 1;
                end
                FOUND: begin
                  state <= FOUND;
                  start_shifting <= 1;
                end

                default: begin
                    state <= S0;
                    start_shifting <= 0;
                end
            endcase
        end
    end

endmodule