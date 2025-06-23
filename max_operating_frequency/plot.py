import matplotlib.pyplot as plt
import pandas as pnd
import numpy as np
from scipy.stats import linregress

sweep = pnd.read_csv('sweep_results.csv')
clock_period = sweep['Clock_period(ns)'].to_numpy()
wns = sweep['WNS(ns)'].to_numpy()
wpws = sweep['WPWS(ns)'].to_numpy()

#Linear regression
mask = (wns >= -4) & (wns <= 0)
filtered_clock = clock_period[mask]
filtered_wns = wns[mask]
slope, intercept, r_value, p_value, std_err = linregress(filtered_clock, filtered_wns)
print(f"Fitted line: WNS = {slope:.4f} * Clock + {intercept:.4f}")
print(f"R-squared: {r_value**2:.4f}")

# Line parameters
#k = 4.944-0.4395  # Example x-intercept value
#x_line = np.linspace(min(clock_period), max(clock_period), 100)
#y_line = x_line - k  # y = x - k


# Plot 1: WNS vs Clock Period
plt.figure(figsize=(8, 5))
#wns
plt.plot(clock_period, wns, 'bo-', linewidth=1.5, markersize=4, label='WNS')
#wpws
plt.plot(clock_period, wpws, 'rs-', linewidth=1.5, markersize=4, label='WPWS')
#strght line
#plt.plot(x_line, y_line, 'k--', linewidth=1.2, label=f'y = x - {k}')
#regression
plt.plot(filtered_clock, slope*filtered_clock + intercept, color='green', linestyle='-' , label=f'Regression: y = {slope:.2f}x + {intercept:.2f}')

plt.title('WNS vs Clock Period')
plt.xlabel('Clock Period (ns)')
plt.ylabel('Worst Negative Slack (ns)')
plt.grid(True)
plt.legend()
plt.tight_layout()

# Plot 2: WHS vs Clock Period
#plt.figure(figsize=(8, 5))
#plt.plot(clock_period, whs, 'go-', linewidth=1.5, markersize=4, label='WHS')
#plt.title('WHS vs Clock Period')
#plt.xlabel('Clock Period (ns)')
#plt.ylabel('Worst Hold Slack (ns)')
#plt.grid(True)
#plt.legend()
#plt.tight_layout()

# Plot 3: WPWS vs Clock Period
#plt.figure(figsize=(8, 5))
#plt.plot(clock_period, wpws, 'rs-', linewidth=1.5, markersize=4, label='WPWS')
#plt.title('WPWS vs Clock Period')
#plt.xlabel('Clock Period (ns)')
#plt.ylabel('Worst Pulse Width Slack Slack (ns)')
#plt.grid(True)
#plt.legend()
#plt.tight_layout()
plt.show(block=False)
input("Enter to exit script")

