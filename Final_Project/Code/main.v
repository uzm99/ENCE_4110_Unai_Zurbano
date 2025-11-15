
`default_nettype none

module main(
	input 				MAX10_CLK1_50,
	input 	[9:0] 	SW,
	input		[1:0]		KEY,
	output 	[9:0] 	LEDR,
	inout		[35:0]	GPIO,
	inout		[15:0]	ARDUINO_IO,
	output	[7:0]		HEX0,
	output	[7:0]		HEX1,
	output	[7:0]		HEX2,
	output	[7:0]		HEX3,
	output	[7:0]		HEX4,
	output	[7:0]		HEX5
);

wire w_clk = MAX10_CLK1_50;
wire w_rst = SW[9];
wire trig_sonic;
wire echo_sonic;
wire w_temp_sensor;
wire w_clk_1s;
wire w_tick;
wire [1:0] w_KEY;
wire w_counter_start_2s;
wire w_counter_done_2s;
wire w_counter_start_5s;
wire w_counter_done_5s;
wire w_gas_detected = !ARDUINO_IO[2];
wire w_RxD = GPIO[35]; 
wire w_TxD = GPIO[33];
wire w_lock_button; 

	// Debounce Buttons modules
	// **************************************************
	
	debounce u_db0 (
    .clk(w_clk),
    .rst(1'b0),
    .btn_raw(KEY[0]),
    .btn_level(),
    .btn_pressed(w_KEY[0]),
    .btn_released()
	);

	counter_1s Count_1sec(
		.i_clk(w_clk),
		.i_reset(w_rst),
		.i_enable(1'b1),
		.o_tick(w_tick),
		.o_strobe(w_clk_1s)
	);
	
	timer_seconds #(.SECONDS_TARGET(2)) timer_2s(
    .i_clk(w_clk_1s),
    .i_rst(w_rst),
    .i_start(w_counter_start_2s),
    .o_done(w_counter_done_2s) 
	);
	
	
	timer_seconds #(.SECONDS_TARGET(5)) timer_5s(
    .i_clk(w_clk_1s),
    .i_rst(w_rst),
    .i_start(w_counter_start_5s),
    .o_done(w_counter_done_5s) 
	);

	
	wire RxD_data_ready;
	wire [7:0] w_Char2seg;
	wire [7:0] RxD_data;
	reg [7:0] GPout;

	
	async_transmitter TX(
		.clk(w_clk), 
		.TxD(w_TxD), 
		.TxD_start(RxD_data_ready), 
		.TxD_data(GPout)
	);
	
	
	async_receiver RX(
		.clk(w_clk), 
		.RxD(w_RxD), 
		.RxD_data_ready(RxD_data_ready), 
		.RxD_data(RxD_data)
	);

	
	always @(posedge w_clk) 
		if(RxD_data_ready) 
			GPout <= RxD_data;
	
	char2seg Display(
		.char(RxD_data),
		.HEX0(w_Char2seg)
	);

assign ARDUINO_IO[3] = trig_sonic;
assign echo_sonic = ARDUINO_IO[5];
assign GPIO[31] = w_temp_sensor;
  wire [32:0] distance;
wire w_presence;
wire w_pwm_led;


  sonic_detector sc (
    w_clk,
	 w_rst,
	 trig_sonic,
	 echo_sonic,
	 distance,
	 w_presence
  );
   
	pwm_brightness (
    .clk(w_clk),            
    .rst(w_rst),
	 .i_presence(w_presence),
    .distance(distance), 
    .led(w_pwm_led)
);

	//Patterns logic
	wire [9:0] w_LEDR [4:0];
	
	Pattern1 Patt1 (
			.clk(w_clk),
			.rst(w_rst),
			.en(1'b1),
			.dir(1'b1),                 
			.counter(w_LEDR[0])
	);
	Pattern2 Patt2 (
			.clk(w_clk),
			.rst(w_rst),
			.en(1'b1),
			.dir(1'b1),                 
			.counter(w_LEDR[1])
	);
	Pattern3 Patt3 (
			.clk(w_clk),
			.rst(w_rst),
			.en(1'b1),
			.dir(1'b1),                 
			.counter(w_LEDR[2])
	);
	Pattern4 Patt4 (
			.clk(w_clk),
			.rst(w_rst),
			.en(1'b1),
			.dir(1'b1),                 
			.counter(w_LEDR[3])
	);
	Pattern5 Patt5 (
			.clk(w_clk),
			.rst(w_rst),
			.en(1'b1),
			.dir(1'b1),                 
			.counter(w_LEDR[4])
	);

	wire w_entering_password;
	wire w_intruder;
	wire w_locked;
	wire w_fire;
	wire w_wrong_password;
	wire w_locking;

	display_controller DispTime(
		.tick(w_tick),
		.char2seg(w_Char2seg),
		.i_led_dim(w_pwm_led),
		.i_entering_password(w_entering_password),
		.i_intruder(w_intruder),
		.i_locked(w_locked),
		.i_presence(w_presence),
		.i_fire(w_fire),
		.i_wrong_password(w_wrong_password),
		.i_fire_pattern(w_LEDR[2]),
		.i_intruder_pattern(w_LEDR[3]),
		.i_wrong_pattern(w_LEDR[4]),
		.i_locking(w_locking),
		.i_temp_celsius(SW[0]),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.LEDR(LEDR[9:0])
	);
	
	FSM_Home FSM0(
		.clk(w_clk),
		.reset(w_rst),	
		.i_fire(w_gas_detected),
		.i_rst_wrong(w_counter_done_2s),
		.i_presence(w_presence),
		.i_data_ready(RxD_data_ready),
		.i_char(RxD_data),
		.i_button_lock(w_KEY[0]),
		.i_lock(w_counter_done_5s),
		.o_intruder(w_intruder),
		.o_locked(w_locked),
		.o_fire_alert(w_fire),
		.o_entering_password(w_entering_password),
		.o_wrong_password(w_wrong_password),
		.o_start_counter_2s(w_counter_start_2s),
		.o_start_counter_5s(w_counter_start_5s),
		.o_locking(w_locking),
		.o_state()
);

endmodule

`default_nettype wire