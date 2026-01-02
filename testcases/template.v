task run_test();
    begin
	mst_wr(TCMP0_ADDR, 10,4'b1111);
	mst_wr(TCMP1_ADDR, 0,4'b1111);
	mst_wr(TCR_ADDR, 32'h303,4'b1111);
	wait_cycles(100);

	//
	//$display("======================================");	
  	//$display("====== Register check R/W access =====");
  	//$display("======================================");	
	//// remaining register
	//reset();
	//for (j=4;j<29;j=j+4) begin
		//reg_name(j);
		//for (i=0;i<4;i=i+1) begin
    	        	//case (i)
   	                	//0: wdata=32'h0000_0000;
   	                	//1: wdata=32'hffff_ffff;
    	                	//2: wdata=32'h5555_5555;
    	                	//default: wdata=32'haaaa_aaaa;
    	         	//endcase
		//
			//mst_wr(j,wdata,4'b1111);
                        //mst_rd(j,rdata);
                        //case (j)
                                //20,28:   cmp_data(rdata, wdata & 32'h001);
				//24:      cmp_data(rdata, 32'h000);
                                //default: cmp_data(rdata, wdata);
                        //endcase
                //end
        //end
//









	if( fail_num != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
        end
endtask

