#property copyright "Fauzaan Gasim"
#property link      "https://www.fauzaanu.com"
#property version   "1.06"
#property strict

//--- External user variables
extern double RiskPercent = 1.0;     // Risk percentage per trade
extern int    MagicNumber = 12345;   // Magic number to identify the trades
extern int    Slippage = 3;          // Slippage for the trade execution
extern double EMA_Period = 50;       // Period of the EMA
extern double ATR_Period = 24;       // Period for ATR calculation (Daily)
extern double ATR_Multiplier_TP = 1.0 / 3.0;  // Multiplier for TP
extern double ATR_Multiplier_SL = 1.0;        // Multiplier for SL

double askPrice, bidPrice, slPrice, tpPrice, lotSize;
int  ticket;

//--- Function to calculate lot size based on risk
double CalculateLotSize(double price1, double price2, double risk)
  {
   double SLX = MathAbs(price1 - price2) / _Point; //
   double LotSize;
   double nTickValue = MarketInfo(Symbol(), MODE_TICKVALUE);

    // Adjust tick value for 3 or 5-digit brokers
   if((Digits == 3) || (Digits == 5))
     {
      nTickValue = nTickValue * 1;
     }

   double balance = AccountBalance(); // Get the account balance

// Calculate position size (lot size) based on the risk formula
   LotSize = (balance * (risk / 100)) / (SLX * nTickValue);
   LotSize = NormalizeDouble(LotSize, 2); // Normalize to 2 decimal places for lot size
   Print(LotSize);

   return LotSize;
  }


void OnTick()
  {
   double emaValue = iMA(NULL, 0, EMA_Period, 0, MODE_EMA, PRICE_CLOSE, 1); // 50 EMA value of previous candle
   double lastClose = iClose(NULL, 0, 1); // Last candle close price

// Calculate ATR for TP and SL (Daily period)
   double atr = iATR(Symbol(), PERIOD_D1, ATR_Period, 0);
   double tpDistance = atr * ATR_Multiplier_TP; // Take Profit distance
   double slDistance = atr * ATR_Multiplier_SL; // Stop Loss distance

// Check if the trend is bullish (last close > 50 EMA)
   if(lastClose > emaValue)
     {
      // Check if there are no open buy positions with the same MagicNumber
      if(OrdersTotalCustom(OP_BUY) == 0)
        {
         askPrice = Ask; // Current ask price
         slPrice = askPrice - slDistance; // SL price for buy
         tpPrice = askPrice + tpDistance; // TP price for buy
         lotSize = CalculateLotSize(askPrice, slPrice, RiskPercent); // Calculate lot size based on risk
Print(lotSize,"from order");
         // Open a buy trade
         ticket = OrderSend(Symbol(), OP_BUY, lotSize, askPrice, Slippage, slPrice, tpPrice, "EMA 50 Bullish Buy", MagicNumber, 0, Blue);
         if(ticket < 0)
           {
            Print("Error opening BUY order: ", GetLastError());
           }
         else
           {
            Print("BUY order opened successfully. Ticket: ", ticket);
           }
        }
     }
// Check if the trend is bearish (last close < 50 EMA)
   else
      if(lastClose < emaValue)
        {
         // Check if there are no open sell positions with the same MagicNumber
         if(OrdersTotalCustom(OP_SELL) == 0)
           {
            bidPrice = Bid; // Current bid price
            slPrice = bidPrice + slDistance; // SL price for sell
            tpPrice = bidPrice - tpDistance; // TP price for sell
            lotSize = CalculateLotSize(bidPrice, slPrice, RiskPercent); // Calculate lot size based on risk
Print(lotSize,"from order");
            // Open a sell trade
            ticket = OrderSend(Symbol(), OP_SELL, lotSize, bidPrice, Slippage, slPrice, tpPrice, "EMA 50 Bearish Sell", MagicNumber, 0, Red);
            if(ticket < 0)
              {
               Print("Error opening SELL order: ", GetLastError());
              }
            else
              {
               Print("SELL order opened successfully. Ticket: ", ticket);
              }
           }
        }
  }

//--- Helper function to count open orders of a specific type
int OrdersTotalCustom(int orderType)
  {
   int count = 0;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS) && OrderMagicNumber() == MagicNumber && OrderType() == orderType)
        {
         count++;
        }
     }
   return count;
  }

