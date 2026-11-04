module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    typedef enum reg [1:0] {
        LOW = 2'b00,
        MID_LOW = 2'b01,
        MID_HIGH = 2'b10,
        HIGH = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg last_rising;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= LOW;
            last_rising <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            LOW: begin
                fr1 = 1'b1;
                fr2 = 1'b1;
                fr3 = 1'b1;
                dfr = 1'b1;
                if (s == 3'b001) begin // When sensor s[1] is asserted
                    next_state = MID_LOW;
                end else begin
                    next_state = LOW;
                end
            end

            MID_LOW: begin
                fr1 = 1'b1;
                fr2 = 1'b1;
                fr3 = 1'b0;
                if (s == 3'b011) begin // When sensors s[1], s[2] are asserted
                    next_state = MID_HIGH;
                end else if (s == 3'b000) begin // No sensors asserted
                    next_state = LOW;
                end else begin
                    next_state = MID_LOW;
                end
            end

            MID_HIGH: begin
                fr1 = 1'b1;
                fr2 = 1'b0;
                fr3 = 1'b0;
                dfr = last_rising ? 1'b1 : 1'b0;
                if (s == 3'b111) begin // When sensors s[1], s[2], s[3] are asserted
                    next_state = HIGH;
                end else if (s == 3'b001) begin // When sensor s[1] is asserted
                    next_state = MID_LOW;
                end else begin
                    next_state = MID_HIGH;
                end
            end

            HIGH: begin
                fr1 = 1'b0;
                fr2 = 1'b0;
                fr3 = 1'b0;
                dfr = 1'b0;
                if (s == 3'b011) begin // When sensors s[1], s[2] are asserted
                    next_state = MID_HIGH;
                end else begin
                    next_state = HIGH;
                end
            end

            default: begin
                fr1 = 1'b0;
                fr2 = 1'b0;
                fr3 = 1'b0;
                dfr = 1'b0;
                next_state = LOW;
            end
        endcase
    end

    always @(posedge clk) begin
        last_rising <= (current_state < next_state);
    end

endmodule