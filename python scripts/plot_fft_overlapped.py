import pandas as pd
import matplotlib.pyplot as plt

plot_for = "band1"

if plot_for=="band1":
    df_fxpt10_1 = pd.read_csv("D:\SEM 4\RnD\\fxpt10_1_band1.csv")
    df_fxpt10_2 = pd.read_csv("D:\SEM 4\RnD\\fxpt10_2_band1.csv")
    df_fxpt16_1 = pd.read_csv("D:\SEM 4\RnD\\fxpt16_1_band1.csv")
    df_fxpt16_2 = pd.read_csv("D:\SEM 4\RnD\\fxpt16_2_band1.csv")
    df_flpt = pd.read_csv("D:\SEM 4\RnD\\flpt_band1.csv")
    df_goldenref = pd.read_csv("D:\SEM 4\RnD\goldenref_band1.csv")
    plot_title = "Band 1 FFT comparison"

elif plot_for=="band2":
    df_fxpt10_1 = pd.read_csv("D:\SEM 4\RnD\\fxpt10_1_band2.csv")
    df_fxpt10_2 = pd.read_csv("D:\SEM 4\RnD\\fxpt10_2_band2.csv")
    df_fxpt16_1 = pd.read_csv("D:\SEM 4\RnD\\fxpt16_1_band2.csv")
    df_fxpt16_2 = pd.read_csv("D:\SEM 4\RnD\\fxpt16_2_band2.csv")
    df_flpt = pd.read_csv("D:\SEM 4\RnD\\flpt_band2.csv")
    df_goldenref = pd.read_csv("D:\SEM 4\RnD\goldenref_band2.csv")
    plot_title = "Band 2 FFT comparison"

elif plot_for=="band3":
    df_fxpt10_1 = pd.read_csv("D:\SEM 4\RnD\\fxpt10_1_band3.csv")
    df_fxpt10_2 = pd.read_csv("D:\SEM 4\RnD\\fxpt10_2_band3.csv")
    df_fxpt16_1 = pd.read_csv("D:\SEM 4\RnD\\fxpt16_1_band3.csv")
    df_fxpt16_2 = pd.read_csv("D:\SEM 4\RnD\\fxpt16_2_band3.csv")
    df_flpt = pd.read_csv("D:\SEM 4\RnD\\flpt_band3.csv")
    df_goldenref = pd.read_csv("D:\SEM 4\RnD\goldenref_band3.csv")
    plot_title = "Band 3 FFT comparison"

elif plot_for=="band4":
    df_fxpt10_1 = pd.read_csv("D:\SEM 4\RnD\\fxpt10_1_band4.csv")
    df_fxpt10_2 = pd.read_csv("D:\SEM 4\RnD\\fxpt10_2_band4.csv")
    df_fxpt16_1 = pd.read_csv("D:\SEM 4\RnD\\fxpt16_1_band4.csv")
    df_fxpt16_2 = pd.read_csv("D:\SEM 4\RnD\\fxpt16_2_band4.csv")
    df_flpt = pd.read_csv("D:\SEM 4\RnD\\flpt_band4.csv")
    df_goldenref = pd.read_csv("D:\SEM 4\RnD\goldenref_band4.csv")
    plot_title = "Band 4 FFT comparison"



x = df_fxpt10_1["freq"]

y1 = df_fxpt10_1["fft"]
y2 = df_fxpt10_2["fft"]
y3 = df_fxpt16_1["fft"]
y4 = df_fxpt16_2["fft"]
y5 = df_flpt["fft"]
y6 = df_goldenref["fft"]

plt.plot(x, y1, label="10 bit fixed point 1 - 20 bit adder, 20 bit multiplier")
plt.plot(x, y2, label="10 bit fixed point 2 - 10 bit adder, 10 bit multiplier")
plt.plot(x, y3, label="16 bit fixed point 1 - 32 bit adder, 32 bit multiplier")
plt.plot(x, y4, label="16 bit fixed point 2 - 16 bit adder, 16 bit multiplier")
plt.plot(x, y5, label="10 bit floating point")
plt.plot(x, y6, label="Golden reference")
plt.title(plot_title)
plt.legend(loc='best')
plt.ylim(bottom = -250)
plt.grid(True)
plt.xlabel('Frequency (Hz)')
plt.ylabel('Amplitude (dB)')
plt.show()