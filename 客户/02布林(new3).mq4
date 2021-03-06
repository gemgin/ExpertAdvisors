
#property copyright "起航 QQ:114663684"
#property link      "11111"
#property version   "1.00"
#property strict

enum fangxiang
  {
 只做多=0,只做空=1,多空都做=2  
  };

enum kaiguan
  {
      shi,//是
      fou//否
  };
input kaiguan Stratgy_1=shi;//是否使用组1参数做单
input kaiguan Stratgy_2=shi;//是否使用组2参数做单
 extern      double          上线价格=0;
 extern      double          下线价格=0;

extern   fangxiang          开单方式选择=2;  
extern   double              Lots=0.1;//交易手数(固定手数)

extern   int                 止盈点数=100;
//extern   int                  加仓间距=100;
extern   double                 加仓倍数=2.0;
extern   double                 加仓倍数1=2.0;
extern   double                 加仓倍数2=2.0;
extern   double                 加仓倍数3=2.0;
extern   int                  最多加仓次数=10;
extern   double               最大加仓手数=1;
extern   int                  亏损多少金额=100;


extern    int                 间距=70;
extern    int                 间距1=100;
extern    int                 间距2=150;
extern    int                 间距3=150;
//extern   string            开启时间2="13:00:00";
//extern   string            结束时间2="23:40:00";
extern    string 第一组布林带通道="";//第1组布林带通道
extern    int                 时间周期=20;
extern    double               偏差=2;
extern    int                  平移=0;
extern ENUM_APPLIED_PRICE 应用于=PRICE_CLOSE;//应用于
extern    double                  超出多少点=10;
extern string 第1组envelopes="";//第1组envelopes
input kaiguan EnverUseOrNot_c1=shi;//是否在组1使用envelopes指标
extern int period_enver_1=144;//时间周期
extern int move_enver_1=0;//平移
extern ENUM_MA_METHOD type_enver_1=MODE_SMA;//移动平均
extern ENUM_APPLIED_PRICE applied_enver_1=PRICE_CLOSE;//应用于
extern double deviation_enver_1=0.1;//偏差(%)

   int                 Loss=0;//止损
   int                 Profit=0;//止赢


extern    string 第2组布林带通道="";//第2组布林带通道
extern    int                 period_bands_c2=20;//布林带周期
extern    double              deviation_bands_c2=2;//偏差
extern    int                  shift_bands_c2=0;//平移
extern ENUM_APPLIED_PRICE applied_bands_c2=PRICE_CLOSE;//应用于
extern    double                  range_bands_c2=10;//超出多少点
extern string 第2组envelopes="";//第2组envelopes
extern int period_enver_2=144;//时间周期
extern int move_enver_2=0;//平移
extern ENUM_MA_METHOD type_enver_2=MODE_SMA;//移动平均
extern ENUM_APPLIED_PRICE applied_enver_2=PRICE_CLOSE;//应用于
extern double deviation_enver_2=0.1;//偏差(%)
extern double range_enver_2=200;//超出多少建仓点
extern int BarNumber=40;//有效期为X根K线内
input double Lots_c2=0.1;//组2手数
input double Add_Lots_Range=100;//固定加仓间隔
input double jiacangbeishu=1;//加仓倍数
input double Profit_c2=200;//止盈点数
input double Loss_c2=200;//止损点数
input int maxorder=1;//最大加仓次数
input int maxlots=1;//最大加仓手数

input string 两个识别码不要填相同的数值="";//两个识别码不要填相同的数值
extern   int                 MAGICMA=20010101;//组1EA识别码（每个EA设为不同数字）
extern   int                 MAGICMA_c2=20010102;//组2EA识别码（每个EA设为不同数字）
extern   bool                是否显示信息框=true;
extern   int                 信息框字体大小=8;//信息框字体大小(因电脑分辨率问题导致显示不正常，可以调整该字体大小)   
extern   bool                蜡烛图=true;//(true: 蜡烛图   false: 美国线)
extern   color               阳线颜色=Red;
extern   color               阴线颜色=Lime;


bool buy_Enver_c1=FALSE;
bool sell_Enver_c1=FALSE;

int ticketnumber_c2=0;

int ticket_buy=0;
int ticket_sell=0;

bool buy_c2=FALSE;
bool sell_c2=FALSE;

datetime Time_Buy_c1=0;
datetime Time_Sell_c1=0;
datetime Time_Buy_c2=0;
datetime Time_Sell_c2=0;


bool closebuy_c2=FALSE;
bool closesell_c2=FALSE;


datetime time1;
int bk=0,sk=0,bp=0,sp=0;

datetime initime;

int        间隔毫秒=100;


datetime time0=D'2020.11.20 00:00'; 
int        AA=10125632 ;
int        BB=615367;
int        CC=616126;
int        DD=615596;
int        EE=760212547; 

int      weishu=0;
int OnInit()
  {
      ticketnumber_c2=lastticketnumber_history(MAGICMA_c2);
        while(MathMod(MarketInfo(Symbol(),MODE_MINLOT)*MathPow(10,weishu),1)!=0)
    {
     weishu=weishu+1;
    } 
   EventSetMillisecondTimer(间隔毫秒);  
  ChartSetInteger(0,CHART_SHOW_GRID,false);
  ChartSetInteger(0,CHART_MODE,蜡烛图);
  ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,阳线颜色);
  ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,阴线颜色);
  ChartSetInteger(0,CHART_COLOR_CHART_UP,阳线颜色);  
  ChartSetInteger(0,CHART_COLOR_CHART_DOWN,阴线颜色);
  
  initime=TimeCurrent();
 //  time1=Time[0];
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
  for(int ixx=0;ixx<=16;ixx++)ObjectDelete("[114663684]"+string(ixx)+"0");
  for(int ixx=0;ixx<=16;ixx++)ObjectDelete("[114663684]"+string(ixx)+"1");
  ObjectDelete("BODER");
  ObjectDelete("平仓");
  ObjectDelete("一键平多单");
  ObjectDelete("一键平空单");
  ObjectDelete("暂停");
  EventKillTimer();
  }

