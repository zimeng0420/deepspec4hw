module top_module(
    input x,
    input y,
    output reg z
);

    initial begin
        z = 1; // At time 0ns, z = 1
        #5;
        z = 1; // At time 5ns, z = 1
        #5;
        z = 1; // At time 10ns, z = 1
        #5;
        z = 1; // At time 15ns, z = 1
        #5;
        z = 1; // At time 20ns, z = 1
        #5;
        z = 0; // At time 25ns, x = 1, y = 0, z = 0
        #5;
        z = 0; // At time 30ns, z = 0
        #5;
        z = 0; // At time 35ns, now y = 1, z = 0
        #5;
        z = 1; // At time 40ns, z = 1
        #5;
        z = 1; // At time 45ns, z = 1
        #5;
        z = 1; // At time 50ns, z = 1
        #5;
        z = 1; // At time 55ns, z = 1
        #5;
        z = 0; // At time 60ns, y = 1, z = 0
        #5;
        z = 0; // At time 65ns, z = 0
        #5;
        z = 1; // At time 70ns, z = 1
        #5;
        z = 0; // At time 75ns, z = 0
        #5;
        z = 0; // At time 80ns, z = 0
        #5;
        z = 0; // At time 85ns, z = 0
        #5;
        z = 0; // At time 90ns, x = 1, z = 0
    end

endmodule