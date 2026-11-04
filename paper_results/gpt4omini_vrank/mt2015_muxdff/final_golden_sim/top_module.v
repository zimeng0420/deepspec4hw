module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);
    
    reg [2:0] r;
    
    always @(posedge clk) begin
        if (L) begin
            r <= r_in;
        end else begin
            r <= {r[1] ^ r[2], r[0], r[2]};
        end
    end
    
    always @(posedge clk) begin
        Q <= r[q_in];
    end

endmodule

module full_module (
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);
    
    always @(posedge clk) begin
        if (L) begin
            q <= r;
        end else begin
            q <= {q[1] ^ q[2], q[0], q[2]};
        end
    end
    
endmodule

module full_module_inst1 (
    input clk,
    input L,
    input [2:0] r,
    output [2:0] q
);
    full_module instance1 (
        .r(r),
        .L(L),
        .clk(clk),
        .q(q)
    );
endmodule

module full_module_inst2 (
    input clk,
    input L,
    input [2:0] r,
    output [2:0] q
);
    full_module instance2 (
        .r(r),
        .L(L),
        .clk(clk),
        .q(q)
    );
endmodule

module full_module_inst3 (
    input clk,
    input L,
    input [2:0] r,
    output [2:0] q
);
    full_module instance3 (
        .r(r),
        .L(L),
        .clk(clk),
        .q(q)
    );
endmodule