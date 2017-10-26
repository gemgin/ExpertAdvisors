//+------------------------------------------------------------------+
//|                                           NormalDistribution.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://hexun.com/ctfysj/ |
//+------------------------------------------------------------------+
#include <stdlib.mqh>
//#include <ea_comm.mqh>

#define COMM            "EA_Test"

extern string Author_QQ  = "10144229";
extern string Author_email  = "ok1990@126.com";
extern string Author_blog  = "http://blog.sina.com.cn/doudoutababa";

extern double  MIN_EQ = 300;
extern int STOPLOST = 30;
double RISK = 1;
int MAGIC = 19003;
int last_trade_period = 0;
int last_trade_type = -100;
double last_lots=0;
int MIN_TRADE_TIME=0;
extern double Lots = 0;

bool buy_close() {
   double k = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_MAIN, 1);
   double kp = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_MAIN, 2);
   double d = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_SIGNAL, 1);
   double dp = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_SIGNAL, 2);
   
   return ( k<d );
}
bool sell_close() {
   double k = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_MAIN, 1);
   double kp = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_MAIN, 2);
   double d = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_SIGNAL, 1);
   double dp = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_SIGNAL, 2);
   
   return ( k>d );
}
bool buy_add() {
   return (false);
}
bool sell_add() {
   return (false);
}
bool buy_ready() {
   return ( iMACD(Symbol(), 0, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)>0 );
}
bool sell_ready() {
   return ( iMACD(Symbol(), 0, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)<0 );
}
bool buy_ok() {
   double k = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_MAIN, 1);
   double kp = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_MAIN, 2);
   double d = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_SIGNAL, 1);
   double dp = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_SIGNAL, 2);
   return (kp<dp && k>d);
}
bool sell_ok() {
   double k = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_MAIN, 1);
   double kp = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_MAIN, 2);
   double d = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_SIGNAL, 1);
   double dp = iStochastic(Symbol(), 0, 9, 3, 3, MODE_SMA, 1, MODE_SIGNAL, 2);
   return (kp>dp && k<d);
}

int init() {
   int ty;
   MIN_TRADE_TIME = Period()*60;
   for(int cnt=0; cnt<OrdersTotal(); cnt++) {
      if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) ) {
         if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC && OrderCloseTime()<=0 && OrderComment()==COMM ) {
            ty = OrderType();
            if (ty==OP_BUY || ty==OP_SELL) {
               Print("[", COMM, "]ÏÖÓÐOrder£º", OrderTicket());
               last_trade_period = OrderOpenTime() / MIN_TRADE_TIME;
               last_trade_type = ty;
               last_lots = OrderLots();
            }   
         }
      }
   }   
   return (0);
}
int deinit() {
   return (0);
}
int start() {     
   if ( AccountEquity()<MIN_EQ && ea_orders(COMM, MAGIC)==0 ) {
      Print("[", COMM, "]BUSINESS STOP.");
      return(0);
   }
   
   double p;
   int next, cnt, action=0;
   
   if ( buy_ready() && buy_ok() ) {
      action = 10;
   } else if ( sell_ready() && sell_ok() ) {
      action = -10;
   }   
   
   if (RISK>0) Lots = NormalizeDouble(AccountEquity()/(20000*RISK), 2);
   if (Lots<0.01) Lots = 0.01;
   
   cnt = CurTime() / MIN_TRADE_TIME;
   if (ea_orders(COMM, MAGIC)==0 && cnt!=last_trade_period ) {
      if ( action == 10 ) {
         p = MathMin(Low[0], Low[1])-STOPLOST*Point;
         if (ea_order_send(COMM, OP_BUY, Lots, Ask, 1, p, 0, MAGIC)) {
            Print("ÒÑÏÂÂòµ¥");
            last_trade_period = CurTime() / MIN_TRADE_TIME;
            last_trade_type = OP_BUY;
            last_lots = Lots;
         }
      } else if ( action == -10 ) {
         p = MathMax(High[0], High[1])+STOPLOST*Point;
         if (ea_order_send(COMM, OP_SELL, Lots, Bid, 1, p, 0, MAGIC)) {
            Print("ÒÑÏÂÂôµ¥");
            last_trade_period = CurTime() / MIN_TRADE_TIME;
            last_trade_type = OP_SELL;
            last_lots = Lots;
         }   
      }           
   } else if (ea_orders(COMM, MAGIC)>0) {  //µ±Ç°ÓÐµ¥
      cnt = CurTime() / MIN_TRADE_TIME;
      //ea_pipslock_big_all(COMM, MAGIC);
      if (cnt > last_trade_period) {
         if ( last_trade_type==OP_BUY ) {
            if ( buy_close() ) {
               if ( ea_order_close(COMM, MAGIC) ) {
                  last_trade_period = 0;
               }
            } else if ( buy_add() ) {
               p = MathMin(Low[0], Low[1])-STOPLOST*Point;
               if ( ea_order_send(COMM, OP_BUY, last_lots, Ask, 1, p, 0, MAGIC) ) {
                  Print("ÒÑÏÂÂòµ¥");
                  last_trade_period = CurTime() / MIN_TRADE_TIME;
               }   
            }
         }   
         if ( last_trade_type==OP_SELL ) {
            if ( sell_close() ) {
               if ( ea_order_close(COMM, MAGIC) ) {
                  last_trade_period = 0;
               } 
            } else if ( sell_add() ) {
               p = MathMax(High[0], High[1])+STOPLOST*Point;
               if ( ea_order_send(COMM, OP_SELL, last_lots, Bid, 1, p, 0, MAGIC) ) {
                  Print("ÒÑÏÂÂôµ¥");
                  last_trade_period = CurTime() / MIN_TRADE_TIME;
               }   
            }   
         }
      } 
   }   
   return (0);
}   