void OnTimer()
{
      int diff=0;
      if(ChartGetInteger(0,CHART_SHOW_ONE_CLICK,0)==true)diff=70;
      int X=10,X1=160;
      int Y=18;
      int Y间隔=17;
      color 标签颜色=Yellow;

      ENUM_BASE_CORNER 固定角=0;      
      string comment=Symbol()+myPeriodStr(Period()); 
         
      string 内容[100],内容1[100];
      color 颜色[100],颜色1[100];
      
      int   字体[100],字体1[100];
      int   YY间隔[100],YY间隔1[100];
      
      
      ArrayInitialize(颜色,标签颜色);
      ArrayInitialize(颜色1,标签颜色);
      ArrayInitialize(字体,信息框字体大小);
      ArrayInitialize(字体1,信息框字体大小);
      ArrayInitialize(YY间隔,Y间隔);
      //ArrayInitialize(YY间隔1,Y间隔);
            
      if(是否显示信息框 && IsOptimization()==false)
        {
         string cur="",cur1="";
         if(StringLen(string(TimeMonth(TimeCurrent())))==1)cur="0";
         if(StringLen(string(TimeDay(TimeCurrent())))==1)cur1="0";
         
         string loc="",loc1="";
         if(StringLen(string(TimeMonth(TimeLocal())))==1)loc="0";
         if(StringLen(string(TimeDay(TimeLocal())))==1)loc1="0";
         
         YY间隔[1]+=2;
         YY间隔[2]+=2;  
         YY间隔[4]+=2; 
         YY间隔[3]+=2;  
         YY间隔[8]+=2;   
         YY间隔[9]+=0;      
         YY间隔[10]+=-3;  
         YY间隔[11]+=-1;
         YY间隔[15]+=-3;
         YY间隔[16]+=-4;
         buttom("BODER","","",10,20+diff,260,120,CORNER_LEFT_UPPER,CHART_COLOR_BACKGROUND,clrBrown,CHART_COLOR_BACKGROUND,clrBrown,13);        
         buttom1("平仓","正在平仓...","一键平EA仓",80,23,70,18,3,clrGold,clrBrown,clrGold,clrBrown,8); 
         buttom1("一键平多单","正在平仓...","一键平多单",80,61,70,18,3,clrGold,clrBrown,clrGold,clrBrown,8);
         buttom1("一键平空单","正在平仓...","一键平空单",80,42,70,18,3,clrGold,clrBrown,clrGold,clrBrown,8); 
         buttom1("暂停","已暂停..","未暂停",121,61,40,56,3,clrGold,clrBrown,clrGold,clrBrown,8);
        // 内容[0]="    EA   统   计   数   据";
        // 字体[0]=字体[0]+3;
         
       //  内容[1]=" 平台时间:"+cur+string(TimeMonth(TimeCurrent()))+"."+cur1+string(TimeDay(TimeCurrent()))+" "+TimeToStr(TimeCurrent(),TIME_MINUTES)
               //   +" "+"  北京时间:"+loc+string(TimeMonth(TimeLocal()))+"."+loc1+string(TimeDay(TimeLocal()))+" "+TimeToStr(TimeLocal(),TIME_MINUTES);
         //字体[1]=字体[1]-1;                  
        // 内容[2]=" EA开始时间:"+TimeToStr(initime)+"  已运行:"+DoubleToStr((TimeCurrent()-initime)/60.0/60,1)+"小时";
        // 字体[2]=字体[2]-1;
         
        // 内容[0]="---------------------------------------";
         
         内容[0]=" 当  多单个数:"+string(分项单据统计(0,OP_BUY,MAGICMA,comment)+danshu_buy(MAGICMA_c2));
         内容[1]="     多单手数:"+DoubleToStr(总交易量(0,OP_BUY,MAGICMA,comment)+Lots_Buy(MAGICMA_c2),2);         
         内容[2]=" 前  多单获利:"+DoubleToStr(分类单据利润(0,OP_BUY,MAGICMA,comment)+buyorderprofit(MAGICMA_c2),2);
         
         内容[3]="     多单均价:"+DoubleToStr(avgprice(NULL,0,1,MAGICMA),avgprice(NULL,0,1,MAGICMA)>0?Digits():1);
         
         内容[4]=" EA  累计下单【"+string(Distradetimes(NULL,0,0,MAGICMA,initime)+DistradetimesHis(NULL,0,0,MAGICMA,initime))+"】次";
         内容[5]="     浮动盈亏:"+DoubleToStr(分类单据利润(0,-100,MAGICMA,comment),2);
         
       //  内容[10]="---------------------------------------";
       //  内容[11]=" 当  多单个数:"+string(分项单据统计(1,OP_BUY,-1,""));
        // 内容[12]=" 前  多单手数:"+DoubleToStr(总交易量(1,OP_BUY,-1,""),2);          
       //  内容[13]=" 账  多单获利:"+DoubleToStr(分类单据利润(1,OP_BUY,-1,""),2);
         
       //  内容[14]=" 户  浮动盈亏:"+DoubleToStr(分类单据利润(1,-100,-1,""),2);
       //  内容[15]="---------------------------------------";

       //  内容[16]="      作者:   :114663684";
         
         int YDis=Y+diff;
         for(int ixx=0;ixx<=16;ixx++)
            {
            固定位置标签("[114663684]"+string(ixx)+"0",内容[ixx],X,YDis+YY间隔[ixx],颜色[ixx],字体[ixx],固定角);
            YDis+=YY间隔[ixx];
            }
            
         内容1[0]="空单个数:"+string(分项单据统计(0,OP_SELL,MAGICMA,comment)+danshu_sell(MAGICMA_c2));
         内容1[1]="空单手数:"+DoubleToStr(总交易量(0,OP_SELL,MAGICMA,comment)+Lots_Sell(MAGICMA_c2),2);     
         内容1[2]="空单获利:"+DoubleToStr(分类单据利润(0,OP_SELL,MAGICMA,comment)+sellorderprofit(MAGICMA_c2),2);
         内容1[3]="空单均价:"+DoubleToStr(avgprice(NULL,0,-1,MAGICMA),avgprice(NULL,0,-1,MAGICMA)>0?Digits():1);    
         内容1[4]="累计下单量["+DoubleToStr(DisLots(NULL,0,0,MAGICMA,initime)+DisLotsHis(NULL,0,0,MAGICMA,initime),2)+"]";
         
        // 内容1[11]="空单个数:"+string(分项单据统计(1,OP_SELL,-1,""));
       //  内容1[12]="空单手数:"+DoubleToStr(总交易量(1,OP_SELL,-1,""),2);         
        // 内容1[13]="空单获利:"+DoubleToStr(分类单据利润(1,OP_SELL,-1,""),2);

         YDis=Y+diff;
         for(int ixx=0;ixx<=5;ixx++)
            {
            固定位置标签("[114663684]"+string(ixx)+"1",内容1[ixx],X1,YDis+YY间隔[ixx],颜色1[ixx],字体1[ixx],固定角); 
            YDis+=YY间隔[ixx]; 
            }          
        }   
      
      //Print("OBJPROP_STATE ",ObjectGetInteger(0,"平仓",OBJPROP_STATE)); 
      //Print("OBJPROP_SELECTED ",ObjectGetInteger(0,"平仓",OBJPROP_SELECTED)); 
      if(ObjectGetInteger(0,"平仓",OBJPROP_STATE)==true)
         {
         while(Distradetimes(NULL,0,0,MAGICMA,0)>0)
           {
            closeall("",MAGICMA);
            closeallbuy(Symbol(),MAGICMA_c2);
            closeallsell(Symbol(),MAGICMA_c2);
            RefreshRates();
           }  
         Sleep(300);  
         }
       if(ObjectGetInteger(0,"一键平多单",OBJPROP_STATE)==true)
         {
       sell(Symbol(),0,0,MAGICMA); 
       closeallbuy(Symbol(),MAGICMA_c2); 
         Sleep(300);  
         }        
         
       if(ObjectGetInteger(0,"一键平空单",OBJPROP_STATE)==true)
         {
       buytocover(Symbol(),0,0,MAGICMA);  
       closeallsell(Symbol(),MAGICMA_c2);
         Sleep(300);  
         } 
            
      ObjectSetInteger(0,"平仓",OBJPROP_STATE,false);  
      ObjectSetInteger(0,"一键平多单",OBJPROP_STATE,false);   
      ObjectSetInteger(0,"一键平空单",OBJPROP_STATE,false); 
      ChartRedraw();     
}
void OnTick()
  {
  /*
      if(TimeCurrent()>time0){Alert("EA已过期，请联系版主");return;}  
  if(!(AccountNumber()==AA||AccountNumber()==BB||AccountNumber()==CC||AccountNumber()==DD||AccountNumber()==EE)&&AccountNumber()!=0)
  {
  Alert("没有使用权限，请联系版主");
  return;
  }
    
    */
    HideTestIndicators(FALSE);
       
double     down=iBands(NULL,0,时间周期,偏差,平移,应用于,MODE_LOWER,0);     
double     up=iBands(NULL,0,时间周期,偏差,平移,应用于,MODE_UPPER,0);    
    

double     down1=iBands(NULL,0,时间周期,偏差,平移,应用于,MODE_LOWER,1);     
double     up1=iBands(NULL,0,时间周期,偏差,平移,应用于,MODE_UPPER,1); 
    
double  Enver_zu1_upper_c1_0=iEnvelopes(Symbol(),0,period_enver_1,move_enver_1,type_enver_1,applied_enver_1,deviation_enver_1,MODE_UPPER,0);   
double  Enver_zu1_lower_c1_0=iEnvelopes(Symbol(),0,period_enver_1,move_enver_1,type_enver_1,applied_enver_1,deviation_enver_1,MODE_LOWER,0);   

double  Enver_zu1_upper_c1_1=iEnvelopes(Symbol(),0,period_enver_1,move_enver_1,type_enver_1,applied_enver_1,deviation_enver_1,MODE_UPPER,1);   
double  Enver_zu1_lower_c1_1=iEnvelopes(Symbol(),0,period_enver_1,move_enver_1,type_enver_1,applied_enver_1,deviation_enver_1,MODE_LOWER,1);   
double  Enver_zu1_upper_c1_2=iEnvelopes(Symbol(),0,period_enver_1,move_enver_1,type_enver_1,applied_enver_1,deviation_enver_1,MODE_UPPER,2);   
double  Enver_zu1_lower_c1_2=iEnvelopes(Symbol(),0,period_enver_1,move_enver_1,type_enver_1,applied_enver_1,deviation_enver_1,MODE_LOWER,2);   

double     down_c2_0=iBands(NULL,0,period_bands_c2,deviation_bands_c2,shift_bands_c2,applied_bands_c2,MODE_LOWER,0);     
double     up_c2_0=iBands(NULL,0,period_bands_c2,deviation_bands_c2,shift_bands_c2,applied_bands_c2,MODE_UPPER,0);    

double     down_c2_1=iBands(NULL,0,period_bands_c2,deviation_bands_c2,shift_bands_c2,applied_bands_c2,MODE_LOWER,1);     
double     up_c2_1=iBands(NULL,0,period_bands_c2,deviation_bands_c2,shift_bands_c2,applied_bands_c2,MODE_UPPER,1);    
    
double     down_c2_2=iBands(NULL,0,period_bands_c2,deviation_bands_c2,shift_bands_c2,applied_bands_c2,MODE_LOWER,2);     
double     up_c2_2=iBands(NULL,0,period_bands_c2,deviation_bands_c2,shift_bands_c2,applied_bands_c2,MODE_UPPER,2);    
    
double     down_c2_3=iBands(NULL,0,period_bands_c2,deviation_bands_c2,shift_bands_c2,applied_bands_c2,MODE_LOWER,3);     
double     up_c2_3=iBands(NULL,0,period_bands_c2,deviation_bands_c2,shift_bands_c2,applied_bands_c2,MODE_UPPER,3);    
    
double  Enver_zu2_upper_c2_0=iEnvelopes(Symbol(),0,period_enver_2,move_enver_2,type_enver_2,applied_enver_2,deviation_enver_2,MODE_UPPER,0);   
double  Enver_zu2_lower_c2_0=iEnvelopes(Symbol(),0,period_enver_2,move_enver_2,type_enver_2,applied_enver_2,deviation_enver_2,MODE_LOWER,0);   
double  Enver_zu2_upper_c2_1=iEnvelopes(Symbol(),0,period_enver_2,move_enver_2,type_enver_2,applied_enver_2,deviation_enver_2,MODE_UPPER,1);   
double  Enver_zu2_lower_c2_1=iEnvelopes(Symbol(),0,period_enver_2,move_enver_2,type_enver_2,applied_enver_2,deviation_enver_2,MODE_LOWER,1);   

    
  ObjectDelete("上线价格"); 
  ObjectDelete("下线价格"); 
  if(上线价格!=0)
    {
     ObjectCreate("上线价格",OBJ_HLINE,0,0,上线价格); 
     ObjectSet("上线价格",OBJPROP_COLOR,clrAqua); 
     ObjectSet("上线价格",OBJPROP_STYLE,STYLE_DASH); 
     ObjectSet("上线价格",OBJPROP_WIDTH,1); 
    }
    
    
    
  if(下线价格!=0)
    {
     ObjectCreate("下线价格",OBJ_HLINE,0,0,下线价格); 
     ObjectSet("下线价格",OBJPROP_COLOR,clrRed); 
     ObjectSet("下线价格",OBJPROP_STYLE,STYLE_DASH); 
     ObjectSet("下线价格",OBJPROP_WIDTH,1); 
    }    
 
 
      if(ticketnumber_c2!=lastticketnumber_history(MAGICMA_c2))
        {
            if(lasthistorytype(MAGICMA_c2)==OP_SELL && closesell_c2==FALSE)
              {
                  closesell_c2=TRUE;
              }
        
            if(lasthistorytype(MAGICMA_c2)==OP_BUY && closebuy_c2==FALSE)
              {
                  closebuy_c2=TRUE;
              }
        }


      if(closebuy_c2==TRUE)
        {
            closeallbuy(Symbol(),MAGICMA_c2);
        }

      if(closesell_c2==TRUE)
        {   
            closeallsell(Symbol(),MAGICMA_c2);
        }   
      
      
      if(danshu_buy(MAGICMA_c2)==0 || danshu_sell(MAGICMA_c2)==0)
        {
            ticketnumber_c2=lastticketnumber_history(MAGICMA_c2);
            closesell_c2=FALSE;
            closebuy_c2=FALSE;
        }      
      

bool closeorder_sell=FALSE;
bool closeorder_buy=FALSE;

       if(EnverUseOrNot_c1==shi)
         {
            if(Close[1]>Enver_zu1_upper_c1_1 && Close[2]>Enver_zu1_upper_c1_2)
               {
                  closeorder_sell=TRUE;
               }
         
            if(Close[1]<Enver_zu1_lower_c1_1 && Close[2]<Enver_zu1_lower_c1_1)
               {
                  closeorder_buy=TRUE;
               }
         
            if(closeorder_buy==TRUE)
               {
                  closeallbuy(Symbol(),MAGICMA);
               }
         
            if(closeorder_sell==TRUE)
               {
                  closeallsell(Symbol(),MAGICMA);
               }
         
            if(danshu_buy(MAGICMA)==0)
               {
                  closeorder_buy=FALSE;
               }
            
            if(danshu_sell(MAGICMA)==0)
               {
                  closeorder_sell=FALSE;
               }
         }      
 
if(上线价格!=0&&Close[0]>=上线价格)
  {
         buytocover(Symbol(),0,0,MAGICMA);
      sell(Symbol(),0,0,MAGICMA);
      ExpertRemove();
      return;
  }
  
  if(下线价格!=0&&Close[0]<=下线价格)
  {
         buytocover(Symbol(),0,0,MAGICMA);
      sell(Symbol(),0,0,MAGICMA);
       ExpertRemove();
      return;
  }  
 
     string   time5=TimeToStr(TimeLocal(),TIME_SECONDS);
    // Print("时间="+time5);
   //  if(time5>=结束时间2)
    //   {
   //  buytocover(Symbol(),0,0,MAGICMA);
    // sell(Symbol(),0,0,MAGICMA);
    //   }
    /* if(!((time5>开启时间1&&time5<结束时间1)))
       {
      buytocover(Symbol(),0,0,MAGICMA);
      sell(Symbol(),0,0,MAGICMA);
      return;
       }*/
       
       
 
 
 /*
      if(!(time5>开启时间2&&time5<结束时间2)&&(选择时间段==1||开单方式选择==2))
       {
      buytocover(Symbol(),0,0,MAGICMA);
      sell(Symbol(),0,0,MAGICMA);
      return;
       }
       
   */    
             
  if(time1!=Time[0])
     {
      time1=Time[0];
      bk=1;
      sk=1;
      bp=1;
      sp=1;          
     }
  
  
     if(EnverUseOrNot_c1==shi)
       {
         if(Close[1]<Enver_zu1_lower_c1_1 && Close[0]<Enver_zu1_lower_c1_0)
           {
               sell_Enver_c1=TRUE;
           }
         else
           {
               sell_Enver_c1=FALSE;
           }
       
         if(Close[1]>Enver_zu1_upper_c1_1 && Close[0]>Enver_zu1_upper_c1_0)
           {
               buy_Enver_c1=TRUE;
           }
         else
           {
               buy_Enver_c1=FALSE;
           }
       }
     else if(EnverUseOrNot_c1==fou)
       {
         buy_Enver_c1=TRUE;
         sell_Enver_c1=TRUE;
       }  
  
     if(ObjectGetInteger(0,"暂停",OBJPROP_STATE)==false)
   {   
    
    if(开单方式选择==2)
      {
      
     
  if(Stratgy_1==shi)
   {
        if(Distradetimes(Symbol(),0,1,MAGICMA,0)==0&&Close[0]<=down-超出多少点*Point&&Close[1]>down1 && sell_Enver_c1==TRUE)
          {
           //buy(Symbol(),Lots,Loss,Profit,MAGICMA,0);
            if(Time_Sell_c1!=Time[0])
               {
                  if(sellshort(Symbol(),Lots,Loss,Profit,MAGICMA,0)>0)
                     {
                        Time_Sell_c1=Time[0];
                     }
               }  
          } 
          
          if(Distradetimes(Symbol(),0,-1,MAGICMA,0)==0&&Close[0]>=up+超出多少点*Point&&Close[1]<up1 && buy_Enver_c1==TRUE)
          {
            if(Time_Buy_c1!=Time[0])
               {
                  if(buy(Symbol(),Lots,Loss,Profit,MAGICMA,0)>0)
                     {
                        Time_Buy_c1=Time[0];
                     }
               }           
           //sellshort(Symbol(),Lots,Loss,Profit,MAGICMA,0);
          }

   
  if(/*Distradetimes(Symbol(),0,1,MAGICMA,0)==1&&*/Distradetimes(Symbol(),0,-1,MAGICMA,0)>=1&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<2&&Bid-getlastordernumber(0,Symbol(),0,-1,MAGICMA,"")>=间距*Point&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<最多加仓次数)
    {   
     double   shoushu=NormalizeDouble(加仓倍数*getlastordernumber(1,Symbol(),0,-1,MAGICMA,""),weishu); 
     if(shoushu>最大加仓手数){shoushu=最大加仓手数;}
     
     if(shoushu>=MarketInfo(Symbol(),MODE_MAXLOT))
       {
        shoushu=MarketInfo(Symbol(),MODE_MAXLOT);
       }
       
    if(shoushu<=MarketInfo(Symbol(),MODE_MINLOT)) 
    {
    shoushu=MarketInfo(Symbol(),MODE_MINLOT);
    } 
    
      if(sell_Enver_c1==TRUE)
         {
            sellshort(Symbol(),shoushu,Loss,Profit,MAGICMA,3); 
         }
 
    }
    
    
    
      if(/*Distradetimes(Symbol(),0,1,MAGICMA,0)==1&&*/Distradetimes(Symbol(),0,-1,MAGICMA,0)>=2&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<4&&Bid-getlastordernumber(0,Symbol(),0,-1,MAGICMA,"")>=间距1*Point&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<最多加仓次数)
    {   
     double   shoushu=NormalizeDouble(加仓倍数1*getlastordernumber(1,Symbol(),0,-1,MAGICMA,""),weishu); 
     if(shoushu>最大加仓手数){shoushu=最大加仓手数;}
     
     if(shoushu>=MarketInfo(Symbol(),MODE_MAXLOT))
       {
        shoushu=MarketInfo(Symbol(),MODE_MAXLOT);
       }
       
    if(shoushu<=MarketInfo(Symbol(),MODE_MINLOT)) 
    {
    shoushu=MarketInfo(Symbol(),MODE_MINLOT);
    } 
      if(sell_Enver_c1==TRUE)
         {
            sellshort(Symbol(),shoushu,Loss,Profit,MAGICMA,3); 
         }
    }
    
    
         if(/*Distradetimes(Symbol(),0,1,MAGICMA,0)==1&&*/Distradetimes(Symbol(),0,-1,MAGICMA,0)>=4&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<6&&Bid-getlastordernumber(0,Symbol(),0,-1,MAGICMA,"")>=间距2*Point&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<最多加仓次数)
    {   
     double   shoushu=NormalizeDouble(加仓倍数2*getlastordernumber(1,Symbol(),0,-1,MAGICMA,""),weishu); 
     if(shoushu>最大加仓手数){shoushu=最大加仓手数;}
     
     if(shoushu>=MarketInfo(Symbol(),MODE_MAXLOT))
       {
        shoushu=MarketInfo(Symbol(),MODE_MAXLOT);
       }
       
    if(shoushu<=MarketInfo(Symbol(),MODE_MINLOT)) 
    {
    shoushu=MarketInfo(Symbol(),MODE_MINLOT);
    } 
    
      if(sell_Enver_c1==TRUE)
         {
            sellshort(Symbol(),shoushu,Loss,Profit,MAGICMA,3); 
         }
  
    }
    
           if(/*Distradetimes(Symbol(),0,1,MAGICMA,0)==1&&*/Distradetimes(Symbol(),0,-1,MAGICMA,0)>=6&&Bid-getlastordernumber(0,Symbol(),0,-1,MAGICMA,"")>=间距3*Point&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<最多加仓次数)
    {   
     double   shoushu=NormalizeDouble(加仓倍数3*getlastordernumber(1,Symbol(),0,-1,MAGICMA,""),weishu); 
     if(shoushu>最大加仓手数){shoushu=最大加仓手数;}
     
     if(shoushu>=MarketInfo(Symbol(),MODE_MAXLOT))
       {
        shoushu=MarketInfo(Symbol(),MODE_MAXLOT);
       }
       
    if(shoushu<=MarketInfo(Symbol(),MODE_MINLOT)) 
    {
    shoushu=MarketInfo(Symbol(),MODE_MINLOT);
    } 
    
      if(sell_Enver_c1==TRUE)
         {
            sellshort(Symbol(),shoushu,Loss,Profit,MAGICMA,3); 
         } 
    }  
    
    
    
    
    
    
  if(/*Distradetimes(Symbol(),0,1,MAGICMA,0)==1&&Distradetimes(Symbol(),0,-1,MAGICMA,0)>=1&&*/Bid-avgprice(Symbol(),0,1,MAGICMA)>=止盈点数*Point&&avgprice(Symbol(),0,1,MAGICMA)!=0)
    { 
    
    sell(Symbol(),0,0,MAGICMA);
   // buy(Symbol(),Lots,Loss,Profit,MAGICMA,0);
    }   
    
    
  if(/*Distradetimes(Symbol(),0,1,MAGICMA,0)==1&&Distradetimes(Symbol(),0,-1,MAGICMA,0)>=1&&*/avgprice(Symbol(),0,-1,MAGICMA)-Ask>=止盈点数*Point&&avgprice(Symbol(),0,-1,MAGICMA)!=0 )
    {
    buytocover(Symbol(),0,0,MAGICMA);
   // sellshort(Symbol(),Lots,Loss,Profit,MAGICMA,0);
    }    
    
    

   
  if(/*Distradetimes(Symbol(),0,-1,MAGICMA,0)==1&&*/Distradetimes(Symbol(),0,1,MAGICMA,0)>=1&&Distradetimes(Symbol(),0,1,MAGICMA,0)<2&&getlastordernumber(0,Symbol(),0,1,MAGICMA,"")-Ask>=间距*Point&&Distradetimes(Symbol(),0,1,MAGICMA,0)<最多加仓次数)
    { 
    
    //Print("多单="+Distradetimes(Symbol(),0,1,MAGICMA,0));  
     double   shoushu=NormalizeDouble(加仓倍数*getlastordernumber(1,Symbol(),0,1,MAGICMA,""),weishu); 
      if(shoushu>最大加仓手数){shoushu=最大加仓手数;} 
     if(shoushu>=MarketInfo(Symbol(),MODE_MAXLOT))
       {
        shoushu=MarketInfo(Symbol(),MODE_MAXLOT);
       }
       
    if(shoushu<=MarketInfo(Symbol(),MODE_MINLOT)) 
    {
    shoushu=MarketInfo(Symbol(),MODE_MINLOT);
    } 
      if(buy_Enver_c1==TRUE)
         {
            buy(Symbol(),shoushu,Loss,Profit,MAGICMA,3); 
         }
 
    }
    
    
    
    
  if(/*Distradetimes(Symbol(),0,-1,MAGICMA,0)==1&&*/Distradetimes(Symbol(),0,1,MAGICMA,0)>=2&&Distradetimes(Symbol(),0,1,MAGICMA,0)<4&&getlastordernumber(0,Symbol(),0,1,MAGICMA,"")-Ask>=间距1*Point&&Distradetimes(Symbol(),0,1,MAGICMA,0)<最多加仓次数)
    { 
    
    //Print("多单="+Distradetimes(Symbol(),0,1,MAGICMA,0));  
     double   shoushu=NormalizeDouble(加仓倍数1*getlastordernumber(1,Symbol(),0,1,MAGICMA,""),weishu); 
      if(shoushu>最大加仓手数){shoushu=最大加仓手数;} 
     if(shoushu>=MarketInfo(Symbol(),MODE_MAXLOT))
       {
        shoushu=MarketInfo(Symbol(),MODE_MAXLOT);
       }
       
    if(shoushu<=MarketInfo(Symbol(),MODE_MINLOT)) 
    {
    shoushu=MarketInfo(Symbol(),MODE_MINLOT);
    } 
      if(buy_Enver_c1==TRUE)
         {
            buy(Symbol(),shoushu,Loss,Profit,MAGICMA,3); 
         }
    }    
    
    
    
    
    
      if(/*Distradetimes(Symbol(),0,-1,MAGICMA,0)==1&&*/Distradetimes(Symbol(),0,1,MAGICMA,0)>=4&&Distradetimes(Symbol(),0,1,MAGICMA,0)<6&&getlastordernumber(0,Symbol(),0,1,MAGICMA,"")-Ask>=间距2*Point&&Distradetimes(Symbol(),0,1,MAGICMA,0)<最多加仓次数)
    { 
    
    //Print("多单="+Distradetimes(Symbol(),0,1,MAGICMA,0));  
     double   shoushu=NormalizeDouble(加仓倍数2*getlastordernumber(1,Symbol(),0,1,MAGICMA,""),weishu); 
      if(shoushu>最大加仓手数){shoushu=最大加仓手数;} 
     if(shoushu>=MarketInfo(Symbol(),MODE_MAXLOT))
       {
        shoushu=MarketInfo(Symbol(),MODE_MAXLOT);
       }
       
    if(shoushu<=MarketInfo(Symbol(),MODE_MINLOT)) 
    {
    shoushu=MarketInfo(Symbol(),MODE_MINLOT);
    } 
      if(buy_Enver_c1==TRUE)
         {
            buy(Symbol(),shoushu,Loss,Profit,MAGICMA,3); 
         }
    }  
    
 
      if(/*Distradetimes(Symbol(),0,-1,MAGICMA,0)==1&&*/Distradetimes(Symbol(),0,1,MAGICMA,0)>=6&&getlastordernumber(0,Symbol(),0,1,MAGICMA,"")-Ask>=间距2*Point&&Distradetimes(Symbol(),0,1,MAGICMA,0)<最多加仓次数)
    { 
    
    //Print("多单="+Distradetimes(Symbol(),0,1,MAGICMA,0));  
     double   shoushu=NormalizeDouble(加仓倍数3*getlastordernumber(1,Symbol(),0,1,MAGICMA,""),weishu); 
      if(shoushu>最大加仓手数){shoushu=最大加仓手数;} 
     if(shoushu>=MarketInfo(Symbol(),MODE_MAXLOT))
       {
        shoushu=MarketInfo(Symbol(),MODE_MAXLOT);
       }
       
    if(shoushu<=MarketInfo(Symbol(),MODE_MINLOT)) 
    {
    shoushu=MarketInfo(Symbol(),MODE_MINLOT);
    } 
      if(buy_Enver_c1==TRUE)
         {
            buy(Symbol(),shoushu,Loss,Profit,MAGICMA,3); 
         }
    }  
 
 
 
    
    
    
  if(/*Distradetimes(Symbol(),0,-1,MAGICMA,0)==1&&Distradetimes(Symbol(),0,1,MAGICMA,0)>=1&&*/avgprice(Symbol(),0,-1,MAGICMA)-Ask>=止盈点数*Point&&avgprice(Symbol(),0,-1,MAGICMA)!=0)
    { 
    buytocover(Symbol(),0,0,MAGICMA);
    sellshort(Symbol(),Lots,Loss,Profit,MAGICMA,0);
    }   
    
    
  if(/*Distradetimes(Symbol(),0,-1,MAGICMA,0)==1&&Distradetimes(Symbol(),0,1,MAGICMA,0)>=1&&*/Bid-avgprice(Symbol(),0,1,MAGICMA)>=止盈点数*Point &&avgprice(Symbol(),0,1,MAGICMA)!=0)
    {
    sell(Symbol(),0,0,MAGICMA);
    buy(Symbol(),Lots,Loss,Profit,MAGICMA,0);
    }      
      }
   }//多空都做的时候方向 
   
   
   
   
   
  if(Stratgy_1==shi)
   {
        if(Distradetimes(Symbol(),0,0,MAGICMA,0)==0&& 开单方式选择==1 &&Close[0]<=down-超出多少点*Point&&Close[1]>down1 && sell_Enver_c1==TRUE)//做多
          {
            //buy(Symbol(),Lots,Loss,Profit,MAGICMA,0); 
            if(Time_Sell_c1!=Time[0])
               {
                  if(sellshort(Symbol(),Lots,Loss,Profit,MAGICMA,0)>0)
                     {
                        Time_Sell_c1=Time[0];
                     }
               }          
          }
        
        if(Distradetimes(Symbol(),0,0,MAGICMA,0)==0 && 开单方式选择==0 &&Close[0]>=up+超出多少点*Point&&Close[1]<up1 && buy_Enver_c1==TRUE)//做空
          {
            //sellshort(Symbol(),Lots,Loss,Profit,MAGICMA,0);
            if(Time_Buy_c1!=Time[0])
               {
                  if(buy(Symbol(),Lots,Loss,Profit,MAGICMA,0)>0)
                     {
                        Time_Buy_c1=Time[0];
                     }
               }          
          }

    
  
    /*   if(Distradetimes(Symbol(),0,1,MAGICMA,0)>=最多加仓次数&&getlastordernumber(0,Symbol(),0,1,MAGICMA,"")-Ask>=加仓间距*Point)
       {
        sell(Symbol(),0,0,MAGICMA);

       }*/
     
     
    /* if(Distradetimes(Symbol(),0,-1,MAGICMA,0)>=最多加仓次数&&Bid-getlastordernumber(0,Symbol(),0,-1,MAGICMA,"")>=加仓间距*Point)
       {
        buytocover(Symbol(),0,0,MAGICMA);

       }*/
  
  if(Distradetimes(Symbol(),0,1,MAGICMA,0)>0&&Distradetimes(Symbol(),0,1,MAGICMA,0)<2&&Distradetimes(Symbol(),0,-1,MAGICMA,0)==0&&getlastordernumber(0,Symbol(),0,1,MAGICMA,"")-Ask>=间距*Point&&Distradetimes(Symbol(),0,1,MAGICMA,0)<最多加仓次数&&开单方式选择==0)
    {
     double   手数=NormalizeDouble(加仓倍数*getlastordernumber(1,Symbol(),0,1,MAGICMA,""),weishu);
          if(手数>最大加仓手数){手数=最大加仓手数;}
     if(手数>=MarketInfo(Symbol(),MODE_MAXLOT)){手数=MarketInfo(Symbol(),MODE_MAXLOT);}
      if(buy_Enver_c1==TRUE)
         {
            buy(Symbol(),手数,Loss,Profit,MAGICMA,3);
         } 
    }
  
  
  
    if(Distradetimes(Symbol(),0,1,MAGICMA,0)>=2&&Distradetimes(Symbol(),0,1,MAGICMA,0)<4&&Distradetimes(Symbol(),0,-1,MAGICMA,0)==0&&getlastordernumber(0,Symbol(),0,1,MAGICMA,"")-Ask>=间距1*Point&&Distradetimes(Symbol(),0,1,MAGICMA,0)<最多加仓次数&&开单方式选择==0)
    {
     double   手数=NormalizeDouble(getlastordernumber(1,Symbol(),0,1,MAGICMA,"")*加仓倍数1,weishu);
          if(手数>最大加仓手数){手数=最大加仓手数;}
     if(手数>=MarketInfo(Symbol(),MODE_MAXLOT)){手数=MarketInfo(Symbol(),MODE_MAXLOT);}
      if(buy_Enver_c1==TRUE)
         {
            buy(Symbol(),手数,Loss,Profit,MAGICMA,3);
         } 
    }
    
    
        if(Distradetimes(Symbol(),0,1,MAGICMA,0)>=4&&Distradetimes(Symbol(),0,1,MAGICMA,0)<6&&Distradetimes(Symbol(),0,-1,MAGICMA,0)==0&&getlastordernumber(0,Symbol(),0,1,MAGICMA,"")-Ask>=间距2*Point&&Distradetimes(Symbol(),0,1,MAGICMA,0)<最多加仓次数&&开单方式选择==0)
    {
     double   手数=NormalizeDouble(getlastordernumber(1,Symbol(),0,1,MAGICMA,"")*加仓倍数2,weishu);
          if(手数>最大加仓手数){手数=最大加仓手数;}
     if(手数>=MarketInfo(Symbol(),MODE_MAXLOT)){手数=MarketInfo(Symbol(),MODE_MAXLOT);}
      if(buy_Enver_c1==TRUE)
         {
            buy(Symbol(),手数,Loss,Profit,MAGICMA,3);
         } 
    }
    
    
    
            if(Distradetimes(Symbol(),0,1,MAGICMA,0)>=6&&Distradetimes(Symbol(),0,-1,MAGICMA,0)==0&&getlastordernumber(0,Symbol(),0,1,MAGICMA,"")-Ask>=间距3*Point&&Distradetimes(Symbol(),0,1,MAGICMA,0)<最多加仓次数&&开单方式选择==0)
    {
     double   手数=NormalizeDouble(getlastordernumber(1,Symbol(),0,1,MAGICMA,"")*加仓倍数3,weishu);
          if(手数>最大加仓手数){手数=最大加仓手数;}
     if(手数>=MarketInfo(Symbol(),MODE_MAXLOT)){手数=MarketInfo(Symbol(),MODE_MAXLOT);}
      if(buy_Enver_c1==TRUE)
         {
            buy(Symbol(),手数,Loss,Profit,MAGICMA,3);
         } 
    }
  
  /*
    if(Distradetimes(Symbol(),0,-1,MAGICMA,0)>0&&Distradetimes(Symbol(),0,1,MAGICMA,0)==0&&Bid-getlastordernumber(0,Symbol(),0,-1,MAGICMA,"")>=间距2*Point&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<最多加仓次数&&开单方式选择==1)
    {
     double   手数=NormalizeDouble(getlastordernumber(1,Symbol(),0,-1,MAGICMA,"")*加仓倍数,weishu);
     if(手数>最大加仓手数){手数=最大加仓手数;}
  
     
     if(手数>=MarketInfo(Symbol(),MODE_MAXLOT)){手数=MarketInfo(Symbol(),MODE_MAXLOT);}
     sellshort(Symbol(),手数,Loss,Profit,MAGICMA,3); 
    }
    
    */
    
    
        if(Distradetimes(Symbol(),0,-1,MAGICMA,0)>0&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<2&&Distradetimes(Symbol(),0,1,MAGICMA,0)==0&&Bid-getlastordernumber(0,Symbol(),0,-1,MAGICMA,"")>=间距*Point&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<最多加仓次数&&开单方式选择==1)
    {
     double   手数=NormalizeDouble(getlastordernumber(1,Symbol(),0,-1,MAGICMA,"")*加仓倍数,weishu);
     if(手数>最大加仓手数){手数=最大加仓手数;}
  
     
     if(手数>=MarketInfo(Symbol(),MODE_MAXLOT)){手数=MarketInfo(Symbol(),MODE_MAXLOT);}
      if(sell_Enver_c1==TRUE)
         {
            sellshort(Symbol(),手数,Loss,Profit,MAGICMA,3);
         } 
    }
    
    
    
         if(Distradetimes(Symbol(),0,-1,MAGICMA,0)>=2&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<4&&Distradetimes(Symbol(),0,1,MAGICMA,0)==0&&Bid-getlastordernumber(0,Symbol(),0,-1,MAGICMA,"")>=间距1*Point&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<最多加仓次数&&开单方式选择==1)
    {
     double   手数=NormalizeDouble(getlastordernumber(1,Symbol(),0,-1,MAGICMA,"")*加仓倍数1,weishu);
     if(手数>最大加仓手数){手数=最大加仓手数;}
  
     
     if(手数>=MarketInfo(Symbol(),MODE_MAXLOT)){手数=MarketInfo(Symbol(),MODE_MAXLOT);}
      if(sell_Enver_c1==TRUE)
         {
            sellshort(Symbol(),手数,Loss,Profit,MAGICMA,3);
         } 
    }  
    
    
         if(Distradetimes(Symbol(),0,-1,MAGICMA,0)>=4&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<6&&Distradetimes(Symbol(),0,1,MAGICMA,0)==0&&Bid-getlastordernumber(0,Symbol(),0,-1,MAGICMA,"")>=间距2*Point&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<最多加仓次数&&开单方式选择==1)
    {
     double   手数=NormalizeDouble(getlastordernumber(1,Symbol(),0,-1,MAGICMA,"")*加仓倍数2,weishu);
     if(手数>最大加仓手数){手数=最大加仓手数;}
  
     
     if(手数>=MarketInfo(Symbol(),MODE_MAXLOT)){手数=MarketInfo(Symbol(),MODE_MAXLOT);}
      if(sell_Enver_c1==TRUE)
         {
            sellshort(Symbol(),手数,Loss,Profit,MAGICMA,3);
         } 
    } 
    
    
 
          if(Distradetimes(Symbol(),0,-1,MAGICMA,0)>=6&&Distradetimes(Symbol(),0,1,MAGICMA,0)==0&&Bid-getlastordernumber(0,Symbol(),0,-1,MAGICMA,"")>=间距3*Point&&Distradetimes(Symbol(),0,-1,MAGICMA,0)<最多加仓次数&&开单方式选择==1)
    {
     double   手数=NormalizeDouble(getlastordernumber(1,Symbol(),0,-1,MAGICMA,"")*加仓倍数3,weishu);
     if(手数>最大加仓手数){手数=最大加仓手数;}
  
     
     if(手数>=MarketInfo(Symbol(),MODE_MAXLOT)){手数=MarketInfo(Symbol(),MODE_MAXLOT);}
      if(sell_Enver_c1==TRUE)
         {
            sellshort(Symbol(),手数,Loss,Profit,MAGICMA,3);
         } 
    } 
 
         
  
if(Bid-avgprice(Symbol(),0,1,MAGICMA)>=止盈点数*Point&&avgprice(Symbol(),0,1,MAGICMA)!=0&&开单方式选择==0)
    {
      sell(Symbol(),0,0,MAGICMA);
       //buytocover(Symbol(),0,0,MAGICMA);
    }  
  
  }
  
//===========================================止盈止损计算=========================================== 
  if(avgprice(Symbol(),0,1,MAGICMA)!=0)
    {
     
     
            ObjectDelete("多止盈线");
     ObjectCreate("多止盈线",OBJ_HLINE,0,Time[0],avgprice(Symbol(),0,1,MAGICMA)+止盈点数*Point);
     ObjectSet("多止盈线",OBJPROP_COLOR,clrRed);
     ObjectSet("多止盈线",OBJPROP_WIDTH,1);
     ObjectSet("多止盈线",OBJPROP_STYLE,STYLE_DASH);
    }    
    
        
if(avgprice(Symbol(),0,-1,MAGICMA)-Ask>=止盈点数*Point&&avgprice(Symbol(),0,-1,MAGICMA)!=0&&开单方式选择==1)
    {
      buytocover(Symbol(),0,0,MAGICMA);
      //sell(Symbol(),0,0,MAGICMA);
    } 
    if(avgprice(Symbol(),0,-1,MAGICMA)!=0)
      {
      ObjectDelete("空止盈线");
     ObjectCreate("空止盈线",OBJ_HLINE,0,Time[0],avgprice(Symbol(),0,-1,MAGICMA)-止盈点数*Point);
     ObjectSet("空止盈线",OBJPROP_COLOR,clrRed);
     ObjectSet("空止盈线",OBJPROP_WIDTH,1);
     ObjectSet("空止盈线",OBJPROP_STYLE,STYLE_DASH); 
      } 
    
    
    }


//=============================================组2做单部分=============================================


      if(Stratgy_2==shi)
         {
            if(开单方式选择==0 || 开单方式选择==2)
               {
                  if(danshu_buy(MAGICMA_c2)==0 && danshu_buystop(MAGICMA_c2)==0)
                     {
                         if(Time_Buy_c2!=iTime(Symbol(),0,0))
                           {
                              if(Open[0]<Enver_zu2_upper_c2_0 && Open[0]<up_c2_0)
                                {
                                    if(Bid>Enver_zu2_upper_c2_0 && Bid>up_c2_0)
                                      {
                                          if(danshu_buystop(MAGICMA_c2)==0)
                                            {
                                                if(Bid<=Enver_zu2_upper_c2_0+range_enver_2*MarketInfo(Symbol(),MODE_POINT))
                                                   {
                                                      ticket_buy=OrderSend(Symbol(),OP_BUYSTOP,Lots_c2,NormalizeDouble(Enver_zu2_upper_c2_0,Digits())+range_enver_2*MarketInfo(Symbol(),MODE_POINT),50,0,0,Symbol()+"Buyc2",MAGICMA_c2,TimeCurrent()+60*BarNumber*Period(),clrBlue);
                                                      if(ticket_buy<0)
                                                        {
                                                            if(Buy(Lots_c2,Loss_c2,Profit_c2,Symbol()+"Buyc2",MAGICMA_c2)>0)
                                                              {
                                                                  Time_Buy_c2=iTime(Symbol(),0,0);
                                                                  return;
                                                              }
                                                        }                                                      
                                                      Time_Buy_c2=iTime(Symbol(),0,0);
                                                   }
                                                else
                                                  {
                                                      if(Buy(Lots_c2,Loss_c2,Profit_c2,Symbol()+"Buyc2",MAGICMA_c2)>0)
                                                        {
                                                            Time_Buy_c2=iTime(Symbol(),0,0);
                                                            return;
                                                        }
                                                  }
                                                if(ticket_buy>0)
                                                  {
                                                      if(OrderSelect(ticket_buy,SELECT_BY_TICKET,MODE_TRADES)==true)
                                                        {
                                                            if(Loss_c2>0 && Profit_c2>0)
                                                              {
                                                                  if(OrderModify(ticket_buy,OrderOpenPrice(),OrderOpenPrice()-Loss_c2*MarketInfo(Symbol(),MODE_POINT),OrderOpenPrice()+Profit_c2*MarketInfo(Symbol(),MODE_POINT),OrderOpenTime(),clrBlue)>0)
                                                                    {
                                                                        return;
                                                                    }
                                                              }
                                                            else if(Loss_c2>0 && Profit_c2==0)
                                                              {
                                                                  if(OrderModify(ticket_buy,OrderOpenPrice(),OrderOpenPrice()-Loss_c2*MarketInfo(Symbol(),MODE_POINT),OrderTakeProfit(),OrderExpiration(),clrBlue)>0)
                                                                    {
                                                                        return;
                                                                    }
                                                              }                                                       
                                                            else if(Loss_c2==0 && Profit_c2>0)
                                                              {
                                                                  if(OrderModify(ticket_buy,OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()+Profit_c2*MarketInfo(Symbol(),MODE_POINT),OrderExpiration(),clrBlue)>0)
                                                                    {
                                                                        return;
                                                                    }                                                        
                                                              }
                                                            else if(Loss_c2==0 && Profit_c2==0)
                                                              {
                                                                  if(OrderModify(ticket_buy,OrderOpenPrice(),OrderStopLoss(),OrderTakeProfit(),OrderExpiration(),clrBlue)>0)
                                                                    {
                                                                        return;
                                                                    }                                                        
                                                              }
                                                        }
                                                  }                                            
                                            }
                                      }
                                }
                           }
                     }
               }
       
            
            if(开单方式选择==1 || 开单方式选择==2)
               {
                  if(danshu_sell(MAGICMA_c2)==0 && danshu_sellstop(MAGICMA_c2)==0) 
                     {
                         if(Time_Sell_c2!=iTime(Symbol(),0,0))
                           {
                              if(Open[0]>Enver_zu2_lower_c2_0 && Open[0]>down_c2_0)
                                {
                                    if(Bid<Enver_zu2_lower_c2_0 && Bid<down_c2_0)
                                      {
                                          if(danshu_sellstop(MAGICMA_c2)==0)
                                            {
                                                if(Bid>=Enver_zu2_lower_c2_0-range_enver_2*MarketInfo(Symbol(),MODE_POINT))
                                                   {
                                                      ticket_sell=OrderSend(Symbol(),OP_SELLSTOP,Lots_c2,NormalizeDouble(Enver_zu2_lower_c2_0,Digits())-range_enver_2*MarketInfo(Symbol(),MODE_POINT),50,0,0,Symbol()+"Sellc2",MAGICMA_c2,TimeCurrent()+60*BarNumber*Period(),clrRed);
                                                      if(ticket_sell<0)
                                                        {
                                                            if(Sell(Lots_c2,Loss_c2,Profit_c2,Symbol()+"Sellc2",MAGICMA_c2)>0)
                                                              {
                                                                  Time_Sell_c2=iTime(Symbol(),0,0);
                                                                  return;
                                                              }
                                                        }                                                        
                                                      Time_Sell_c2=iTime(Symbol(),0,0);
                                                   }
                                                else
                                                  {
                                                      if(Sell(Lots_c2,Loss_c2,Profit_c2,Symbol()+"Sellc2",MAGICMA_c2)>0)
                                                        {
                                                            Time_Sell_c2=iTime(Symbol(),0,0);
                                                            return;
                                                        }
                                                  }
                                                
                                                if(ticket_sell>0)
                                                  {
                                                      if(OrderSelect(ticket_sell,SELECT_BY_TICKET,MODE_TRADES)==true)
                                                        {
                                                            if(Loss_c2>0 && Profit_c2>0)
                                                              {
                                                                  if(OrderModify(ticket_sell,OrderOpenPrice(),OrderOpenPrice()+Loss_c2*MarketInfo(Symbol(),MODE_POINT),OrderOpenPrice()-Profit_c2*MarketInfo(Symbol(),MODE_POINT),OrderExpiration(),clrBlue)>0)
                                                                    {
                                                                        return;
                                                                    }
                                                              }
                                                            else if(Loss_c2>0 && Profit_c2==0)
                                                              {
                                                                  if(OrderModify(ticket_sell,OrderOpenPrice(),OrderOpenPrice()+Loss_c2*MarketInfo(Symbol(),MODE_POINT),OrderTakeProfit(),OrderExpiration(),clrBlue)>0)
                                                                    {
                                                                        return;
                                                                    }
                                                              }                                                       
                                                            else if(Loss_c2==0 && Profit_c2>0)
                                                              {
                                                                  if(OrderModify(ticket_sell,OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()-Profit_c2*MarketInfo(Symbol(),MODE_POINT),OrderExpiration(),clrBlue)>0)
                                                                    {
                                                                        return;
                                                                    }                                                        
                                                              }
                                                            else if(Loss_c2==0 && Profit_c2==0)
                                                              {
                                                                  if(OrderModify(ticket_sell,OrderOpenPrice(),OrderStopLoss(),OrderTakeProfit(),OrderExpiration(),clrBlue)>0)
                                                                    {
                                                                        return;
                                                                    }                                                        
                                                              }
                                                        }
                                                  }                                              
                                            }
                                     }
                                }
                           }
                     } 
               }
       
               
             if(maxorder>1)
               {  
                  if(danshu_buy(MAGICMA_c2)>0 && danshu_buy(MAGICMA_c2)<maxorder)
                     {
                           if(buylastprice_nishi(MAGICMA_c2)>0)
                              {
                                 if((buylastprice_nishi(MAGICMA_c2)-MarketInfo(Symbol(),MODE_ASK))>=(Add_Lots_Range*MarketInfo(Symbol(),MODE_POINT)))
                                    {
                                       if(Buy(MathMin(NormalizeDouble(getbuylastlots_nishi(MAGICMA_c2)*jiacangbeishu,2),maxlots),0,Profit_c2,Symbol()+"Buyc2"+string (danshu_buy(MAGICMA_c2)),MAGICMA_c2)>0)
                                          {
                                             return;
                                          }
                                     }
                             }
                      } 
              
                  if(danshu_sell(MAGICMA_c2)>0 && danshu_sell(MAGICMA_c2)<maxorder)
                     {
                           if(selllastprice_nishi(MAGICMA_c2)>0)
                              {
                                 if((MarketInfo(Symbol(),MODE_BID)-selllastprice_nishi(MAGICMA_c2))>=(Add_Lots_Range*MarketInfo(Symbol(),MODE_POINT)))
                                    {
                                       if(Sell(MathMin(NormalizeDouble(getselllastlots_nishi(MAGICMA_c2)*jiacangbeishu,2),maxlots),0,Profit_c2,Symbol()+"Sellc2"+string (danshu_sell(MAGICMA_c2)),MAGICMA_c2)>0)
                                          {
                                             return;
                                          }
                                    }
                             }
                     }
               }
        } 
 
 
       //if(danshu_buy(MAGICMA_c2)>0)
         {
            double buylastTPc3=getbuylastTP_nishi(MAGICMA_c2);
             for(int y=0;y<OrdersTotal();y++)
               {
                  if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true)
                     {
                        if(OrderSymbol()==Symbol())
                           {
                              if(OrderType()==OP_BUY && OrderMagicNumber()==MAGICMA_c2)
                                 {
                                    if(buylastTPc3>0)
                                       {
                                          if(OrderTakeProfit()!=buylastTPc3)
                                             {
                                               int h1=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),buylastTPc3,0,clrBlue);
                                             }
                                       }
                                    else
                                       {
                                          if(OrderTakeProfit()==0)
                                             {
                                               int h1=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()+Profit_c2*MarketInfo(Symbol(),MODE_POINT),0,clrBlue);
                                             }
                                       }                                 
                                 }
                           }
                     }
               }
         
            double buylastSLc3=getbuylastSL_nishi(MAGICMA_c2);
             for(int y=0;y<OrdersTotal();y++)
               {
                  if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true)
                     {
                        if(OrderSymbol()==Symbol())
                           {
                              if(OrderType()==OP_BUY && OrderMagicNumber()==MAGICMA_c2)
                                 {
                                    if(buylastSLc3>0)
                                       {
                                          if(OrderStopLoss()!=buylastSLc3)
                                             {
                                               int h1=OrderModify(OrderTicket(),OrderOpenPrice(),buylastSLc3,OrderTakeProfit(),0,clrBlue);
                                             }
                                       }
                                    else
                                      {
                                          if(OrderStopLoss()==0)
                                             {
                                               int h1=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-Loss_c2*MarketInfo(Symbol(),MODE_POINT),OrderTakeProfit(),0,clrBlue);
                                             }
                                      }
                                 }
                           }
                     }
               }                              
         }  
 
 
       //if(danshu_sell(MAGICMA_c2)>0)
            double selllastTPc3=getselllastTP_nishi(MAGICMA_c2);
             for(int y=0;y<OrdersTotal();y++)
               {
                  if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES))
                     {
                        if(OrderSymbol()==Symbol())
                           {
                              if(OrderType()==OP_SELL && OrderMagicNumber()==MAGICMA_c2)
                                 {
                                    if(selllastTPc3>0)
                                       {
                                          if(OrderTakeProfit()!=selllastTPc3)
                                             {
                                               int h1=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),selllastTPc3,0,clrBlue);
                                             }
                                       }
                                    else
                                       {
                                          if(OrderTakeProfit()==0)
                                             {
                                               int h1=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()-Profit_c2*MarketInfo(Symbol(),MODE_POINT),0,clrBlue);
                                             }
                                       }                                 
                                  }
                           }
                     }
               }
         
            double selllastSLc3=getselllastSL_nishi(MAGICMA_c2);
             for(int y=0;y<OrdersTotal();y++)
               {
                  if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES))
                     {
                        if(OrderSymbol()==Symbol())
                           {
                              if(OrderType()==OP_SELL && OrderMagicNumber()==MAGICMA_c2)
                                 {
                                    if(selllastSLc3>0)
                                       {
                                          if(OrderStopLoss()!=selllastSLc3)
                                             {
                                               int h1=OrderModify(OrderTicket(),OrderOpenPrice(),selllastSLc3,OrderTakeProfit(),0,clrBlue);
                                             }
                                       }
                                    else
                                      {
                                          if(OrderStopLoss()==0)
                                             {
                                               int h1=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+Loss_c2*MarketInfo(Symbol(),MODE_POINT),OrderTakeProfit(),0,clrBlue);
                                             }
                                      }
                                 }
                           }
                     }
               }                              
 
 

 
 
 
