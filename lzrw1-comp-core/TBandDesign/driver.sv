//`include "fileReader.sv"
//`include "string_writer.sv"
class driver;
/* Create objects of class file_reader and string_writer */
file_reader fr;
text_writer tw;
int no_of_words;

/* Declaring interface */
virtual input_interface.IP input_intf;

function new(virtual input_interface.IP input_intf_new);
this.input_intf = input_intf_new;
endfunction


task start(input logic [1:0] input_string_sel);
$display("-D\t Inside start method of the driver");
/* We first generate a test file */
tw = new;	// Create object and allocate memory
fr = new(input_intf);	// Create object and allocate memory

	case (input_string_sel)
	2'b00 : 	begin
		completely_random cr;
		$display("Creating Completely Random String");
		cr = new();
		tw = cr;
		cr.randomize();
		no_of_words = cr.no_of_characters;
		for(int i=0;i<no_of_words;i++)
			begin
			cr.randomize();
			tw.str_gen();
			end	
		tw.open_file();
		tw.write_to_file();
		tw.close_file();
		end

	2'b01 : 	begin
		moderately_random mr;
		$display("Creating Moderately Random String");
		mr = new();
		tw = mr;
		mr.randomize();
		no_of_words = mr.no_of_characters;
		for(int i=0;i<no_of_words;i++)
			begin
			mr.randomize();
			tw.str_gen();
			end	
		tw.open_file();
		tw.write_to_file();
		tw.close_file();
		end

	2'b10: 	begin
		all_strings_same ar;
		$display("Creating All Strings Identically");
		ar = new();
		tw = ar;
		ar.randomize();
		no_of_words = ar.no_of_characters;
		for(int i=0;i<no_of_words;i++)
			begin
			ar.randomize();
			tw.str_gen();
			end	
		tw.open_file();
		tw.write_to_file();
		tw.close_file();
		end
	endcase

/* At this stage we have the randomly generated test file ready */
$display("****************New test file generated**************");

fr.read_data();
fr.drive_data();

endtask	: start



endclass	:	driver
