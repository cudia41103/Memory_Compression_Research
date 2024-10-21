/*
This is the compressor input for the compressor portion of the design. 
input valid; when high save data in myHistory
input CurByte; 16 bytes from uncompressed string
input offset; old offset from tableofPtr's
input Length; amount of total chars that are the same between CurBytes and the toCompare(bytes at offset)
output toCompare;  bytes at offset to compare
output NextBytes; Current 16 bytes to compare
output toHash; 3 bytes to send to hash function
output bytePtr; current char position
output Done; end of string reached

Portland State University
ECE571 Final Project
by Mark Chernishoff, Parker Ridd, Manas Karanjekar

*/
module compinput(
input clock, reset, valid, 
input [15:0] [7:0] CurByte, 
input [11:0] offset ,
input [3:0] Length, 
output logic [15:0] [7:0] toCompare,
output logic [15:0] [7:0] NextBytes,
output logic [23:0] toHash,
output bit Done,
output integer bytePtr);

parameter HISTORY = 4096;

logic [HISTORY-1:0] [7:0] myHistory;
logic [11:0] bytePointer;
integer count;
integer s_offset;
integer j;
logic [3:0] k;

byte valueHistory;

bit [11:0] temp;
bit [11:0] temp2;
bit [31:0] result_temp;
bit [31:0] result_temp2;

assign result_temp = bytePointer - s_offset;
assign result_temp2 = HISTORY - bytePointer;
assign s_offset = (!reset) ? integer' (offset) : '0 ;
assign temp = (!reset) ? result_temp[11:0] : '0;
assign temp2 = (!reset) ? result_temp2[11:0] : '0;

always_ff @(posedge clock) begin
	
	if (reset) begin
		bytePointer <= '0;
		count <= '0;
		myHistory <= '0;
		Done <= 1'b1;
	end
	else if(!valid && 0 ==  myHistory[bytePointer+1]) Done <= 1;
	else begin
		
		// increment byte pointer if not at end of string
		// add current byte to history
		
		if(valid && (bytePointer < HISTORY)) begin
			Done <= 0;
			myHistory[count+1 +: 17] <= CurByte ;
			count <= count + 16;
		end
		
		else count <= count;
		// if first 3 bytes recieved, send to hash function
		if(Length >= 3) bytePointer <= bytePointer + Length;
		else  bytePointer <= bytePointer + 12'b1;

	end
end

always_comb begin
		toHash = '0;
		toCompare = '0;
		NextBytes = '0;
		k = 4'b0;
		if(reset) begin
			toHash = '0;
		toCompare = '0;
		NextBytes = '0;
		end
		else if (bytePointer >= 1) begin//initial condition checking
			toHash = {myHistory[bytePointer],myHistory[bytePointer+1],myHistory[bytePointer+2]};		
		end
		else toHash = toHash;
		if ((myHistory[bytePointer] != 0) && (bytePointer - s_offset) > 15 && s_offset > 0 ) begin
			toCompare = myHistory[(s_offset) +: 16];
			NextBytes = myHistory[bytePointer +: 16];
		end
		else if ((myHistory[bytePointer] != 0)  && (bytePointer - s_offset) <= 15 && s_offset > 0 ) begin
			j = 0;
			for(int i = 0; i < temp; i++) begin
				if(j < 16) begin
				toCompare[j] = myHistory[s_offset+j];
				j++;
				/*toCompare[0] = myHistory[offset];
				toCompare[1] = myHistory[offset+1];
				toCompare[2] = myHistory[offset+2];
				toCompare[3] = myHistory[offset+3];
				toCompare[4] = myHistory[offset+4];
				toCompare[5] = myHistory[offset+5];
				toCompare[6] = myHistory[offset+6];
				toCompare[7] = myHistory[offset+7];
				toCompare[8] = myHistory[offset+8];
				toCompare[9] = myHistory[offset+9];
				toCompare[10] = myHistory[offset+10];
				toCompare[11] = myHistory[offset+11];
				toCompare[12] = myHistory[offset+12];
				toCompare[13] = myHistory[offset+13];
				toCompare[14] = myHistory[offset+14];
				toCompare[15] = myHistory[offset+15];*/
				end
			//NextBytes = myHistory[bytePointer +: 16];	
			end		
			
		end
		else  begin
			toCompare = '0;
			k = 4'b0;
		end
		if (bytePointer+16 <= HISTORY) begin
			NextBytes = myHistory[bytePointer +: 16];
		end
		else if(HISTORY-bytePointer <= 0) begin
			NextBytes = '0;
		end
		else begin		
			NextBytes = '0;
			for(int i = 0; i <= temp2; i++) begin
				NextBytes[k] = myHistory[bytePointer + k];
				k = k + 4'b1;
			end
		end
end
assign bytePtr = bytePointer;
assign valueHistory = myHistory[bytePointer];

endmodule