//=============================================组1止损部分=============================================
  if(账户盈利()<-亏损多少金额)
    {
      buytocover(Symbol(),0,0,MAGICMA);
      sell(Symbol(),0,0,MAGICMA);
      buytocover(Symbol(),0,0,MAGICMA_c2);
      sell(Symbol(),0,0,MAGICMA_c2);
      //ExpertRemove();
      return;
    }  
    
    
  }


  
int buy(string huobi,double lots,double sun,double ying,int magic,int type)
   {
   int status=0;
   if(huobi==NULL)huobi=Symbol();
   string comment=huobi+myPeriodStr(Period()); 
   if((sun!=0 && sun<MarketInfo(huobi,MODE_STOPLEVEL)+MarketInfo(huobi,MODE_SPREAD)) || (ying!=0 && ying<MarketInfo(huobi,MODE_STOPLEVEL)))
     {
      Alert("止损止赢设置错误，请检查后重新设置！");
      return 0;
     }
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {                
         if(type==3)break;
         if(type==2 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_SELL){status=1;break;}
         if(type==1 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_BUY){status=1;break;}            
         if(type==0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic) {status=1;break;}  
        }
     }
    if(status==0)
      {
       int ticket=OrderSend(huobi,OP_BUY,lots,MarketInfo(huobi,MODE_ASK),300,0,0,comment,magic,0,clrNONE);
       if(ticket>0)
         {
           if(OrderSelect(ticket, SELECT_BY_TICKET)==true)
             {
             bool sunying=true;
              if((sun!=0)&&(ying!=0))
               {
                 sunying=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-sun*MarketInfo(huobi,MODE_POINT),OrderOpenPrice()+ying*MarketInfo(huobi,MODE_POINT),0,Blue); 
               }
              if((sun==0)&&(ying!=0))
               {
                 sunying=OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderOpenPrice()+ying*MarketInfo(huobi,MODE_POINT),0,Blue); 
               }
              if((sun!=0)&&(ying==0))
               {
                 sunying=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-sun*MarketInfo(huobi,MODE_POINT),0,0,Blue); 
               }
              if(!sunying)
                {
                 Alert("止损止赢设置失败！错误编号:",GetLastError());
                } 
             }
         return(ticket);              
         }
      } 
   return(0);   
   }
   
