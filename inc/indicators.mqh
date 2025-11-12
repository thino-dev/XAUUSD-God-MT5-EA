#ifndef INC_INDICATORS_MQH
#define INC_INDICATORS_MQH

#include "config_inputs.mqh"

static int g_handleATR = INVALID_HANDLE;
static int g_handleADX = INVALID_HANDLE;
static int g_handleEMA = INVALID_HANDLE;
static int g_handleRSI = INVALID_HANDLE;
static string g_symbol = "";
static ENUM_TIMEFRAMES g_tf = PERIOD_CURRENT;

bool InitIndicators(const string symbol, const ENUM_TIMEFRAMES tf)
{
   g_symbol = symbol;
   g_tf = tf;
   
   g_handleATR = iATR(symbol, tf, ATR_Period);
   g_handleADX = iADX(symbol, tf, ADX_Period);
   g_handleEMA = iMA(symbol, tf, EMA_Trend_Period, 0, MODE_EMA, PRICE_CLOSE);
   g_handleRSI = iRSI(symbol, tf, RSI_Period, PRICE_CLOSE);
   
   if(g_handleATR == INVALID_HANDLE || g_handleADX == INVALID_HANDLE || 
      g_handleEMA == INVALID_HANDLE || g_handleRSI == INVALID_HANDLE)
   {
      return false;
   }
   
   return true;
}

void FreeIndicators()
{
   if(g_handleATR != INVALID_HANDLE)
   {
      IndicatorRelease(g_handleATR);
      g_handleATR = INVALID_HANDLE;
   }
   if(g_handleADX != INVALID_HANDLE)
   {
      IndicatorRelease(g_handleADX);
      g_handleADX = INVALID_HANDLE;
   }
   if(g_handleEMA != INVALID_HANDLE)
   {
      IndicatorRelease(g_handleEMA);
      g_handleEMA = INVALID_HANDLE;
   }
   if(g_handleRSI != INVALID_HANDLE)
   {
      IndicatorRelease(g_handleRSI);
      g_handleRSI = INVALID_HANDLE;
   }
}

double ATR(const int bar_index)
{
   if(bar_index < 1) return EMPTY_VALUE;
   
   double arr[1];
   if(CopyBuffer(g_handleATR, 0, bar_index, 1, arr) <= 0)
      return EMPTY_VALUE;
   
   if(arr[0] == EMPTY_VALUE)
      return EMPTY_VALUE;
   
   return arr[0];
}

double ADX(const int bar_index)
{
   if(bar_index < 1) return EMPTY_VALUE;
   
   double arr[1];
   if(CopyBuffer(g_handleADX, 0, bar_index, 1, arr) <= 0)
      return EMPTY_VALUE;
   
   if(arr[0] == EMPTY_VALUE)
      return EMPTY_VALUE;
   
   return arr[0];
}

double EMA(const int bar_index)
{
   if(bar_index < 1) return EMPTY_VALUE;
   
   double arr[1];
   if(CopyBuffer(g_handleEMA, 0, bar_index, 1, arr) <= 0)
      return EMPTY_VALUE;
   
   if(arr[0] == EMPTY_VALUE)
      return EMPTY_VALUE;
   
   return arr[0];
}

double RSI(const int bar_index)
{
   if(bar_index < 1) return EMPTY_VALUE;
   
   double arr[1];
   if(CopyBuffer(g_handleRSI, 0, bar_index, 1, arr) <= 0)
      return EMPTY_VALUE;
   
   if(arr[0] == EMPTY_VALUE)
      return EMPTY_VALUE;
   
   return arr[0];
}

double VolumeMA(const int bar_index)
{
   if(Vol_MA_Period <= 0 || bar_index < (Vol_MA_Period - 1))
      return EMPTY_VALUE;
   
   long vol_arr[];
   int copied = CopyTickVolume(g_symbol, g_tf, bar_index - (Vol_MA_Period - 1), Vol_MA_Period, vol_arr);
   
   if(copied < Vol_MA_Period)
      return EMPTY_VALUE;
   
   double sum = 0.0;
   for(int i = 0; i < Vol_MA_Period; i++)
   {
      sum += (double)vol_arr[i];
   }
   
   return sum / Vol_MA_Period;
}

#endif // INC_INDICATORS_MQH