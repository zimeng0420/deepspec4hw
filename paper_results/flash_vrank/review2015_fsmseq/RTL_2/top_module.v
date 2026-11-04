module top_module(
    input clk,
    input reset,
    input data,
    output start_shifting);

    reg start_shifting;

    // Define the states
    parameter S_IDLE  = 0;
    parameter S_ONE   = 1;
    parameter S_ONEONE = 2;
    parameter S_ONEONEZERO = 3;
    parameter S_ONEONEZERONE = 4;
    parameter S_FOUND = 5;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            start_shifting <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (data == 1) begin
                        state <= S_ONE;
                    end else begin
                        state <= S_IDLE;
                    end
                end
                S_ONE: begin
                    if (data == 1) begin
                        state <= S_ONEONE;
                    end else begin
                        state <= S_IDLE;
                    end
                end
                S_ONEONE: begin
                    if (data == 0) begin
                        state <= S_ONEONEZERO;
                    end else begin
                        state <= S_ONEONE;
                    end
                end
                S_ONEONEZERO: begin
                    if (data == 1) begin
                        state <= S_ONEONEZERONE;
                    end else begin
                        state <= S_IDLE;
                    end
                end
                S_ONEONEZERONE: begin
                    start_shifting <= 1;
                    state <= S_FOUND;
                end
                S_FOUND: begin
                  start_shifting <= 1;
                  state <= S_FOUND;
                end

                default: begin
                    state <= S_IDLE;
                    start_shifting <= 0;
                end
            endcase
        end
    end

endmodule