int sellshort(string huobi,double lots,double sun,double ying,int magic,int type)
   {
   int status=0;
   if(huobi==NULL)huobi=Symbol();
   string comment=huobi+myPeriodStr(Period());   
   if((sun!=0 && sun<MarketInfo(huobi,MODE_STOPLEVEL)+MarketInfo(huobi,MODE_SPREAD)) || (ying!=0 && ying<MarketInfo(huobi,MODE_STOPLEVEL)))
     {
      Alert("止损止赢设置过小，请检查后重新设置！");
      return 0;
     }
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(type==3)break;
         if(type==2 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_BUY)
            {status=1;break;}
         if(type==1 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_SELL)
            {status=1;break;}            
         if(type==0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic)
            {status=1;break;}  
        }
     }
    if(status==0)
      {
       int ticket=OrderSend(huobi,OP_SELL,lots,MarketInfo(huobi,MODE_BID),300,0,0,comment,magic,0,clrNONE);
       if(ticket>0)
         {
           if(OrderSelect(ticket, SELECT_BY_TICKET)==true)
             {
             bool sunying=true;
              if((sun!=0)&&(ying!=0))
               {
                 sunying=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+sun*MarketInfo(huobi,MODE_POINT),OrderOpenPrice()-ying*MarketInfo(huobi,MODE_POINT),0,Red); 
               }
              if((sun==0)&&(ying!=0))
               {
                 sunying=OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderOpenPrice()-ying*MarketInfo(huobi,MODE_POINT),0,Red); 
               }
              if((sun!=0)&&(ying==0))
               {
                 sunying=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+sun*MarketInfo(huobi,MODE_POINT),0,0,Red); 
               }
              if(!sunying)
                {
                 Alert("止损止赢设置失败！错误编号:",GetLastError());
                } 
             }
         return(ticket);              
         }
      } 
   return(0);   
   }   

   void sell(string huobi,int type,int direction,int magic) 
      {
      if(huobi==NULL)huobi=Symbol();
      string comment=huobi+myPeriodStr(Period());   
      int i=0;
      bool status;
      if(direction==0)
      {
      for(i=OrdersTotal()-1;i>=0;i--)
         {
         status=false;
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            {
            if(type==0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_BUY)
              {status=true;
              }
           if(status)
               {
               if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),300,clrNONE)) Print("平仓失败，错误编号：",GetLastError());
               }         
            }
         }
      }
      }
 
      
    void buytocover(string huobi,int type,int direction,int magic) 
      {
      if(huobi==NULL)huobi=Symbol();
      string comment=huobi+myPeriodStr(Period());   
      int i=0;
      bool status;
      if(direction==0)
      {
      for(i=OrdersTotal()-1;i>=0;i--)
         {
         status=false;
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            {
            if(type==0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_SELL)
              {status=true;
              }
           if(status)
               {
               if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),300,clrNONE)) Print("平仓失败，错误编号：",GetLastError());
               }         
            }
         }
      }
      }  
      
