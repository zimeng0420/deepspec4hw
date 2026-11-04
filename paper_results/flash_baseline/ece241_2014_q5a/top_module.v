module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    reg z;
    reg [1:0] state;

    // Define states
    localparam S_IDLE = 2'b00;
    localparam S_FIRST = 2'b01;
    localparam S_REST = 2'b10;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_IDLE;
            z <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (x) begin
                        state <= S_FIRST;
                        z <= 1;
                    end else begin
                        state <= S_IDLE;
                        z <= 0;
                    end
                end
                S_FIRST: begin
                    state <= S_REST;
                    z <= ~x;
                end
                S_REST: begin
                    state <= S_REST;
                    z <= ~x;
                end
                default: begin
                    state <= S_IDLE;
                    z <= 0;
                end
            endcase
        end
    end

endmodule