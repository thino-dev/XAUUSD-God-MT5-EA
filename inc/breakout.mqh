//+------------------------------------------------------------------+
//|                                                     breakout.mqh |
//|                                          XAUUSD-GOD EA - Part G |
//|                                      Trend Breakout Signal Logic |
//+------------------------------------------------------------------+
#ifndef INC_BREAKOUT_MQH
#define INC_BREAKOUT_MQH

#include "types.mqh"
#include "config_inputs.mqh"
#include "constants.mqh"
#include "indicators.mqh"
#include "filters.mqh"

//+------------------------------------------------------------------+
//| ScanAndSignal_Breakout                                           |
//| Scans for trend-breakout entries using CLOSED bars only         |
//| Returns Signal with pending entry level, SL, TP                  |
//+------------------------------------------------------------------+
Signal ScanAndSignal_Breakout()
{
   Signal sig;
   sig.valid = false;
   sig.dir = DIR_NONE;
   sig.entry = 0.0;
   sig.sl = 0.0;
   sig.tp = 0.0;
   sig.reason = "";

   // 1) Read last CLOSED bar (index 1) - explicit OHLC
   double o1 = iOpen(_Symbol, PERIOD_CURRENT, 1);
   double h1 = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double l1 = iLow(_Symbol, PERIOD_CURRENT, 1);
   double c1 = iClose(_Symbol, PERIOD_CURRENT, 1);
   
   if(o1 == 0.0 || o1 == EMPTY_VALUE || h1 == 0.0 || h1 == EMPTY_VALUE ||
      l1 == 0.0 || l1 == EMPTY_VALUE || c1 == 0.0 || c1 == EMPTY_VALUE)
   {
      return sig;
   }

   // 2) EMA trend bias (closed bar only)
   double ema1 = EMA(1);
   if(ema1 == EMPTY_VALUE)
   {
      return sig;
   }
   
   // Equal-bias case: no trade
   if(c1 == ema1)
   {
      return sig;
   }
   
   Direction bias = DIR_NONE;
   if(c1 > ema1)
      bias = DIR_LONG;
   else if(c1 < ema1)
      bias = DIR_SHORT;

   // 3) Determine breakout levels from closed bars [1 .. Breakout_Lookback]
   if(Breakout_Lookback <= 1)
   {
      return sig;
   }
   
   int bars_total = Bars(_Symbol, PERIOD_CURRENT);
   if(bars_total <= Breakout_Lookback)
   {
      return sig;
   }

   double recent_high = -DBL_MAX;
   double recent_low = DBL_MAX;
   
   // Loop strictly on closed bars: [1 .. Breakout_Lookback]
   for(int i = 1; i <= Breakout_Lookback; i++)
   {
      double hi = iHigh(_Symbol, PERIOD_CURRENT, i);
      double lo = iLow(_Symbol, PERIOD_CURRENT, i);
      
      if(hi == 0.0 || hi == EMPTY_VALUE || lo == 0.0 || lo == EMPTY_VALUE)
      {
         return sig;
      }
      
      if(hi > recent_high)
         recent_high = hi;
      if(lo < recent_low)
         recent_low = lo;
   }
   
   if(recent_high <= recent_low)
   {
      return sig;
   }

   // 4) Close-beyond buffer and pending offset
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   if(point <= 0.0)
   {
      return sig;
   }
   
   double close_beyond = Breakout_CloseBeyond_Points * point;
   double pending_offset = Pending_Offset_Points * point;

   // 5) Breakout detection using CLOSED bar (index 1)
   bool is_long_breakout = false;
   bool is_short_breakout = false;
   
   if(bias == DIR_LONG)
   {
      if(c1 >= (recent_high + close_beyond))
         is_long_breakout = true;
   }
   else if(bias == DIR_SHORT)
   {
      if(c1 <= (recent_low - close_beyond))
         is_short_breakout = true;
   }
   
   if(!is_long_breakout && !is_short_breakout)
   {
      return sig;
   }

   // 6) Optional volume confirmation
   if(Vol_MA_Period > 0 && Vol_Min_Ratio > 0.0)
   {
      if(!VolumeConfirm())
      {
         return sig;
      }
   }

   // 7) ATR-based SL sizing with MIN_SL_POINTS baseline
   double atr1 = ATR(1);
   if(atr1 == EMPTY_VALUE || atr1 <= 0.0)
   {
      return sig;
   }
   
   // ATR -> points conversion
   double atr_points = atr1 / point;
   int sl_points = (int)MathRound(ATR_Mult_SL_Trend * atr_points);
   // MIN_SL_POINTS baseline
   sl_points = (int)MathMax((double)MIN_SL_POINTS, (double)sl_points);
   double sl_price_dist = sl_points * point;

   // 8) Build entry (pending stop level), SL, TP
   if(is_long_breakout)
   {
      // Entry = pending buy stop level
      double entry = recent_high + pending_offset;
      double sl = entry - sl_price_dist;
      double tp = 0.0;
      
      if(TP_Mode == TP_FIXED && TP_Fixed_Points > 0)
      {
         tp = entry + (TP_Fixed_Points * point);
      }
      else if(TP_Mode == TP_RR && RR_Target > 0.0)
      {
         tp = entry + (RR_Target * sl_points * point);
      }
      
      sig.valid = true;
      sig.dir = DIR_LONG;
      sig.entry = entry;
      sig.sl = sl;
      sig.tp = tp;
      sig.reason = REASON_TREND_BO;
      return sig;
   }
   else if(is_short_breakout)
   {
      // Entry = pending sell stop level
      double entry = recent_low - pending_offset;
      double sl = entry + sl_price_dist;
      double tp = 0.0;
      
      if(TP_Mode == TP_FIXED && TP_Fixed_Points > 0)
      {
         tp = entry - (TP_Fixed_Points * point);
      }
      else if(TP_Mode == TP_RR && RR_Target > 0.0)
      {
         tp = entry - (RR_Target * sl_points * point);
      }
      
      sig.valid = true;
      sig.dir = DIR_SHORT;
      sig.entry = entry;
      sig.sl = sl;
      sig.tp = tp;
      sig.reason = REASON_TREND_BO;
      return sig;
   }

   return sig;
}

#endif // INC_BREAKOUT_MQH