double 分类单据利润(int stype, int type,int magicX,string comm)
  {
   double 利润=0;
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol()==Symbol() || stype==1)
            if(OrderMagicNumber()==magicX || magicX==-1)
               if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                  if(
                     (OrderType()==type || type==-100)
                     || (OrderType()<2 && type==-200)
                     || (OrderType()>=2 && type==-300)
                     )
                     利润+=OrderProfit()+OrderSwap()+OrderCommission();
   return(利润);
  }
  
double 总交易量(int stype, int type,int magicX,string comm)
  {
   double js=0;
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol()==Symbol() || stype==1)
            if(OrderMagicNumber()==magicX || magicX==-1)
               if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                  if(OrderType()==type || (type==-100 && OrderType()<2))
                     js+=OrderLots();

   return(js);
  }
    
int 分项单据统计(int stype, int type,int magicX,string comm)
  {
   int 数量=0;
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol()==Symbol() || stype==1)
            if(OrderMagicNumber()==magicX || magicX==-1)
               if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                  if(
                     (OrderType()==type || type==-100)
                     || (OrderType()<2 && type==-200)
                     || (OrderType()>=2 && type==-300)
                     )
                     数量++;
   return(数量);
  }
  
void 固定位置标签(string 名称,string 内容,int XX,int YX,color C,int 字体大小,int 固定角内)
  {
   if(内容==NULL)
      return;
   if(ObjectFind(名称)==-1)
     {
      ObjectDelete(名称);
      ObjectCreate(名称,OBJ_LABEL,0,0,0);
     }
   ObjectSet(名称,OBJPROP_XDISTANCE,XX);
   ObjectSet(名称,OBJPROP_YDISTANCE,YX);
   ObjectSetText(名称,内容,字体大小,"宋体",C);
   ObjectSet(名称,OBJPROP_CORNER,固定角内);
   ObjectSet(名称,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,名称,OBJPROP_ANCHOR,ANCHOR_LEFT);
  }

