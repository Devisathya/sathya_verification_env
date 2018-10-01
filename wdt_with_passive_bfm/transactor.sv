typedef enum bit [7:0]  {SINGLE='d0,INCR='d1,WRAP4='d2,INCR4='d3,WRAP8='d4,INCR8='d5,WRAP16='d6,INCR16='d7} burst_t;
typedef enum bit [2:0]  {BYTE='d0,HALF_WORD='d1,WORD='d2} size_t;
class transactor;
       rand burst_t    hburst;
       rand bit        hwrite;
       bit [31:0] hwdata_a[];
       rand bit [31:0] hwdata;
       rand bit [31:0] haddr;
       bit [31:0] haddr_a[];
 rand           size_t hsize;
        rand    bit [01:0] htrans;
            bit [01:0] htrans_a[];
            bit [31:0] hrdata;
            bit        hready;
            bit        hsel;
rand            int inc;
            int inc_num = 2;


//constraint c1 { hburst inside {2,3};}
constraint c1 { hburst inside {1};}
constraint c10 { hsize inside {0};}
constraint c11 { haddr inside {0,1};}
constraint c13 { hwrite inside {1};}
constraint c8 {solve hsize before haddr;}
constraint c9 {solve hsize before inc;}
constraint c2 { if(hsize== WORD) 
                haddr[1:0] ==2'b0;
             else if(hsize== HALF_WORD)  
              haddr[0] ==1'b0;
          }
constraint c4 { if(hsize== WORD) 
                    inc==4;
               else if(hsize== HALF_WORD)
                     inc==2;
               else if (hsize== BYTE)
                inc==1;
              }
function void post_randomize();

    case(hburst)
            SINGLE : begin
                       haddr_a = new[1];
                      foreach(haddr_a[i])
                            haddr_a[i] = haddr;
                     end

           
            INCR : begin
                       haddr_a = new[inc_num];
                      foreach(haddr_a[i])
                        if(i==0)
                          haddr_a[i] = haddr;
                        else
			begin
			 if(haddr_a[0]==0)
                          haddr_a[i] = 1;
                         else
                          haddr_a[i] = 0;
                        end
                        end
            WRAP4 : begin
                       haddr_a = new[4];
                      foreach(haddr_a[i])
                        if(i==0)
                          haddr_a[i] = haddr;
                        else
                         if(haddr_a[i-1][3:0]==4'b1100 && inc == 4)
                         begin
                          haddr_a[i][3:0] = 4'b0000;
                          haddr_a[i][31:4] = haddr_a[i-1][31:4];
                         end
                         else if(haddr_a[i-1][2:0]==4'b110 && inc == 2)
                         begin
                          haddr_a[i][2:0] = 3'b000;
                          haddr_a[i][31:3] = haddr_a[i-1][31:3];
                         end
                         else if(haddr_a[i-1][1:0]==4'b11 && inc == 1)
                         begin
                          haddr_a[i][1:0] = 2'b00;
                          haddr_a[i][31:2] = haddr_a[i-1][31:2];
                         end
                          else
                          haddr_a[i] = haddr_a[i-1]+inc;
                          
                        end


            INCR4 : begin
                       haddr_a = new[4];
                      foreach(haddr_a[i])
                        if(i==0)
                          haddr_a[i] = haddr;
                        else
                          haddr_a[i] = haddr_a[i-1]+inc;
                        end
            WRAP8 : begin
                       haddr_a = new[8];
                      foreach(haddr_a[i])
                        if(i==0)
                          haddr_a[i] = haddr;
                        else
                         if(haddr_a[i-1][4:0]==5'b11100 && inc == 4)
                         begin
                          haddr_a[i][4:0] = 5'b00000;
                          haddr_a[i][31:5] = haddr_a[i-1][31:5];
                         end
                         else if(haddr_a[i-1][3:0]==4'b1110 && inc == 2)
                         begin
                          haddr_a[i][3:0] = 4'b0000;
                          haddr_a[i][31:4] = haddr_a[i-1][31:4];
                         end
                         else if(haddr_a[i-1][2:0]==3'b111 && inc == 1)
                         begin
                          haddr_a[i][2:0] = 3'b000;
                          haddr_a[i][31:3] = haddr_a[i-1][31:3];
                         end
                          else
                          haddr_a[i] = haddr_a[i-1]+inc;
                          
                        end


            INCR8 : begin
                       haddr_a = new[8];
                      foreach(haddr_a[i])
                        if(i==0)
                          haddr_a[i] = haddr;
                        else
                          haddr_a[i] = haddr_a[i-1]+inc;
                        end
            WRAP16 : begin
                       haddr_a = new[16];
                      foreach(haddr_a[i])
                        if(i==0)
                          haddr_a[i] = haddr;
                        else
                         if(haddr_a[i-1][5:0]==6'b111100 && inc == 4)
                         begin
                          haddr_a[i][5:0] = 6'b000000;
                          haddr_a[i][31:6] = haddr_a[i-1][31:6];
                         end
                         else if(haddr_a[i-1][4:0]==5'b11110 && inc == 2)
                         begin
                          haddr_a[i][4:0] = 5'b00000;
                          haddr_a[i][31:5] = haddr_a[i-1][31:5];
                         end
                         else if(haddr_a[i-1][3:0]==4'b1111 && inc == 1)
                         begin
                          haddr_a[i][3:0] = 3'b000;
                          haddr_a[i][31:4] = haddr_a[i-1][31:4];
                         end
                          else
                          haddr_a[i] = haddr_a[i-1]+inc;
                          
                        end
            INCR16 : begin
                       haddr_a = new[16];
                      foreach(haddr_a[i])
                        if(i==0)
                          haddr_a[i] = haddr;
                        else
                          haddr_a[i] = haddr_a[i-1]+inc;
                        end


                        endcase

    case(hburst)
            SINGLE : begin
                       hwdata_a = new[1];
                      foreach(hwdata_a[i])
                            hwdata_a[i] = hwdata;
                     end
            INCR : begin
                       hwdata_a = new[inc_num];
                      foreach(hwdata_a[i])
                        if(i==0)
			begin
			 if(haddr_a[0]==0)
                          hwdata_a[i] = 8'b10000100;
                         else
                          hwdata_a[i] = 0;
                        end
			else
			begin
			 if(haddr_a[1]==0)
                          hwdata_a[i] = 8'b10000100;
                         else
                          hwdata_a[i] = 0;
			end
                        end

            INCR4 : begin
                       hwdata_a = new[4];
                      foreach(hwdata_a[i])
                        if(i==0)
                          hwdata_a[i] = hwdata;
                        else
                          hwdata_a[i] = hwdata_a[i-1]+8;
                        end
            WRAP4 : begin
                       hwdata_a = new[4];
                      foreach(hwdata_a[i])
                        if(i==0)
                          hwdata_a[i] = hwdata;
                        else
                          hwdata_a[i] = hwdata_a[i-1]+8;
                        end
            INCR8 : begin
                       hwdata_a = new[8];
                      foreach(hwdata_a[i])
                        if(i==0)
                          hwdata_a[i] = hwdata;
                        else
                          hwdata_a[i] = hwdata_a[i-1]+16;
                        end
            WRAP8 : begin
                       hwdata_a = new[8];
                      foreach(hwdata_a[i])
                        if(i==0)
                          hwdata_a[i] = hwdata;
                        else
                          hwdata_a[i] = hwdata_a[i-1]+16;
                        end
            INCR16 : begin
                       hwdata_a = new[16];
                      foreach(hwdata_a[i])
                        if(i==0)
                          hwdata_a[i] = hwdata;
                        else
                          hwdata_a[i] = hwdata_a[i-1]+18;
                        end
            WRAP16 : begin
                       hwdata_a = new[16];
                      foreach(hwdata_a[i])
                        if(i==0)
                          hwdata_a[i] = hwdata;
                        else
                          hwdata_a[i] = hwdata_a[i-1]+18;
                        end


                        endcase

    case(hburst)
            SINGLE : begin
                       htrans_a = new[1];
                      foreach(htrans_a[i])
                            htrans_a[i] = 2'b10;
                     end

           
            INCR : begin
                       htrans_a = new[inc_num];
                      foreach(htrans_a[i])
                        if(i==0)
                          htrans_a[i] = 2'b10;
                        else
                          htrans_a[i] = 2'b11;
                        end
            WRAP4 : begin
                       htrans_a = new[4];
                      foreach(htrans_a[i])
                        if(i==0)
                          htrans_a[i] = 2'b10;
                        else
                          htrans_a[i] = 2'b11;
                        end
            INCR4 : begin
                       htrans_a = new[4];
                      foreach(htrans_a[i])
                        if(i==0)
                          htrans_a[i] = 2'b10;
                        else
                          htrans_a[i] = 2'b11;
                        end
            WRAP8 : begin
                       htrans_a = new[8];
                      foreach(htrans_a[i])
                        if(i==0)
                          htrans_a[i] = 2'b10;
                        else
                          htrans_a[i] = 2'b11;
                        end
            INCR8 : begin
                       htrans_a = new[8];
                      foreach(htrans_a[i])
                        if(i==0)
                          htrans_a[i] = 2'b10;
                        else
                          htrans_a[i] = 2'b11;
                        end
            WRAP16 : begin
                       htrans_a = new[16];
                      foreach(htrans_a[i])
                        if(i==0)
                          htrans_a[i] = 2'b10;
                        else
                          htrans_a[i] = 2'b11;
                        end
            INCR16 : begin
                       htrans_a = new[16];
                      foreach(htrans_a[i])
                        if(i==0)
                          htrans_a[i] = 2'b10;
                        else
                          htrans_a[i] = 2'b11;
                        end
            default:
                     htrans = 2'b00;
             endcase



endfunction

endclass

