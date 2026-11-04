module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State Definition
    parameter IDLE        = 2'b00;
    parameter SEARCH_ONE  = 2'b01;
    parameter COMPLEMENT  = 2'b10;

    // State Register
    reg [1:0] state;

    // State Transition Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (!areset) begin
                        state <= SEARCH_ONE;
                    end
                end
                SEARCH_ONE: begin
                    if (x) begin
                        state <= COMPLEMENT;
                    end else begin
                        state <= SEARCH_ONE;
                    end
                end
                COMPLEMENT: begin
                    if (areset) begin
                        state <= IDLE;
                    end else begin
                        state <= COMPLEMENT;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Output Logic (Moore)
    always @(*) begin
        case (state)
            IDLE:       z = 1'b0;
            SEARCH_ONE: z = x;
            COMPLEMENT: z = ~x;
            default:    z = 1'b0;
        endcase
    end

endmodule