void buttom(string name,string txt1,string txt2,int XX,int YX,int XL,int YL,int WZ,color A,color B,color A1,color B1,int SIZE)
  {
   if(ObjectFind(0,name)==-1)
      ObjectCreate(0,name,OBJ_BUTTON,0,0,0);

   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,XX);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,YX);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,XL);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,YL);
   ObjectSetString(0,name,OBJPROP_FONT,"微软雅黑");
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,SIZE);
   ObjectSetInteger(0,name,OBJPROP_CORNER,WZ);
   
   //ObjectSetInteger(0,name,OBJPROP_HIDDEN,false); 
   ObjectSetInteger(0,name,OBJPROP_BACK,true); 
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,Yellow);
   //ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true); 
   //ObjectSetInteger(0,name,OBJPROP_SELECTED,true); 
   
   if(ObjectGetInteger(0,name,OBJPROP_STATE)==1)
     {
      ObjectSetInteger(0,name,OBJPROP_COLOR,A1);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,A1);
      ObjectSetString(0,name,OBJPROP_TEXT,"");
     }
   else
     {
      ObjectSetInteger(0,name,OBJPROP_COLOR,A1);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,A1);
      ObjectSetString(0,name,OBJPROP_TEXT,"");
     }
  }      
  
void buttom1(string name,string txt1,string txt2,int XX,int YX,int XL,int YL,int WZ,color A,color B,color A1,color B1,int SIZE)
  {
   if(ObjectFind(0,name)==-1)
      ObjectCreate(0,name,OBJ_BUTTON,0,0,0);

   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,XX);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,YX);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,XL);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,YL);
   ObjectSetString(0,name,OBJPROP_FONT,"微软雅黑");
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,SIZE);
   ObjectSetInteger(0,name,OBJPROP_CORNER,WZ);

   if(ObjectGetInteger(0,name,OBJPROP_STATE)==1)
     {
     //Print("HERE1");
      ObjectSetInteger(0,name,OBJPROP_COLOR,A1);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,B1);
      ObjectSetString(0,name,OBJPROP_TEXT,txt1);
      //ObjectSetInteger(0,name,OBJPROP_SELECTED,true); 
     }
   else
     {
     //Print("HERE0");
      ObjectSetInteger(0,name,OBJPROP_COLOR,B);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,A);
      ObjectSetString(0,name,OBJPROP_TEXT,txt2);
      //ObjectSetInteger(0,name,OBJPROP_SELECTED,false); 
     }
     ChartRedraw();
  }  
  
   int Distradetimes(string huobi,int type,int bs,int magic,datetime time)
         {
         if(huobi==NULL)huobi=Symbol();
         string comment=huobi+myPeriodStr(Period());   
         int total=0;
         
         for(int i=0;i<OrdersTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderOpenTime()>=time)
              {
               if(type==0 && bs>0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_BUY)total++;
               if(type==0 && bs<0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_SELL)total++;
               if(type==0 && bs==0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic)total++;                 
              }
           }
         return(total);  
         }  

   int DistradetimesHis1(string huobi,int type,int bs,int magic,datetime time)
         {
         if(huobi==NULL)huobi=Symbol();
         string comment=huobi+myPeriodStr(Period());   
         int total=0;
         
         for(int i=0;i<OrdersHistoryTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY) && OrderCloseTime()>=time)
              {
               if(type==0 && bs>0 && OrderSymbol()==huobi && (StringSubstr(OrderComment(),0,StringLen(comment))==comment || StringFind(OrderComment(),comment,4)>=0) && OrderMagicNumber()==magic && OrderType()==OP_BUY)total++;
               if(type==0 && bs<0 && OrderSymbol()==huobi && (StringSubstr(OrderComment(),0,StringLen(comment))==comment || StringFind(OrderComment(),comment,4)>=0) && OrderMagicNumber()==magic && OrderType()==OP_SELL)total++;
               if(type==0 && bs==0 && OrderSymbol()==huobi && (StringSubstr(OrderComment(),0,StringLen(comment))==comment || StringFind(OrderComment(),comment,4)>=0) && OrderMagicNumber()==magic)total++;                 
              }
           }
         return(total);  
         }  


   int DistradetimesHis(string huobi,int type,int bs,int magic,datetime time)
         {
         if(huobi==NULL)huobi=Symbol();
         string comment=huobi+myPeriodStr(Period());   
         int total=0;
         
         for(int i=0;i<OrdersHistoryTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY) && OrderOpenTime()>=time)
              {
               if(type==0 && bs>0 && OrderSymbol()==huobi && (StringSubstr(OrderComment(),0,StringLen(comment))==comment || StringFind(OrderComment(),comment,4)>=0) && OrderMagicNumber()==magic && OrderType()==OP_BUY)total++;
               if(type==0 && bs<0 && OrderSymbol()==huobi && (StringSubstr(OrderComment(),0,StringLen(comment))==comment || StringFind(OrderComment(),comment,4)>=0) && OrderMagicNumber()==magic && OrderType()==OP_SELL)total++;
               if(type==0 && bs==0 && OrderSymbol()==huobi && (StringSubstr(OrderComment(),0,StringLen(comment))==comment || StringFind(OrderComment(),comment,4)>=0) && OrderMagicNumber()==magic)total++;                 
              }
           }
         return(total);  
         }  

   double DisLots(string huobi,int type,int bs,int magic,datetime time)
         {
         if(huobi==NULL)huobi=Symbol();
         string comment=huobi+myPeriodStr(Period());   
         double total=0;
         
         for(int i=0;i<OrdersTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderOpenTime()>=time)
              {
               if(type==0 && bs>0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_BUY)total+=OrderLots();
               if(type==0 && bs<0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_SELL)total+=OrderLots();
               if(type==0 && bs==0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic)total+=OrderLots();                 
              }
           }
         return(total);  
         }  

   double DisLotsHis(string huobi,int type,int bs,int magic,datetime time)
         {
         if(huobi==NULL)huobi=Symbol();
         string comment=huobi+myPeriodStr(Period());   
         double total=0;
         
         for(int i=0;i<OrdersHistoryTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY) && OrderOpenTime()>=time)
              {
               if(type==0 && bs>0 && OrderSymbol()==huobi && (StringSubstr(OrderComment(),0,StringLen(comment))==comment || StringFind(OrderComment(),comment,4)>=0) && OrderMagicNumber()==magic && OrderType()==OP_BUY)total+=OrderLots();
               if(type==0 && bs<0 && OrderSymbol()==huobi && (StringSubstr(OrderComment(),0,StringLen(comment))==comment || StringFind(OrderComment(),comment,4)>=0) && OrderMagicNumber()==magic && OrderType()==OP_SELL)total+=OrderLots();
               if(type==0 && bs==0 && OrderSymbol()==huobi && (StringSubstr(OrderComment(),0,StringLen(comment))==comment || StringFind(OrderComment(),comment,4)>=0) && OrderMagicNumber()==magic)total+=OrderLots();                 
              }
           }
         return(total);  
         }  
                  
 double  avgprice(string huobi,int type,int bs,int magic)   
         {
         if(huobi==NULL)huobi=Symbol();
         string comment=huobi+myPeriodStr(Period());
         double sumprice=0;
         double totallots=0;
         for(int i=0;i<OrdersTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(type==0 && bs>0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_BUY)
                  {
                  sumprice=sumprice+OrderOpenPrice()*OrderLots();
                  totallots=totallots+OrderLots();
                  }
               if(type==0 && bs<0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_SELL)
                  {
                  sumprice=sumprice+OrderOpenPrice()*OrderLots();
                  totallots=totallots+OrderLots();
                  }               
               if(type==0 && bs==0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic)                  
                  {
                  sumprice=sumprice+OrderOpenPrice()*OrderLots();
                  totallots=totallots+OrderLots();
                  }                              
              }
           }
         if(totallots==0)
           {
            return(0.0);  
           } else
               {
                return(sumprice/totallots);
               } 
         } 
                  
  void closeall(string comment, int magic)
   {
      comment=Symbol()+myPeriodStr(Period())+comment;
      
      for(int i=OrdersTotal()-1;i>=0;i--)
        {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderSymbol()==Symbol())
         {
         bool pingcang=true;
         if(OrderType()==OP_SELL)
           {
            pingcang=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),300,Red); 
           }
          if(OrderType()==OP_BUY)
           {
           pingcang=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),300,Blue); 
           }
          if(OrderType()>1)
           {
           pingcang=OrderDelete(OrderTicket()); 
           }              
           if(!pingcang)
            {
            Print("平仓失败,错误编号：",GetLastError());
            }       
         }
        }   
   }             
   
  string myPeriodStr(int period) {
   string pstr; int pid=0;
   switch (period) {
      case 1: pid=0; pstr="1M"; break;
      case 5: pid=1; pstr="5M"; break;
      case 15: pid=2; pstr="15M"; break;
      case 30: pid=3; pstr="30M"; break;
      case 60: pid=4; pstr="1H"; break;
      case 240: pid=5; pstr="4H"; break;
      case 1440: pid=6; pstr="1D"; break;     
      case 10080: pid=7; pstr="1W"; break;
      case 43200: pid=8; pstr="NM"; break;
   }
   return pstr;
 } 
 
 
 
 
 int  lastticket(string huobi,int type,int bs,int magic, string comment)   
         {
         if(huobi==NULL)huobi=Symbol();
         comment=huobi+myPeriodStr(Period())+comment;
         int ticket=-1;
         for(int i=0;i<OrdersTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(type==0 && bs>0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_BUY && ticket<OrderTicket())ticket=OrderTicket();
               if(type==0 && bs<0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && OrderType()==OP_SELL && ticket<OrderTicket())ticket=OrderTicket();
               if(type==0 && bs==0 && OrderSymbol()==huobi && StringSubstr(OrderComment(),0,StringLen(comment))==comment && OrderMagicNumber()==magic && ticket<OrderTicket())ticket=OrderTicket();
               
               if(type==1 && bs>0 && OrderSymbol()==huobi && OrderType()==OP_BUY && ticket<OrderTicket())ticket=OrderTicket();
               if(type==1 && bs<0 && OrderSymbol()==huobi && OrderType()==OP_SELL && ticket<OrderTicket())ticket=OrderTicket();
               if(type==1 && bs==0 && OrderSymbol()==huobi && ticket<OrderTicket())ticket=OrderTicket();      
               
               if(type==2 && bs>0 && OrderType()==OP_BUY && ticket<OrderTicket())ticket=OrderTicket();
               if(type==2 && bs<0 && OrderType()==OP_SELL && ticket<OrderTicket())ticket=OrderTicket();
               if(type==2 && bs==0 && ticket<OrderTicket())ticket=OrderTicket();                          
              }
           }
         return(ticket);  
         }


               
