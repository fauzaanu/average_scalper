# Average Scalper 📈

The **Average Scalper** strategy is a straightforward approach to trading using moving averages and the Average Daily Range (ADR).

## Strategy Overview

This strategy utilizes the **50 Exponential Moving Average (EMA)** to determine buy and sell signals, along with the **ADR** for risk management and profit targeting.

### Buy Signal 🟢

- **Condition:** Initiate a buy when the price is greater than the 50 EMA.
- **Stop Loss:** Set a stop loss at **1x ADR** away.
- **Target:** Aim for a profit of **1/3rd of ADR**.

### Sell Signal 🔴

- **Condition:** Initiate a sell when the price is less than the 50 EMA.
- **Stop Loss:** Set a stop loss at **1x ADR** away.
- **Target:** Aim for a profit of **1/3rd of ADR**.

## Rationale 🤔

- The stop loss is positioned to accommodate price fluctuations while allowing for a reasonable risk-reward ratio by targeting only 1/3rd of the ADR.
- Following the average trend through the 50 EMA helps align trades with prevailing market conditions.



