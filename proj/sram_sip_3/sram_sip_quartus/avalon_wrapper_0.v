// avalon_wrapper_0.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module avalon_wrapper_0 (
		input  wire [2:0]  address,    // avalon_slave_0.address
		input  wire        write,      //               .write
		input  wire [31:0] writedata,  //               .writedata
		input  wire        read,       //               .read
		output wire [31:0] readdata,   //               .readdata
		input  wire        chipselect, //               .chipselect
		input  wire        reset_n,    //    clock_reset.reset_n
		output wire        led_0,      //    conduit_end.export
		output wire        led_1,      //               .export
		output wire        led_2,      //               .export
		output wire        led_3,      //               .export
		output wire [9:0]  s_addr,     //               .export
		output wire        s_cen,      //               .export
		output wire        s_clk,      //               .export
		output wire [7:0]  s_ddata,    //               .export
		output wire        s_oen,      //               .export
		input  wire [7:0]  s_qdata,    //               .export
		output wire        s_wen,      //               .export
		input  wire        avalon_clk, //     clock_sink.clk
		input  wire        clk         //  conduit_end_1.export
	);

	avalon_wrapper avalon_wrapper_0 (
		.address    (address),    // avalon_slave_0.address
		.write      (write),      //               .write
		.writedata  (writedata),  //               .writedata
		.read       (read),       //               .read
		.readdata   (readdata),   //               .readdata
		.chipselect (chipselect), //               .chipselect
		.reset_n    (reset_n),    //    clock_reset.reset_n
		.led_0      (led_0),      //    conduit_end.export
		.led_1      (led_1),      //               .export
		.led_2      (led_2),      //               .export
		.led_3      (led_3),      //               .export
		.s_addr     (s_addr),     //               .export
		.s_cen      (s_cen),      //               .export
		.s_clk      (s_clk),      //               .export
		.s_ddata    (s_ddata),    //               .export
		.s_oen      (s_oen),      //               .export
		.s_qdata    (s_qdata),    //               .export
		.s_wen      (s_wen),      //               .export
		.avalon_clk (avalon_clk), //     clock_sink.clk
		.clk        (clk)         //  conduit_end_1.export
	);

endmodule