double  getlastordernumber(int datatype,string huobi,int type,int bs,int magic, string comment)
      {
      int ticket=lastticket(huobi,type,bs,magic,comment);
      double output=-1;
      if(ticket<=0)return(-1);
      if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
         {
         switch(datatype)
           {
            case  0:    output=OrderOpenPrice();break;
            case  1:    output=OrderLots();break;
            case  2:    output=OrderType();break;
            case  3:    output=OrderStopLoss();break;
            case  4:    output=OrderTakeProfit();break;
            case  5:    output=OrderProfit();break;          
            case  6:    output=OrderMagicNumber();break;                                       
            default:    output=0;break;
           }
         }
       return(double(output));  
      }   
      
      
      
double   账户盈利()
   {
    double output=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
              
              if( OrderSymbol()==Symbol() && StringSubstr(OrderComment(),0,StringLen(Symbol()+myPeriodStr(Period())))==Symbol()+myPeriodStr(Period()) && (OrderMagicNumber()==MAGICMA || OrderMagicNumber()==MAGICMA_c2))output=OrderProfit()+output; 
              
              }
     }
     
     
    return(double(output));  
   }  
   
void closeallbuy(string symbol, int magic)
 {
   int t=OrdersTotal();
   for(int i=t-1;i>=0;i--)
     {
       if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
          if(OrderSymbol()==symbol && OrderType()==OP_BUY)
           {
              if(OrderMagicNumber()==magic)
               {
                  int h1=OrderClose(OrderTicket(),OrderLots(),Bid,50,clrAliceBlue);
               }
           }
        }
     }
  }
  
