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
    compinput #(STRINGSIZE) comp (clock, reset, valid, CurByte, offset, Length, toCompare, NextBytes, toHash, Done, bytePtr);

    Comparator cptr (CurBytes,BytesAtOffset,ControlBit, reset,Length);

    tableOfPtr #(TABLESIZE) tob (clock,reset,InByte,fromHash,BytePosition,length,OutByte,OldBytePosition,Offset,ControlBit);

    CompressedValues #(STRINGSIZE) CV (clock,reset, Done,length,Offset,OneByte,ControlBit,compArray,controlWord,controlPtr,compressPtr);

    hashFunction hF (reset,toHash,fromHash);

    assign BytePosition = bytePtr;		// from compinput to table
    assign OneByte = OutByte; // from table to CompressedValues
    assign offset = OldBytePosition;	// from table to compinput
    assign BytesAtOffset = toCompare;	// from compinput to comparator
    assign CurBytes = NextBytes;
    assign length = Length;		// from comparator to compressedValues and table
    assign InByte = NextBytes[0];

endmodule
