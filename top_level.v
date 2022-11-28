`timescale 1ns / 1ps
module top_level(
    input reset,
    input clk,
	 output UART_TX
    );

		//address line
		wire[5:0] wr_address_to_rom ;
		wire [5:0] wr_read_address_to_ram_from_readout, wr_address_to_ram_from_cpu, wr_address_to_ram;
		
		wire wr_enable_to_rom, wr_write_to_ram_from_cpu, wr_enable_ram, wr_ram_write_enable;
		
		//data lines
		wire [15:0] wr_data_out_from_rom, wr_data_ram_from_cpu, wr_data_ram_to_cpu;
		
		wire wr_clk_read_ram, wr_read_ram, wr_reset_read_ram ;
		
		wire wr_read_enable_to_ram_from_cpu;
		

		wire wr_enable_ram_read ; 		// continuous  signal from dummy_unit to activate ram read
				
		
		//---------------- clk for the CPU (uut)
		
		wire clk_cpu, enable_cpu; //enable clk_for_CPU
		assign clk_cpu = clk ; //& enable_cpu ;
		
		// controls for read_ram_and_uart
		assign wr_clk_read_ram =  clk && wr_enable_ram_read ; //wr_enable_ram_read && clk ;
		assign wr_reset_read_ram = reset_read_ram ;									// not sure if this signal is needed.
		reg [3:0] counter_read_ram_reset ;
		
		reg reset_read_ram, reset_read_ram_done ;
		
		
		//-------------reset signal for read_ram_module------------------------
		
		
		always @ ( posedge clk )			//counter_read_ram_reset     -- to start reading ram
		begin
			if (reset) 
				counter_read_ram_reset <= 4'b0 ;
			else if ( wr_enable_ram_read && ( counter_read_ram_reset == 0 ) )
				counter_read_ram_reset <= 4'b1 ;
			else if ( ( counter_read_ram_reset != 0) && ( counter_read_ram_reset != 4'b1111 ) )	
				counter_read_ram_reset <= counter_read_ram_reset + 4'b1 ;
			else 	
				counter_read_ram_reset <= counter_read_ram_reset ;
		end
		
		
		always @ (posedge clk )					//reset_read_ram
		begin
			if (reset)
				reset_read_ram <= 0 ;
			else if ( ( counter_read_ram_reset == 4'b1111 ) && ( reset_read_ram_done != 1) )
				reset_read_ram <= 1 ;
			else 
				reset_read_ram <= 0 ;
		end
		

		always @ ( posedge clk )
		begin
			if (reset)
				reset_read_ram_done <= 0 ;
			else if ( counter_read_ram_reset == 4'b1111 )
				reset_read_ram_done <= 1 ;
			else 
				reset_read_ram_done <= reset_read_ram_done ;
		end		
		
		
		//-------------------------------------------------------------------

	ip_rom_input_code ROM (
		.clka(clk), // input clka
	   .ena(wr_enable_to_rom), // input ena
	   .addra(wr_address_to_rom), // input [5 : 0] addra
	   .douta(wr_data_out_from_rom) // output [15 : 0] douta
		);
			
		
	 myCPU dummy_unit1(										//reads ROM and writes to RAM
    .data_from_rom(wr_data_out_from_rom),						// 16 bit
    .reset(reset),
	 .clk(clk_cpu),
	 .address_to_rom(wr_address_to_rom),							// 4bit
    .enable_to_rom(wr_enable_to_rom),
	 .data_from_ram(wr_data_from_ram),										//16bit inout port
	 .data_to_ram(wr_data_to_ram),										//16bit inout port
	 .write_enable_to_ram(wr_write_to_ram_from_cpu),
	 .address_to_ram(wr_address_to_ram_from_cpu),				//4bit
	 .read_enable_to_ram(wr_read_enable_to_ram_from_cpu),
	 .enable_ram_read(wr_enable_ram_read)							//enable ram read and uart module
    );

	assign wr_enable_ram = wr_read_enable_to_ram_from_cpu || wr_write_to_ram_from_cpu  || wr_read_ram ;//enable ram 
		
	assign wr_address_to_ram =  (wr_enable_ram_read) ?  wr_read_address_to_ram_from_readout : wr_address_to_ram_from_cpu  ; //address ram


	ip_ram_output_code RAM (
	  .clka(clk), // input clka
	  .ena(wr_enable_ram), // input ena
	  .wea(wr_write_to_ram_from_cpu), // input [0 : 0] wea
	  .addra(wr_address_to_ram), // input [5 : 0] addra
	  .dina(wr_data_to_ram), // input [15 : 0] dina
	  .douta(wr_data_from_ram) // output [15 : 0] douta
	);

	 read_ram_and_uart read_ram_and_uart(
    .clk(wr_clk_read_ram),
    .reset(wr_reset_read_ram),
	 .data_from_ram(wr_data_from_ram),						//32bit
	 .read_enable_to_ram(wr_read_ram),
	 .address_to_ram(wr_read_address_to_ram_from_readout), 					//4bit
    .uart_TX(UART_TX)
    );
		




endmodule
