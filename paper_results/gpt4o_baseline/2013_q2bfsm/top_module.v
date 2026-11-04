module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State Encoding
    typedef enum logic [3:0] {
        A = 4'd0,
        B = 4'd1,
        C = 4'd2,
        D = 4'd3,
        E = 4'd4,
        F = 4'd5,
        G = 4'd6
    } state_t;

    state_t state, next_state;
    reg [1:0] x_sequence, y_wait;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end
    // Delibrately occ query??+++printfètres..box..+++.
endmodule