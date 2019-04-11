// avalon_wrapper_0.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module avalon_wrapper_0 (
		input  wire        reset_n,    //    clock_reset.reset_n
		input  wire        chipselect, // avalon_slave_0.chipselect
		input  wire [2:0]  address,    //               .address
		input  wire        write,      //               .write
		input  wire [31:0] writedata,  //               .writedata
		input  wire        read,       //               .read
		output wire [31:0] readdata,   //               .readdata
		input  wire        clk,        //     clock_sink.clk
		input  wire [7:0]  s_qdata,    //    conduit_end.export
		output wire [9:0]  s_addr,     //               .export
		output wire [7:0]  s_ddata,    //               .export
		output wire        s_cen,      //               .export
		output wire        s_wen,      //               .export
		output wire        s_oen,      //               .export
		output wire        s_clk,      //               .export
		output wire        led_0,      //               .export
		output wire        led_1,      //               .export
		output wire        led_2,      //               .export
		output wire        led_3       //               .export
	);

	avalon_wrapper avalon_wrapper_0 (
		.reset_n    (reset_n),    //    clock_reset.reset_n
		.chipselect (chipselect), // avalon_slave_0.chipselect
		.address    (address),    //               .address
		.write      (write),      //               .write
		.writedata  (writedata),  //               .writedata
		.read       (read),       //               .read
		.readdata   (readdata),   //               .readdata
		.clk        (clk),        //     clock_sink.clk
		.s_qdata    (s_qdata),    //    conduit_end.export
		.s_addr     (s_addr),     //               .export
		.s_ddata    (s_ddata),    //               .export
		.s_cen      (s_cen),      //               .export
		.s_wen      (s_wen),      //               .export
		.s_oen      (s_oen),      //               .export
		.s_clk      (s_clk),      //               .export
		.led_0      (led_0),      //               .export
		.led_1      (led_1),      //               .export
		.led_2      (led_2),      //               .export
		.led_3      (led_3)       //               .export
	);

endmodule
