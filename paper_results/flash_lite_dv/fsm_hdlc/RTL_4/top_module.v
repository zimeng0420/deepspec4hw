module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Define states
    localparam S_IDLE  = 3'b000;
    localparam S_ONE   = 3'b001;
    localparam S_TWO   = 3'b010;
    localparam S_THREE = 3'b011;
    localparam S_FOUR  = 3'b100;
    localparam S_FIVE  = 3'b101;
    localparam S_SIX   = 3'b110;
    localparam S_ERROR = 3'b111;

    // State register
    reg [2:0] state;

    // Next state logic and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_ONE;
                    else
                        state <= S_IDLE;
                end
                S_ONE: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_TWO;
                    else
                        state <= S_IDLE;
                end
                S_TWO: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_THREE;
                    else
                        state <= S_IDLE;
                end
                S_THREE: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_FOUR;
                    else
                        state <= S_IDLE;
                end
                S_FOUR: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_FIVE;
                    else
                        state <= S_IDLE;
                end
                S_FIVE: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_SIX;
                    else begin
                        state <= S_IDLE;
                        disc <= 1'b1;
                    end
                end
                S_SIX: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                    if (in)
                        state <= S_ERROR;
                    else begin
                        state <= S_IDLE;
                        flag <= 1'b1;
                    end
                end
                S_ERROR: begin
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b1;
                    if (in)
                        state <= S_ERROR;
                    else
                        state <= S_IDLE;
                end
                default: begin
                    state <= S_IDLE;
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                end
            endcase
        end
    end

endmodule