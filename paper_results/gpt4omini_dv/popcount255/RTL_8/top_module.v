module top_module (
    input [254:0] in,
    output reg [7:0] out
);
    
    integer i;
    reg [7:0] count [0:7];

    always @(*) begin
        // Initialize count
        for (i = 0; i < 8; i = i + 1) begin
            count[i] = 0;
        end
        
        // Count the bits in chunks of 32
        for (i = 0; i < 32; i = i + 1) begin
            count[0] = count[0] + in[i];
            count[1] = count[1] + in[i + 32];
            count[2] = count[2] + in[i + 64];
            count[3] = count[3] + in[i + 96];
            count[4] = count[4] + in[i + 128];
            count[5] = count[5] + in[i + 160];
            count[6] = count[6] + in[i + 192];
            count[7] = count[7] + in[i + 224];
        end
        
        // Reduce to final count
        out = count[0] + count[1] + count[2] + count[3] + count[4] + count[5] + count[6] + count[7];
    end
    
endmodule