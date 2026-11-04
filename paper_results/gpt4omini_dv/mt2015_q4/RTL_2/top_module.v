module top_module(
    input x,
    input y,
    output z
);

    // Module A
    wire z_A1, z_A2;
    wire z_B1, z_B2;
    wire or_output, and_output;

    assign z_A1 = (x ^ y) & x;
    assign z_A2 = (x ^ y) & x;

    // Module B behavior as per the given waveform
    reg z_B1_reg, z_B2_reg;
    
    always @(posedge clk) begin
        if (time >= 0 && time < 25) 
            z_B1_reg <= 1; 
        else if (time >= 25 && time < 30)
            z_B1_reg <= 0; 
        else if (time >= 35 && time < 40)
            z_B1_reg <= 0; 
        else if (time >= 45 && time < 50)
            z_B1_reg <= 1; 
        else if (time >= 55 && time < 60)
            z_B1_reg <= 1; 
        else if (time >= 60 && time < 65)
            z_B1_reg <= 0; 
        else if (time >= 70 && time < 75)
            z_B1_reg <= 1; 
        else if (time >= 75 && time < 90)
            z_B1_reg <= 0; 
        else 
            z_B1_reg <= z_B1_reg; // Hold previous state
    end

    always @(posedge clk) begin
        if (time >= 0 && time < 25) 
            z_B2_reg <= 1; 
        else if (time >= 25 && time < 30)
            z_B2_reg <= 0; 
        else if (time >= 35 && time < 40)
            z_B2_reg <= 0; 
        else if (time >= 45 && time < 50)
            z_B2_reg <= 1; 
        else if (time >= 55 && time < 60)
            z_B2_reg <= 1; 
        else if (time >= 60 && time < 65)
            z_B2_reg <= 0; 
        else if (time >= 70 && time < 75)
            z_B2_reg <= 1; 
        else if (time >= 75 && time < 90)
            z_B2_reg <= 0; 
        else 
            z_B2_reg <= z_B2_reg; // Hold previous state
    end

    assign z_B1 = z_B1_reg;
    assign z_B2 = z_B2_reg;

    // OR and AND gates
    assign or_output = z_A1 | z_B1;
    assign and_output = z_A2 & z_B2;

    // Final output
    assign z = or_output ^ and_output;

endmodule