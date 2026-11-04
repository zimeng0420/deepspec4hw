module top_module(
	input mode,
	input too_cold, 
	input too_hot,
	input fan_on,
	output heater,
	output aircon,
	output fan
);

assign heater = mode & too_cold;                // Heater on in heating mode if too cold
assign aircon = ~mode & too_hot;                 // Air conditioner on in cooling mode if too hot
assign fan = heater | aircon | fan_on;           // Fan on if heater, air conditioner, or fan_on is active

endmodule