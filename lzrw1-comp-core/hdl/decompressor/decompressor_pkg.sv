	
package decompressor_types;
    typedef struct packed {
		logic[3:0] length;
		logic[11:0] offset;
	} compressed_t;

	typedef union packed {
		logic[15:0] character;
		compressed_t compressed_objects;

	} data_in_t;

endpackage