module tb_cpu_hazard_hedge;

    integer i = 1;
    reg clk;

    cpu_hazard_hedge uut(clk);
	 
    initial begin	

	uut.im.memory_8 = {					
							8'b00100000,
							8'b00100000,
							8'b00000001,
							8'b00000001,
							8'b10101100,
							8'b10101100,
							8'b00000001,
							8'b00000001,
							8'b00100000,
							8'b00100000,
							8'b00100000,
							8'b00010010,
							8'b10001100,
							8'b00110010,
							8'b00100000,
							8'b00100000,
							8'b00100000,
							8'b00010010,
							8'b10001100,
							8'b00100000,
							8'b00100000,
							8'b00100000,
							8'b00010010,
							8'b00000010,
							8'b00100000,
							8'b00100000,
							8'b00100000,
							8'b00010010,
							8'b00000010,
							8'b00001000,
							8'b00100000,
							8'b00100000,
							8'b00001000,
							8'b00100000,
							8'b00100000,
							8'b00001000,
							8'b00100000,
							8'b00100000,
							8'b00001000,
							8'b00100000,
							8'b00100000,
							8'b00001000,
							8'b00100000,
							8'b00001000,
							8'b00100000,
							8'b00100000,
							8'b00001000
							};

       $readmemb(mem_ini, uut.im.memory_8);
		  end
		  
	 initial begin
        for (int i = 0; i < 100; i = i + 1)
            uut.im.memory[i] = {uut.im.memory_8[4*i], uut.im.memory_8[4*i+1], uut.im.memory_8[4*i+2], uut.im.memory_8[4*i+3]};
    end
		  
    initial begin
		// Initialize Inputs
        #0 clk = 0;
        $display("==========================================================");
	end

    always #10 begin
        $display("Time: %d, CLK = %d, PC = %H", i, clk, uut.pcOut_IF);
        $display("[$s0] = %H, [$s1] = %H, [$s2] = %H", uut.rf.register[16], uut.rf.register[17], uut.rf.register[18]);
        $display("[$s3] = %H, [$s4] = %H, [$s5] = %H", uut.rf.register[19], uut.rf.register[20], uut.rf.register[21]);
        $display("[$s6] = %H, [$s7] = %H, [$t0] = %H", uut.rf.register[22], uut.rf.register[23], uut.rf.register[8]);
        $display("[$t1] = %H, [$t2] = %H, [$t3] = %H", uut.rf.register[9], uut.rf.register[10], uut.rf.register[11]);
        $display("[$t4] = %H, [$t5] = %H, [$t6] = %H", uut.rf.register[12], uut.rf.register[13], uut.rf.register[14]);
        $display("[$t7] = %H, [$t8] = %H, [$t9] = %H", uut.rf.register[15], uut.rf.register[24], uut.rf.register[25]);
        clk = ~clk;
        if (~clk) i = i + 1;
    end

    initial #300 $finish;
endmodule