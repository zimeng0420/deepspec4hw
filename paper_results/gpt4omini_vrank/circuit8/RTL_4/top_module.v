module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);

reg [1:0] state;

always @(posedge clock) begin
    if (state == 0) begin
        if (a) begin
            p <= 0;
            q <= 0;
            state <= 1;
        end
    end 
    else if (state == 1) begin
        p <= 0;
        q <= 0;
        if (a) begin
            state <= 2;
        end
    end 
    else if (state == 2) begin
        if (a) begin
            p <= 1;
            q <= 0;
            state <= 3;
        end
    end 
    else if (state == 3) begin
        p <= 1;
        q <= (a) ? 0 : 1;
        if (!a) begin
            state <= 4;
        end
    end
    else if (state == 4) begin
        p <= (a) ? 1 : 0;
        q <= 1;
        if (a) begin
            state <= 5;
        end
    end 
    else if (state == 5) begin
        p <= 0;
        q <= 1;
        if (!a) begin
            state <= 6;
        end
    end 
    else if (state == 6) begin
        p <= 0;
        q <= 0;
        if (a) begin
            state <= 7;
        end
    end 
    else if (state == 7) begin
        p <= 0;
        q <= 0;
        state <= 0;
    end 
end

initial begin
    state = 0;
    p = 0;
    q = 0;
end

endmodule