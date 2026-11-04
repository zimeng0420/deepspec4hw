module top_module (
    input clock,
    input a,
    output reg p,
    output reg q
);

    always @(posedge clock) begin
        if (clock) begin
            case (a)
                1'b0: begin
                    if (q == 1'b1) begin
                        p <= 1'b0;
                        q <= 1'b1;
                    end
                    else begin
                        p <= 1'b0;
                        q <= 1'b0;
                    end
                end
                1'b1: begin
                    if (q == 1'b0) begin
                        p <= 1'b1;
                        q <= 1'b0;
                    end
                    else begin
                        p <= 1'b1;
                        q <= 1'b1;
                    end
                end
            endcase
        end
        else begin
            //keep the previous values, no change during clock=0 according to the waveform.
        end
    end
endmodule