bool ea_order_send(string ea, int OP, double lots, double price, int slip, double sl, double tp, int magic) {
   color cl = Red;
   if (OP==OP_SELL || OP==OP_SELLLIMIT || OP==OP_SELLSTOP)  cl = Blue;
   if (OrderSend(Symbol(), OP, NormalizeDouble(lots, 4), NormalizeDouble(price,Digits), slip, 
         NormalizeDouble(sl,Digits), NormalizeDouble(tp,Digits), ea, magic, 0, cl)<=0) {
      if (cl==Red) Print("[", ea, "]Order Send BUY Ê§°Ü£º", ErrorDescription(GetLastError()), ", price=", price+", sl=", sl);
      if (cl==Blue) Print("[", ea, "]Order Send SELL Ê§°Ü£º", ErrorDescription(GetLastError()), ", price=", price+", sl=", sl);
      return (false);
   }
   return (true);
}

int ea_orders(string ea, int magic) {
   int i, cnt=0, ty;
   for (i=0; i<OrdersTotal(); i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderComment()==ea 
            && OrderMagicNumber()==magic && OrderCloseTime()<=0 ) {
         ty = OrderType();
         if (ty==OP_BUY || ty==OP_SELL) {
            cnt ++;
         }   
      }
   }
   return (cnt);      
}

bool ea_order_close(string ea, int magic) {
   int i, ty;
   double p;
   int cnt;
   bool ok = false;
   while (!ok) {
      ok = true;
      cnt = OrdersTotal();
      for (i=0; i<cnt; i++) {
         OrderSelect(i, SELECT_BY_POS);
         if (OrderSymbol()==Symbol() && OrderComment()==ea && OrderMagicNumber()==magic && OrderCloseTime()<=0 ) {
            ty = OrderType();
            p = -1;
            if (ty==OP_BUY) p = Bid;
            else if (ty==OP_SELL) p = Ask;
            if (p>0) {         
               if (!OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(p, Digits), 0, Yellow)) {
                  Print("[", ea, "]OrderClose Ê§°Ü£º", ErrorDescription(GetLastError()));
                  return (false);
               } else {
                  ok = false;
               }
            }                     
         }
      }  
   }   
   return (true);
}