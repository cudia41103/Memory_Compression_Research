//	LZRW1 Compression Core
//	Decompressor
// 
//	This module decompresses data that has been compressed using a LZRW1 algorithm. It accepts one piece of
// 	compressed data every time data_in_valid is driven high, and outputs one byte of data every clock cycle
//	out_valid is 1'b1. 
//	
//  When the control word is high, data_in_valid is high, and the compressor isn't busy, the decompressor
//	will go into the DECOMPRESS state. In this state, the decompressor will use the high four bits of the
//  data_in input to find the length of the compressed data (up to 15 bytes) and the low twelve bits to 
//  get the offset. It has an offset range of 4095 bytes. It outputs a distinct byte of data on deompressed_byte
//  for every cycle out_valid is 1'b1, and then goes back to the IDLE state after it is done, at which point
//  it can accept new data.
//
//	If the conditions above are met with the exception of control_word_in being 1'b0, the decompressor will simply
//  pass the byte through while writing the applicable space in its history memory. out_valid will go high for one
//  cycle to allow the byte to be passed through. After that one clock cycle, it will go back to the IDLE state.
//
//	Manas Karanjekar, Mark Chernishoff, and Parker Ridd
//	ECEn 571 Fall 2017

module decompressor_top(
		clock,				// clock input
		reset,				// reset input
		data_in,			// The 2 byte data-in field. The high bits [15:8] will be ignored if the control word is 0
		control_word_in,	// The control word that corresponds to data-in
		data_in_valid,		// when this is 1'b1, the decompressor will use the inputs
		decompressed_byte,  // the decompressed output
		out_valid,			// whether the output is valid. Don't use data if 0. Every cycle this is valid signifies a new byte out.
		decompressor_busy	// whether the decompressor is busy. When this is 1'b1, the decompressor will ignore all data inputs.
	);

	parameter HISTORY_SIZE = 4096;
	localparam HISTORY_ADDR_WIDTH = $clog2(HISTORY_SIZE);

	typedef struct packed {
		logic[3:0] length;
		logic[11:0] offset;
	} compressed_t;

	typedef union packed {
		logic[15:0] character;
		compressed_t compressed_objects;

	} data_in_t;
	
	input  logic clock, reset;
	input  data_in_t data_in;
	input  logic control_word_in;
	input  logic data_in_valid;
	output logic[7:0] decompressed_byte;
	output logic out_valid;
	output logic decompressor_busy;

	
	typedef enum {
		IDLE,
		PASS_THROUGH,
		DECOMPRESS
	} decomp_state_type;

	decomp_state_type decomp_state, decomp_state_next;
	logic[HISTORY_ADDR_WIDTH-1:0] history_out_addr, history_out_addr_next, history_in_addr, history_in_addr_next;
	logic[HISTORY_ADDR_WIDTH-1:0] history_max_addr, history_max_addr_next;
	logic[7:0] history_buffer_in;
	logic history_buffer_wr_en;
	logic[7:0] history_buffer_result;
	data_in_t data_in_fp, data_in_fp_next;
	logic control_word_in_fp, control_word_in_fp_next;

	assign data_in_int = data_in;

	// flip flops
	always_ff @ (posedge clock, posedge reset) begin
		if(reset) begin
			decomp_state <= IDLE;
			history_out_addr <= '0;
			history_in_addr <= '0;
			history_max_addr <= '0;
			data_in_fp <= '0;
			control_word_in_fp <= '0;
		end
		else if(clock) begin
			decomp_state <= decomp_state_next;
			history_out_addr <= history_out_addr_next;
			history_in_addr <= history_in_addr_next;
			history_max_addr <= history_max_addr_next;
			data_in_fp <= data_in_fp_next;
			control_word_in_fp <= control_word_in_fp_next;
		end
	end

	// decompression fsm
	// states:
	//	D_IDLE: no input, not busy
	//	D_PASS_THROUGH: regular mode -- no decompression needed on current byte
	//	D_DECOMPRESS: Currently decompressing something
	always_comb begin : decompressor_fsm
		decomp_state_next = decomp_state;
		history_out_addr_next = history_out_addr;
		data_in_fp_next = data_in_fp;
		control_word_in_fp_next = control_word_in_fp;
		history_in_addr_next = history_in_addr;
		history_buffer_in = data_in;
		history_max_addr_next = history_max_addr;
		decompressed_byte = '0;
		out_valid = 1'b0;
		history_buffer_wr_en = 1'b0;

		decompressor_busy = 1'b1;
		case(decomp_state)
			IDLE: begin
				decompressor_busy = 1'b0;
				if(data_in_valid) begin
					// 1. Flop the data
					data_in_fp_next = data_in;
					control_word_in_fp_next = control_word_in;

					

					// 2. determine the next state
					if(control_word_in == 1'b0) begin
						// 3a. write data to the history buffer and increment history pointer
						history_buffer_wr_en = 1'b1;
						if (history_in_addr < HISTORY_SIZE-1)
							history_in_addr_next = history_in_addr + 1;
						else
							history_in_addr_next = '0;
						decomp_state_next = PASS_THROUGH;
					end
					else begin
						decomp_state_next = DECOMPRESS;
						//3b. check to see if we will roll over
						if(history_in_addr  > data_in.compressed_objects.offset) begin
							history_out_addr_next = history_in_addr - data_in.compressed_objects.offset;
							history_max_addr_next = history_in_addr - data_in.compressed_objects.offset + data_in.compressed_objects.length - 1;
						end
						//4b. if we will roll over, perform special calculations
						else begin
							history_out_addr_next = HISTORY_SIZE-1-(data_in.compressed_objects.offset - history_in_addr-1);
							if(HISTORY_SIZE-1-history_out_addr_next <= (data_in.compressed_objects.length-1)) 
								history_max_addr_next = history_out_addr_next + data_in.compressed_objects.length-1;
							else
								history_max_addr_next = data_in.compressed_objects.length - (HISTORY_SIZE-1-history_out_addr_next + 1) - 1;
						end

					end
				end
			end
			PASS_THROUGH: begin
				
				//assign outputs
				decompressed_byte = data_in_fp.character[7:0];
				out_valid = 1'b1;

				decomp_state_next = IDLE;
			end
			DECOMPRESS: begin
				//assign outputs
				decompressed_byte = history_buffer_result;
				out_valid = 1'b1;

				// wtite this to the history buffer
				history_buffer_wr_en = 1'b1;
				history_buffer_in = history_buffer_result;

				// update the history in address
				if (history_in_addr < HISTORY_SIZE-1)
					history_in_addr_next = history_in_addr + 1;
				else
					history_in_addr_next = '0;
				
				if(history_out_addr != history_max_addr) begin
					if (history_out_addr < HISTORY_SIZE-1)
						history_out_addr_next = history_out_addr + 1;
					else
						history_out_addr_next = '0;
				end
				else
					decomp_state_next = IDLE;

			end
		endcase
	end

	history_buffer #(.HISTORY_SIZE(HISTORY_SIZE))
		 myhist(
			.clock(clock),
			.reset(reset), 
			.rd_addr(history_out_addr),
			.wr_addr(history_in_addr),
			.wr_en(history_buffer_wr_en),
			.data_in(history_buffer_in),
			.data_out(history_buffer_result)
		);



	// assertions
	property notidlebusy_p;
		@(posedge clock)
			disable iff(reset)
			((decomp_state === IDLE) |-> (decompressor_busy === 1'b0));
	endproperty
	notidlebusy_a : assert property(notidlebusy_p) else $error("decompressor_busy was asserted while the decompressor state was IDLE");

	property datainnotxwhenvalid_p;
		@(posedge clock)
			disable iff(reset)
			((data_in_valid === 1'b1) |-> not $isunknown(data_in));
	endproperty
	datainnotxwhenvalid_a : assert property(datainnotxwhenvalid_p) else $error("Data in was X when data_in_valid was 1'b1");

	property controlnotxwhenvalid_p;
		@(posedge clock)
			disable iff(reset)
			((data_in_valid === 1'b1) |-> not $isunknown(control_word_in));
	endproperty
	controlnotxwhenvalid_a : assert property(controlnotxwhenvalid_p) else $error("control_word_in in was X when data_in_valid was 1'b1");

	property dontoutputx_p;
		@(posedge clock)
			disable iff(reset)
			((out_valid === 1'b1) |-> not $isunknown(decompressed_byte));
	endproperty
	dontoutputx_a : assert property(dontoutputx_p) else $error("decompressed_byte was X when out_valid was 1'b1");


endmodule