import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# construct sine wave
sample_rate = 40
start_time = 0
end_time = 10.025
time = np.arange(start_time, end_time, 1.0/(sample_rate))
frequency = 2
amplitude = 1
sinewave =  np.sin(2 * np.pi * 2 * time) + np.sin(2 * np.pi * 3 * time)
# plot sine wave
plt.plot(time, sinewave)
plt.title('Sine wave')
plt.xlabel('Time')
plt.ylabel('Amplitude')
plt.grid()
plt.show()

# fft
window = np.hanning(len(time))
fourier = np.fft.rfft(sinewave)
print("len(fourier)=",len(fourier))
print("len(sinewave)=",len(sinewave))
freq = np.fft.rfftfreq(len(sinewave), d=1.0/sample_rate)
print(freq)
print("len(freq)=",len(freq))
# plot FFT
fft_y = 20*np.log10(np.abs(fourier)/np.abs(fourier).max())
plt.plot(freq, fft_y)
plt.title('FFT plot of result')
plt.ylim(bottom=-60)
plt.grid()
plt.xlabel('Freq(Hz)')
plt.ylabel('Amplitude')
plt.show()

