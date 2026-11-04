module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    reg z;

    // Define state encoding
    localparam S_ZERO = 2'b00;
    localparam S_ONE  = 2'b01;
    localparam S_REST = 2'b10; //state after the first one
    localparam S_IDLE = 2'b11;  //idle state when reset is active

    reg [1:0] current_state, next_state;


    // State register update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= S_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S_ZERO: begin
                if (x == 1'b0) begin
                    next_state = S_ZERO;
                end else begin
                    next_state = S_ONE;
                end
            end
            S_ONE: begin
                if (x == 1'b0) begin
                    next_state = S_REST;
                end else begin
                    next_state = S_REST;
                end
            end
            S_REST: begin
                 if (x == 1'b0) begin
                    next_state = S_REST;
                end else begin
                    next_state = S_REST;
                end
            end
            S_IDLE: begin
                next_state = S_ZERO;
            end
            default: next_state = S_IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            S_ZERO: begin
                z = x;
            end
            S_ONE: begin
                z = 1'b1;
            end
            S_REST: begin
                z = x;
            end
            S_IDLE: begin
                z = 1'b0;
            end
            default: z = 1'b0;
        endcase
    end

endmodule