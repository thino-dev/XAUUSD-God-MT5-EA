#ifndef INC_CONFIG_INPUTS_MQH
#define INC_CONFIG_INPUTS_MQH

input int    ADX_Period            = 0;
input double ADX_Trend_Threshold   = 0.0;
input int    EMA_Trend_Period      = 0;

input int    ATR_Period            = 0;
input double ATR_Mult_SL_Range     = 0.0;
input double ATR_Mult_SL_Trend     = 0.0;

input int    Range_Lookback_Bars   = 0;
input int    Range_Min_Width_Points= 0;
input int    Range_Max_Width_Points= 0;

input int    Sweep_Buffer_Points        = 0;
input int    Sweep_Reentry_Confirm_Bars = 0;

input int    Breakout_Lookback          = 0;
input int    Breakout_CloseBeyond_Points= 0;

input int    RSI_Period          = 0;
input int    RSI_Buy_Threshold   = 0;
input int    RSI_Sell_Threshold  = 0;
input int    RSI_Exit            = 0;

input int    Vol_MA_Period   = 0;
input double Vol_Min_Ratio   = 0.0;

input int    Order_Type             = 0;
input int    Max_Slippage_Points    = 0;
input int    Pending_Offset_Points  = 0;
input int    Order_Expiration_Min   = 0;

input int    Risk_Mode                 = 0;
input double Fixed_Lot                 = 0.0;
input double Risk_Percent              = 0.0;
input double Max_Daily_Drawdown_Percent= 0.0;

input int    TP_Mode                = 0;
input int    TP_Fixed_Points        = 0;
input double RR_Target              = 0.0;
input bool   Use_Partials           = false;
input double Partial1_Ratio         = 0.0;
input int    Partial1_Target_Points = 0;
input int    Move_BE_After_Points   = 0;
input int    Trail_Mode             = 0;
input int    Trail_Start_Points     = 0;
input int    Trail_Step_Points      = 0;
input double Trail_ATR_Mult         = 0.0;

input int    Max_Spread_Points  = 0;
input int    Min_ATR_Points     = 0;
input bool   Trading_Day_Mon    = true;
input bool   Trading_Day_Tue    = true;
input bool   Trading_Day_Wed    = true;
input bool   Trading_Day_Thu    = true;
input bool   Trading_Day_Fri    = true;
input string Friday_CloseTime   = "";

input bool   Only_New_Bar   = true;
input int    Magic_Offset   = 0;
input string Order_Comment  = "";

#endif // INC_CONFIG_INPUTS_MQH