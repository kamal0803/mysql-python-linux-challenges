Challenge 1 - MANAGING MARKET & TRADE DATA
- Determine the top 5 stocks sorted by percentage gain on the day
  - Gain is the difference between open and close price
  - Percentage gain is as compared to open price
  - Output needs to clearly communicate its purpose
  
 - SAMPLE_DATASET1
   - Pricing information of NASDAQ stocks on a specific day   


Challenge 2 - CALCULATING VOLUME WEIGHTED AVERAGE PRICES 
- Determine the Volume Weighted Average Price
  - For 5-hour interval given a start time and date in the dataset.
  - Accept date and start time
  - Calculate end time ( 5 hours later)
  - VWAP = SUM(transaction_trade_size x trasaction_trade_price)/SUM(trade_size over the 5 hours)
    
 - SAMPLE_DATASET2
   - Apple stock prices over one month


Challenge 3 - IDENTIFY LARGES PRICES RANGES 
- Determine the 3 days on which price increased or decreased the most
  - Start = Opening price of first trade of the day
  - End = Closing price of first trade of the day
  - Display time each day that stock was at its maximum price
  - List dates in descending order of range
  - Display trading range each day
    
 - SAMPLE_DATASET3
   - Two weeks of IBM pricing information 
