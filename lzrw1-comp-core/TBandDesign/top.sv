`include "TBandDesign/combined_top.sv"
`include "TBandDesign/fileReader.sv"
`include "TBandDesign/string_writer.sv"
`include "TBandDesign/driver.sv"
`include "TBandDesign/checker.sv"
`include "TBandDesign/env.sv"
`include "TBandDesign/testcase.sv"
`include "TBandDesign/interface.sv"
//`include "package.sv"
//import topPkg::*;
module top();

bit clock;

initial
	forever	#10 clock = ~clock;

/*	Input interface		*/
input_interface input_intf(clock);

/*	Output interface	*/
output_interface output_intf(clock);

/*	Program block Testcase instance		*/
testcase TC (input_intf,output_intf);

/*	Instantiating and connecting the DUT	*/
combined_top DUT(
		.clock(input_intf.clock),
		.reset(input_intf.reset),
		.valid(input_intf.valid),
		.CurByte(input_intf.CurByte),	// Current Byte to be sent to compressor
		.decompressed_byte(output_intf.decompressed_byte),					// Decompressed output
		.out_valid(output_intf.out_valid),
		.finished_cycle(output_intf.finished_cycle)
	);


endmodule	: top
