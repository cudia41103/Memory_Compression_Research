/*
This is the is the module that all the pin-level connections
 
Portland State University
ECE571 Final Project
by Mark Chernishoff, Parker Ridd, Manas Karanjekar

*/

module compressor_top #(
    parameter STRINGSIZE = 4096, 
    parameter TABLESIZE = 4096
    )(
    input logic clock, reset, valid,
    input [15:0] [7:0] CurByte,
    output logic Done,
    output logic [STRINGSIZE-1:0][7:0] compArray,
    output logic [STRINGSIZE-1:0] controlWord,
    output integer controlPtr
    );


    logic [11:0] offset; 
    logic [15:0] [7:0] toCompare; 
    logic [15:0] [7:0] NextBytes;
    logic [23:0] toHash;
    integer bytePtr;
    integer compressPtr;
    logic ControlBit;
    logic [3:0] Length;
    logic [15:0] [7:0] CurBytes,BytesAtOffset;
    byte InByte;
    logic [11:0] fromHash;
    logic [11:0] OldBytePosition,Offset;
    integer BytePosition;
    byte OutByte;

    logic [3:0] length;
    byte OneByte,prevOneByte;
    logic [15:0] prevCV;

    /* 
    COMPINPUT
        input valid; when high save data in myHistory
        input CurByte; 16 bytes from uncompressed string
        input offset; old offset from tableofPtr's
        input Length; amount of total chars that are the same between CurBytes and the toCompare(bytes at offset)
        output toCompare;  bytes at offset to compare
        output NextBytes; Current 16 bytes to compare
        output toHash; 3 bytes to send to hash function
        output bytePtr; current char position
        output Done; end of string reached
    */
    compinput #(STRINGSIZE) comp (clock, reset, valid, CurByte, offset, Length, toCompare, NextBytes, toHash, Done, bytePtr);



/*
    COMPARATOR
        input ControlBit; used for debug
        input BytesAtOffset;  bytes at offset to compare
        input NextBytes; Current 16 bytes to compare
        output Length; amount of total chars that are the same between CurBytes and the toCompare(bytes at offset)

*/
    Comparator cptr (CurBytes,BytesAtOffset,ControlBit, reset,Length);

/*
    TABLE O POINTER
        input InByte; byte to send on to CompressedValues if controlBit high
        input fromHash; 12 bits to index the TableOfPointers
        input BytePosition; the current byte position to input into the tableOfPtr
        input length; amount of bits that are the same if >2 then set controlBit hi, else low
        output OutByte; send on to CompressedValues, 0 or literal depends on ControlBit
        output OldBytePosition; if table entry !null send to value to compinput
        output Offset; send to CompressedValues
        output ControlBit; send to CompressedValues
*/
    tableOfPtr #(TABLESIZE) tob (clock,reset,InByte,fromHash,BytePosition,length,OutByte,OldBytePosition,Offset,ControlBit);

/*
    COMPRESSED VALUES
        input OneByte; byte to add to compArray
        input Offset; offset from tableofPtr's
        input Length; amount of total chars that are the same between CurBytes and the toCompare(bytes at offset)
        input ControlBit; added to controlWord array
        output compArray; an array of compressed characters
        output countrolWord; an array of 0's and 1's 
        output controlPtr; used for assertions
        output compressPtr; used for assertions
        input Done; end of string reached
*/
    CompressedValues #(STRINGSIZE) CV (clock,reset, Done,length,Offset,OneByte,ControlBit,compArray,controlWord,controlPtr,compressPtr);


/*
    HASH FUNCTION

    input toHash; 3 bytes from the compinput
    output fromHash; 12 bits to index the table
*/
    hashFunction hF (reset,toHash,fromHash);

    assign BytePosition = bytePtr;		// from compinput to table
    assign OneByte = OutByte; // from table to CompressedValues
    assign offset = OldBytePosition;	// from table to compinput
    assign BytesAtOffset = toCompare;	// from compinput to comparator
    assign CurBytes = NextBytes;
    assign length = Length;		// from comparator to compressedValues and table
    assign InByte = NextBytes[0];

endmodule