void closeallsell(string symbol,int magic)
 {
   int t=OrdersTotal();
   for(int i=t-1;i>=0;i--)
     {
       if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
          if(OrderSymbol()==symbol && OrderType()==OP_SELL)
           {
              if(OrderMagicNumber()==magic)
               {
                  int h1=OrderClose(OrderTicket(),OrderLots(),Ask,50,clrAliceBlue);
               }
           }
        }
     }
  } 
  

int danshu_buystop(int magic)
   {
      int a=0;
      for(int i=0;i<OrdersTotal();i++)
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                  if(OrderSymbol()==Symbol() && OrderType()==OP_BUYSTOP && OrderMagicNumber()==magic)
                     {
                        a=a+1;
                     }
               }
         }
      return(a);
   }
   
int danshu_sellstop(int magic)
   {
      int b=0;
      for(int i=0;i<OrdersTotal();i++)
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                  if(OrderSymbol()==Symbol() && OrderType()==OP_SELLSTOP && OrderMagicNumber()==magic)
                     {
                        b=b+1;
                     }
               }
         }
      return(b);
   }
  
  

int danshu_buy(int magic)
   {
      int a=0;
      for(int i=0;i<OrdersTotal();i++)
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                  if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==magic)
                     {
                        a=a+1;
                     }
               }
         }
      return(a);
   }
   
int danshu_sell(int magic)
   {
      int b=0;
      for(int i=0;i<OrdersTotal();i++)
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                  if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==magic)
                     {
                        b=b+1;
                     }
               }
         }
      return(b);
   }

int buylastticket_nishi(int magic)
   {
      int maxtickt=0;
      for(int i=0;i<OrdersTotal();i++)
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                  if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
                     {
                        if(OrderMagicNumber()==magic)
                           {
                              if(maxtickt<OrderTicket())
                                 {
                                    maxtickt=OrderTicket();
                                 }
                           }
                     }
               }
         }
      return(maxtickt);
   }


int selllastticket_nishi(int magic)
   {
      int maxtickt=0;
      for(int i=0;i<OrdersTotal();i++)
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                  if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
                     {
                        if(OrderMagicNumber()==magic)
                           {
                              if(maxtickt<OrderTicket())
                                 {
                                    maxtickt=OrderTicket();
                                 }
                           }
                     }
               }
         }
      return(maxtickt);
   }

double buylastprice_nishi(int magic)
   {
        if(buylastticket_nishi(magic)!=0)
         {
            if(OrderSelect(buylastticket_nishi(magic),SELECT_BY_TICKET,MODE_TRADES)==true)
               {
                  return(OrderOpenPrice());
               }
            else
               {
                  return(0);
               }
         }
        else
         {
            return(0);
         }
   }
   
double selllastprice_nishi(int magic)
   {
        if(selllastticket_nishi(magic)!=0)
         {
            if(OrderSelect(selllastticket_nishi(magic),SELECT_BY_TICKET,MODE_TRADES)==true)
               {
                  return(OrderOpenPrice());
               }
            else
               {
                  return(0);
               }
         }
        else
         {
            return(0);
         }
   }
 
 
   
double getbuylastlots_nishi(int magic)
   {
      if(buylastticket_nishi(magic)!=0)
         {
            if(OrderSelect(buylastticket_nishi(magic),SELECT_BY_TICKET,MODE_TRADES)==true)
               {
                  return(OrderLots());
               }
            else
               {
                  return(0);
               }
         }
        else
         {
            return(0);
         }
   }


double getselllastlots_nishi(int magic)
   {
       if(selllastticket_nishi(magic)!=0)
         {
            if(OrderSelect(selllastticket_nishi(magic),SELECT_BY_TICKET,MODE_TRADES)==true)
               {
                  return(OrderLots());
               }
            else
               {
                  return(0);
               }
         }
        else
         {
            return(0);
         }
   }


int buyoldticket_nishi(int magic)
   {
      int maxtickt=INT_MAX;
      for(int i=0;i<OrdersTotal();i++)
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                  if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
                     {
                        if(OrderMagicNumber()==magic)
                           {
                              if(maxtickt>OrderTicket())
                                 {
                                    maxtickt=OrderTicket();
                                 }
                           }
                     }
               }
         }
      return(maxtickt);
   }


int selloldticket_nishi(int magic)
   {
      int maxtickt=INT_MAX;
      for(int i=0;i<OrdersTotal();i++)
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                  if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
                     {
                        if(OrderMagicNumber()==magic)
                           {
                              if(maxtickt>OrderTicket())
                                 {
                                    maxtickt=OrderTicket();
                                 }
                           }
                     }
               }
         }
      return(maxtickt);
   }

   
double getbuylastTP_nishi(int magic)
   {
      if(buylastticket_nishi(magic)!=0)
         {
            if(OrderSelect(buylastticket_nishi(magic),SELECT_BY_TICKET,MODE_TRADES)==true)
               {
                  return(OrderTakeProfit());
               }
            else
               {
                  return(0);
               }
         }
        else
         {
            return(0);
         }
   }
 
 
double getselllastTP_nishi(int magic)
   {
      if(selllastticket_nishi(magic)!=0)
         {
            if(OrderSelect(selllastticket_nishi(magic),SELECT_BY_TICKET,MODE_TRADES)==true)
               {
                  return(OrderTakeProfit());
               }
            else
               {
                  return(0);
               }
         }
        else
         {
            return(0);
         }
   }


   
double getbuylastSL_nishi(int magic)
   {
      if(buyoldticket_nishi(magic)!=0)
         {
            if(OrderSelect(buyoldticket_nishi(magic),SELECT_BY_TICKET,MODE_TRADES)==true)
               {
                  return(OrderStopLoss());
               }
            else
               {
                  return(0);
               }
         }
        else
         {
            return(0);
         }
   }
 
 
double getselllastSL_nishi(int magic)
   {
      if(selloldticket_nishi(magic)!=0)
         {
            if(OrderSelect(selloldticket_nishi(magic),SELECT_BY_TICKET,MODE_TRADES)==true)
               {
                  return(OrderStopLoss());
               }
            else
               {
                  return(0);
               }
         }
        else
         {
            return(0);
         }
   }




//多单函数
int Buy(double lots,double loss,double profit,string comment_buy, int magic)
   {
      int a=0;
      bool Com_Buy=false;
      for(int b=0;b<OrdersTotal();b++)
         {
            if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES)==true)
               {
                  string comment=OrderComment();
                  if(comment_buy==comment)
                     {
                        Com_Buy=true;
                        break;
                     } 
               }
         }
         
       if(Com_Buy==false)
         {
            int ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,500,0,0,comment_buy,magic,0,clrBlue);
            if(ticket>0)
               {
                  if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)==true)
                     {
                        if(loss!=0 && profit!=0)
                           {
                              a=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-loss*MarketInfo(Symbol(),MODE_POINT),OrderOpenPrice()+profit*MarketInfo(Symbol(),MODE_POINT),0,clrWhite);
                           }
                        
                        if(loss!=0 && profit==0)
                           {
                              a=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-loss*MarketInfo(Symbol(),MODE_POINT),0,0,clrWhite);
                           }
                        
                        if(loss==0 && profit!=0)
                           {
                              a=OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderOpenPrice()+profit*MarketInfo(Symbol(),MODE_POINT),0,clrWhite);
                           }
                     }
               }
            return(ticket);
         }
      return(0);   
   }
 
//空单函数    
int Sell(double lots,double loss,double profit,string comment_sell,int magic)
   {
      int a=0;
      bool Com_Sell=false;
      for(int s=0;s<OrdersTotal();s++)
         {
            if(OrderSelect(s,SELECT_BY_POS,MODE_TRADES))
               {
                  string comment=OrderComment();
                  if(comment_sell==comment)
                     {
                        Com_Sell=true;
                        break;
                     }
               }
         }
       
       if(Com_Sell==false)
         {
            int ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,500,0,0,comment_sell,magic,0,clrRed);
            if(ticket>0)
               {
                  if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)==true)
                     {
                        if(loss!=0 && profit!=0)
                           {
                              a=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+loss*MarketInfo(Symbol(),MODE_POINT),OrderOpenPrice()-profit*MarketInfo(Symbol(),MODE_POINT),0,clrWheat);
                           }
                        
                        if(loss!=0 && profit==0)
                           {
                              a=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+loss*MarketInfo(Symbol(),MODE_POINT),0,0,clrWheat);
                           }
                        
                        if(loss==0 && profit!=0)
                           {
                              a=OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderOpenPrice()-profit*MarketInfo(Symbol(),MODE_POINT),0,clrWheat);
                           } 
                     }
               }
            return(ticket);   
         }
      return(0);
   }
   
double buyorderprofit(int magic)
   {
      double profit=0;
      for(int i=OrdersTotal()-1;i>=0;i--)
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                  if(OrderSymbol()==Symbol())
                     {
                        if(OrderMagicNumber()==magic && OrderType()==OP_BUY)
                           {
                              profit=profit+OrderProfit()+OrderSwap()+OrderCommission();
                           }
                     }
               }
         }
      return(profit);
   }


double sellorderprofit(int magic)
   {
      double profit=0;
      for(int i=OrdersTotal()-1;i>=0;i--)
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                  if(OrderSymbol()==Symbol())
                     {
                        if(OrderMagicNumber()==magic && OrderType()==OP_SELL)
                           {
                              profit=profit+OrderProfit()+OrderSwap()+OrderCommission();
                           }
                     }
               }
         }
      return(profit);
   }
   
double Lots_Buy(int magic) 
   {
      double averageprice = 0;
      double orderlosts = 0;
      for (int i = OrdersTotal() - 1; i >= 0; i--) 
         {
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
               {
                  if (OrderSymbol() == Symbol() && OrderMagicNumber()==magic) 
                     {
                              if (OrderType() == OP_BUY) {
                                 orderlosts = orderlosts+OrderLots();
                              }
                        
                     }
               }
          }
       return (orderlosts);
   }
//
double Lots_Sell(int magic) 
   {
      double averageprice = 0;
      double orderlosts = 0;
      for (int i = OrdersTotal() - 1; i >= 0; i--) 
         {
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
               {
                  if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
                     {             
                              if (OrderType() == OP_SELL) 
                                 {
                                    orderlosts =orderlosts+ OrderLots();
                                 }
                     }
               }
          }
      return (orderlosts);
   }


int lastticketnumber_history(int magic)
   {
      int maxtickt=0;
      if(OrdersHistoryTotal()>0)
         {
            for(int i=OrdersHistoryTotal();i>=0;i--)
               {
                  if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
                     {
                        if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
                           {
                              if(OrderType()==OP_SELL || OrderType()==OP_BUY)
                                 {
                                    if(maxtickt<OrderTicket())
                                       {
                                          maxtickt=OrderTicket();
                                       }
                                 }
                           }
                     }
               }
         }
      return(maxtickt);
   }

   
int lasthistorytype(int magic)
   {
      if(lastticketnumber_history(magic)!=0)
         {
            if(OrderSelect(lastticketnumber_history(magic),SELECT_BY_TICKET,MODE_HISTORY)==true)
               {
                  return(OrderType());
               }
            else
               {
                  return(0);
               }
         }
        else
         {
            return(0);
         }
   }
   