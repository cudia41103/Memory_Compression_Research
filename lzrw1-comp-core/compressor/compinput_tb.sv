/*
This is the testbench for the compressor portion of the design. 
input s; a string of characters
output compArray; an array of compressed characters
output countrolWord; an array of 0's and 1's 

Portland State University
ECE571 Final Project
by Mark Chernishoff, Parker Ridd, Manas Karanjekar

*/
module compinput_tb ();
parameter STRINGSIZE = 350;
parameter TABLESIZE = 4096;
parameter RANDTABLE = 4095;
localparam delay = 5ns;
bit clock, reset, valid;
logic [15:0] [7:0] CurByte; 
bit Done;
logic[RANDTABLE:0][11:0] uniqnums;
logic [STRINGSIZE - 1:0] controlWord;
logic [STRINGSIZE-1:0][7:0] compArray;
logic [STRINGSIZE -1:0][7:0] testString;
integer controlPtr;

integer nums;
int newPtr;
logic [7:0] newByte;
compressor_top #(.STRINGSIZE(STRINGSIZE),.TABLESIZE(TABLESIZE)) ctop (.*);
int assertions_cnt;

string s;
int k;
int m;
initial begin
	clock = 0;
	reset = 1; 
	#(2*delay) reset = 0;

end

always begin
#delay
clock <= ~clock;
end
initial begin
        $fsdbDumpfile("dump.fsdb");
        $fsdbDumpvars(0);
end
initial begin
k = 0;
m = 0;

		$display("...Starting input");
	@(posedge clock);
	if(!reset) begin
	s = "daddy finger daddy finger where are you, here I am, here I am where are you.\n new line\0";
	// s = "When Munch died in January 1944, it transpired that he had unconditionally bequeathed all his remaining works to the City of Oslo. Edvard Munch's art is the most significant Norwegian contribution to the history of art, and he is the only Norwegian artist who has exercised a decisive influence on European art trends, above all as a pioneer of";

	 k = 0;
for(int i = 0; i < STRINGSIZE; i++) begin
	testString[k] = s.getc(k);
	k++;
end 
valid = 1;
for (int i = 0; m < STRINGSIZE ; i++) begin
	
			CurByte = (testString[m +:16]);			
			
		@(posedge clock)
		m = m + 16;
	end
	
	valid = 0;		
		$display("...Starting input part 2");

	end
	wait (Done)
	$display("Input string= %s\n\n", s);
	// $display("Compressed string= %s", compArray);
	$write("String: ");
    for (int i = 0; i < STRINGSIZE; i = i + 1) begin
        $write("%c", compArray[i]); // Print each 8-bit element as a character
    end
    $write("\n\n"); // Add a newline at the end
	$display("amount of assertions checked = %d", assertions_cnt);
	reset = 1; 
		#(4*delay) reset = 0;
end


// used for assertion properties
always begin

@(posedge clock) newPtr = (ctop.length+ctop.bytePtr);
 newByte = ctop.CV.OneByte; 		

end

////////////////////////////
// assertion properties

property p_bytePtr;
@(negedge clock)
	disable iff(reset || Done)	
	(ctop.length >= 3) |=>  newPtr == ctop.bytePtr;
	
endproperty
a_bytePtr: assert property (p_bytePtr) assertions_cnt++;

property p_tableEntry;
@(negedge clock)
	disable iff(reset)	
	(ctop.ControlBit) |-> (ctop.comp.offset > 0);
	
endproperty
a_tableEntry: assert property (p_tableEntry) assertions_cnt++;

property p_offsetnotzero;
@(negedge clock)
	disable iff(reset || Done)	
	(ctop.ControlBit) |->  ((ctop.tob.BytePosition - ctop.comp.offset) == ctop.Offset);
endproperty
a_offsetnotzero: assert property (p_offsetnotzero) assertions_cnt++;

property p_lengthnotzero;
@(negedge clock)
	disable iff(reset  || Done || ctop.length < 3)	
	(ctop.ControlBit) |-> (ctop.length >= 3);
endproperty
a_lengthnotzero: assert property (p_lengthnotzero) assertions_cnt++;

property p_outputwhenlow;
@(negedge clock)
	disable iff(reset  || Done || ctop.CV.compressPtr == 0 || newByte === 0)	
	(!ctop.ControlBit) |-> (compArray[ctop.CV.compressPtr-1] === newByte);
endproperty
a_outputwhenlow: assert property (p_outputwhenlow) assertions_cnt++;
				else $display("a_outputwhenlow:time %t, Ptr = %d; compArray = %d; newByte = %s", $time, ctop.CV.compressPtr, compArray[ctop.CV.compressPtr], newByte );

/*
property p_outputwhenhi;
@(negedge clock)
	disable iff(reset  || Done || ctop.CV.compressPtr == 0 )	
	(ctop.ControlBit) |=> ({compArray[ctop.CV.compressPtr],compArray[ctop.CV.compressPtr+1]} === {ctop.length,ctop.Offset});
endproperty
a_outputwhenhi: assert property (p_outputwhenhi) assertions_cnt++;
				else $display("a_outputwhenhi: time %t, Ptr = %d; compArray-1 = %d; compArray = %d; Length =%d; Offset=%d ", $time, ctop.CV.compressPtr, compArray[ctop.CV.compressPtr], compArray[ctop.CV.compressPtr+1], ctop.length, ctop.Offset );
*/
property p_ctrlbitwhenlow;
@(negedge clock)
	disable iff(reset  || Done )	
	(!ctop.ControlBit) |=> (controlWord[ctop.CV.controlPtr] === 0);
endproperty
a_ctrlbitwhenlow: assert property (p_ctrlbitwhenlow) assertions_cnt++;

property p_ctrlbitwhenhi;
@(negedge clock)
	disable iff(reset  || Done)
	(ctop.ControlBit) |=> (controlWord[ctop.CV.controlPtr -1] === 1);
endproperty
a_ctrlbitwhenhi: assert property (p_ctrlbitwhenhi) assertions_cnt++;
				else $display("time %t, Ptr = %d;", $time, ctop.CV.controlPtr);

property p_lengthwhenctrlbithi;
@(negedge clock)
	disable iff(reset  || Done)
	(ctop.ControlBit) |-> (ctop.length >= 3);
endproperty
a_lengthwhenctrlbithi: assert property (p_lengthwhenctrlbithi) assertions_cnt++;
						else $display("time %t, fromHash = %d;", $time, ctop.hF.fromHash);				
				
endmodule
