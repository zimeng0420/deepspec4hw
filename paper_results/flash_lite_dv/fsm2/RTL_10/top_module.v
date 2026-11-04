module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output out
);

    parameter OFF = 2'b00;
    parameter ON  = 2'b01;

    reg [1:0] state;

    // Combinational Logic for Output
    always_comb begin
        case (state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0; // Handle any unexpected state
        endcase
    end

    // Sequential Logic for State Transition
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF:
                    if (j) begin
                        state <= ON;
                    end else begin
                        state <= OFF;
                    end
                ON:
                    if (k) begin
                        state <= OFF;
                    end else begin
                        state <= ON;
                    end
                default:
                    state <= OFF; // Handle any unexpected state
            endcase
        end
    end
endmodule