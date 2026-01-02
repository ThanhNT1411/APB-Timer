module test_bench;
    reg  sys_clk;
    reg  sys_rst_n;
    reg  tim_psel;
    reg  tim_penable;
    reg  tim_pwrite;
    reg  [11:0] tim_paddr;
    reg  [31:0] tim_pwdata;
    reg  [3:0]  tim_pstrb;
    wire [31:0] tim_prdata;
    wire tim_pslverr;
    wire tim_pready;
    wire tim_int;
    reg  dbg_mode;

    integer i,j;
    integer fail_num;
    reg [31:0] rdata;
    reg [31:0] wdata;
    reg err;

    timer_top dut (
        .sys_clk        ( sys_clk       ),
        .sys_rst_n      ( sys_rst_n     ),
        .tim_psel       ( tim_psel      ),
        .tim_penable    ( tim_penable   ),
        .tim_pwrite     ( tim_pwrite    ),
        .tim_paddr      ( tim_paddr     ),
        .tim_pwdata     ( tim_pwdata    ),
        .tim_prdata     ( tim_prdata    ),
        .tim_pstrb      ( tim_pstrb     ),
        .tim_pslverr    ( tim_pslverr   ),
	.tim_pready     ( tim_pready    ),
	.tim_int        ( tim_int       ),
	.dbg_mode       ( dbg_mode      )
);
    parameter STRB_FULL  = 4'b1111;
    parameter TCR_ADDR   = 12'h0;
    parameter TDR0_ADDR  = 12'h4;
    parameter TDR1_ADDR  = 12'h8;
    parameter TCMP0_ADDR = 12'hC;
    parameter TCMP1_ADDR = 12'h10;
    parameter TIER_ADDR  = 12'h14;
    parameter TISR_ADDR  = 12'h18;
    parameter THCSR_ADDR = 12'h1C;

    `include "run_test.v"

    initial begin 
  	sys_clk = 0;
	forever #25 sys_clk = ~sys_clk;
    end

    initial begin
	sys_rst_n = 1'b0;
  	#10 sys_rst_n = 1'b1;
    end

    initial begin
        tim_psel    = 0;
        tim_penable = 0;
        tim_pwrite  = 0;
        tim_paddr   = 0;
        tim_pwdata  = 0;
	tim_pstrb   = 0;
	dbg_mode    = 0;

	fail_num    = 0;
	err         = 0;
	wdata       = 0;
	rdata       = 0;
	i           = 0;
	j           = 0;

	#100;
	run_test();
	#100;
        $finish;
    end

    // checker
    task cmp_data;
	    input [31:0]   actual_data;
	    input [31:0]   expect_data;
	    begin

		    if(actual_data === expect_data) begin
			    $display("[----------------------------------------------");
			    $display("t=%0t ==> PASS ",$time);
			    $display("actual=%x, exp=%x",actual_data,expect_data);
			    $display("-----------------------------------------------]");
		    end else begin
			    fail_num=fail_num+1;
			    $display("[!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			    $display("t=%0t ==> FAIL <=== ",$time);
			    $display("actual=%x, exp=%x",actual_data,expect_data);
			    $display("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!]");
		    end
	    end
    endtask

    task cnt_cmp_data;
	    input [31:0]   actual_data;
	    input [31:0]   expect_data;
	    begin

		    if(actual_data === expect_data) begin
			    $display("[----------------------------------------------");
			    $display("t=%0t ==> PASS ",$time);
			    $display("actual=%d, exp=%d",actual_data,expect_data);
			    $display("-----------------------------------------------]");
		    end else begin
			    fail_num=fail_num+1;
			    $display("[!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			    $display("t=%0t ==> FAIL <=== ",$time);
			    $display("actual=%d, exp=%d",actual_data,expect_data);
			    $display("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!]");
		    end
	    end
    endtask


    task pslverr_check;
	    input err_expect;
	    begin
		    if(err === err_expect) begin
			    $display("[----------------------------------------------");
			    $display("t=%0t ==> PASS ",$time);
			    $display("pslverr actual=%b, pslverr exp=%b.", err, err_expect);
			    $display("-----------------------------------------------]");
		    end else begin
			    $display("[!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			    $display("t=%0t ==> FAIL <=== ",$time);
			    $display("pslverr actual=%b, pslverr exp=%b." ,err, err_expect);
			    $display("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!]");
			    fail_num=fail_num+1;
		    end
	    end
    endtask
		  

    //Write code for master read/write task
    task mst_wr;
	input [11:0] address;
	input [31:0] data_write;
	input [3:0]  strb;
	begin
		$display("write data: addr=12'h%x, wdata=32'h%x, pstrb=4'b%b",address,data_write,strb);
		// setup pharse	
		@(posedge sys_clk); #1;
		tim_psel   = 1'b1;
		tim_penable= 1'b0;
		tim_pwrite = 1'b1;
		tim_paddr  = address;
		tim_pwdata = data_write;
		tim_pstrb  = strb;

		//access pharse
		@(posedge sys_clk); #1;
		tim_penable= 1'b1;
		
		wait (tim_pready === 1'b1); #1;
		err = tim_pslverr;

		// end of transfer
		@(posedge sys_clk); #1;
		tim_pwrite = 1'b0;
		tim_psel   = 1'b0;
		tim_penable= 1'b0;
		tim_pstrb  = 4'b0;
	end
    endtask

    task mst_rd;
	input [11:0] address;
	output [31:0] data_receive;
	begin
		//setup pharse
		@(posedge sys_clk); #1;
		tim_psel   = 1'b1;
		tim_penable= 1'b0;
		tim_pwrite = 1'b0;
		tim_pstrb  = 4'b0;
		tim_paddr  = address;
		
		//access pharse
		@(posedge sys_clk); #1;
		tim_penable= 1'b1;

		wait (tim_pready === 1'b1); #1;
		data_receive = tim_prdata;
			
		//end of transfer
		@(posedge sys_clk); #1;
		tim_pwrite = 1'b0;
		tim_psel   = 1'b0;
		tim_penable= 1'b0;
		$display("read data: addr=12'h%x, rdata=32'h%x",address,data_receive);
	end
    endtask
    
    task cnt_mst_wr;
	input [11:0] address;
	input [31:0] data_write;
	input [3:0]  strb;
	begin
		$display("write data: addr=12'h%x, wdata=32'h%x, pstrb=4'b%b",address,data_write,strb);
		// access pharse
		@(posedge sys_clk); #1;
		tim_psel   = 1'b1;
		tim_penable= 1'b1;
		tim_pwrite = 1'b1;
		tim_paddr  = address;
		tim_pwdata = data_write;
		tim_pstrb  = strb;
		
		wait (tim_pready === 1'b1); #1;
		err = tim_pslverr;

		// end of transfer
		@(posedge sys_clk); #1;
		tim_pwrite = 1'b0;
		tim_psel   = 1'b0;
		tim_penable= 1'b0;
		tim_pstrb  = 4'b0;
	end
    endtask

    task cnt_mst_rd;
	input [11:0] address;
	output [31:0] data_receive;
	begin
		//access pharse
		@(posedge sys_clk); #1;
		tim_psel   = 1'b1;
		tim_penable= 1'b1;
		tim_pwrite = 1'b0;
		tim_pstrb  = 4'b0;
		tim_paddr  = address;
		
		wait (tim_pready === 1'b1); #1;
		data_receive = tim_prdata;
			
		//end of transfer
		@(posedge sys_clk); #1;
		tim_pwrite = 1'b0;
		tim_psel   = 1'b0;
		tim_penable= 1'b0;
		$display("read data: addr=12'h%d, rdata=32'h%d",address,data_receive);
	end
    endtask

    task reg_name;
        input [32:0] add;
        begin
		$display("");   
                case (add)
			0:  $display("====== TCR register   =======");
			4:  $display("====== TDR0 register  =======");
			8:  $display("====== TDR1 register  =======");
			12: $display("====== TCMP0 register =======");
			16: $display("====== TCMP1 register =======");
			20: $display("====== TIER register  =======");
			24: $display("====== TISR register  =======");
			28: $display("====== THCSR register =======");
			default:  $display("====== Reserved register =======");
                endcase
        end
    endtask

    task reset;
	begin
		sys_rst_n = 0;
		#10; sys_rst_n = 1;
	end
    endtask

    task wait_cycles;
	input [32:0] times;
	begin
		repeat(times) begin
			@(posedge sys_clk); #1;
		end
	end
    endtask

endmodule
