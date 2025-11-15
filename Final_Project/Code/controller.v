module controller (
  clock,
  lcd_busy,
  internal_reset,
  rom_address,
  data_ready
);

input clock;
input lcd_busy;
input internal_reset;
output [3:0] rom_address;
output data_ready;

reg [3:0] rom_address = 4'b0000;
reg data_ready = 1'b0;
reg current_lcd_state = 1'b0;
reg halt = 1'b0;

reg old_reset = 1'b0;

always @ (posedge clock) begin

  // resets the demo on the push button
  if (internal_reset) begin 
     rom_address <= 4'b0000;
     data_ready <= 1'b0;            
     current_lcd_state <= 1'b0;
     halt <= 1'b0;
  end

  // prepares for the reset by flipping halt when the pushbutton
  // is pushed (the reset will actually execute when the button
  // is released - but halt needs to be false a clock-tick ahead)
  if (old_reset != internal_reset) begin
    old_reset <= internal_reset;
     if (internal_reset == 1'b0) begin
       halt <= 1'b0;
     end
  end
   

  // stops the demo after one run through the ROM
  if (rom_address == 4'b1111) begin    
    halt <= 1'b1;
    data_ready <= 1'b0;
  end


  // this logic monitors the LCD module busy flag
  // when the LCD goes from busy to free, the controller raises the 
  // data ready flag and the output of the ROM is presented to the LCD module
  // when the LCD goes from free to busy, the controller increments the
  // ROM address to be ready for the next cycle
        
                   
  if (halt == 1'b0) begin                        
    if (current_lcd_state != lcd_busy) begin   
      current_lcd_state <= lcd_busy;
      if (lcd_busy == 1'b0) begin
        data_ready <= 1'b1;
      end
      else if (lcd_busy == 1'b1 && data_ready == 1'b1) begin
        rom_address <= rom_address + 4'b0001;
        data_ready <= 1'b0;
      end
    end
  end



end



endmodule