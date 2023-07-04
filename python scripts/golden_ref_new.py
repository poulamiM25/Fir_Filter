# python -u "D:\SEM 4\RnD\new_code\v2\golden_ref_new.py" -w1 4 -w2 8 -o 30 -bits 16 -fbits 14 -ws 20 -input_width 10 -type bp

#######################################
## Import all necessary libraries here
#######################################
import os
import sys
import matplotlib.pyplot as plt
import numpy as np
import math
import argparse
import random
import shutil
from scipy import signal
import pandas as pd
#######################################



#######################################
## Define all other functions here
#######################################
# Parse all command line arguments
def parse():
	my_parser = argparse.ArgumentParser(description='Make an FIR filter with the following parameters', epilog='For details contact 190070012@iitb.ac.in.')
	my_parser.add_argument('-w1', action='store', type=float, required=True, help='cut-off frequency for lowpass filter. first band-edge in case of bandpass filter')
	my_parser.add_argument('-w2', action='store', type=float, required=False, help='(optional argument) second band-edge of bandpass filter. Use only in case of bandpass filter specified in the "-type" argument')	
	my_parser.add_argument('-o', action='store', type=int, required=True, help='the order of the FIR filter')
	my_parser.add_argument('-bits', action='store', type=int, required=True, help='# of bits assigned for coefficients. Note that 1 bit will be assigned for sign')
	my_parser.add_argument('-fbits', action='store', type=int, required=True, help='# of bits assigned for fractional part')
	my_parser.add_argument('-ws', action='store', type=float, default=2000, help='sampling frequency in Hz. Default value is 2kHz')
	my_parser.add_argument('-input_width', action='store', type=int, default=10, help='define the length of the input data to filter. Default value is 10 bits')
	my_parser.add_argument('-type', action='store', type=str, default='lp', help='define type of filter. Accepted arguments are "lp" and "bp"')
	args = my_parser.parse_args()
	return args.w1, args.w2, args.o, args.bits, args.fbits, args.ws, args.input_width, args.type

def xylog_plotter(x, y, title):
	plt.semilogx(x, 20 * np.log10(abs(y)))
	plt.title(title)
	plt.xlabel('Frequency [Hz]')
	plt.ylabel('Amplitude [dB]')
	plt.grid(which='both', axis='both')
	plt.savefig(title)
	plt.show()
	
# Get the FIR filter with the given parameters
def my_filter_lp(wc, ws, resolution, order, plot_bool=False):
	# uni_freq_range = np.linspace(0, ws/2, resolution)
	# mag_resp = np.append(np.ones(round(wc*resolution*2/ws)), np.zeros(resolution - round(wc*resolution*2/ws)))
	# taps = signal.firwin2(order, uni_freq_range, mag_resp, fs=ws)
	taps = signal.firwin(order, wc, pass_zero=True, fs=ws)
	# print(taps)
	if(plot_bool):
		freq, resp = signal.freqz(taps, 1, fs=ws)
		#plot in logarithmic scale
		xylog_plotter(freq, resp, 'FIR lowpass filter logarithmic scale')
	return taps

def bandpass_firwin(ntaps, lowcut, highcut, fs, window='hamming'):
	nyq = 0.5 * fs
	taps = signal.firwin(ntaps, [lowcut, highcut], nyq=nyq, pass_zero=False, window=window, scale=False)
	return taps

def my_filter_bp(w1, w2, ws, resolution, order, plot_bool=True):
	# uni_freq_range = np.linspace(0, ws/2, resolution)
	# mag_resp = np.append(np.ones(round(wc*resolution*2/ws)), np.zeros(resolution - round(wc*resolution*2/ws)))
	# taps = signal.firwin2(order, uni_freq_range, mag_resp, fs=ws)
	taps = bandpass_firwin(order, w1, w2, ws)
	if(plot_bool):
		#plot in linear scale
		freq, resp = signal.freqz(taps, 1, worN=2000)
		plt.figure(1, figsize=(12, 9))
		plt.clf()
		# rect = plt.Rectangle((w1, 0), w2 - w1, 1.0, facecolor="#60ff60", alpha=0.2)
		# plt.gca().add_patch(rect)
		plt.plot((ws * 0.5 / np.pi) * freq, abs(resp), label="Hamming window")
		plt.xlim(-20, 20.0)
		plt.ylim(0, 1.1)
		plt.grid(True)
		plt.legend()
		plt.xlabel('Frequency (Hz)')
		plt.ylabel('Gain')
		plt.title('Band Pass FIR Unquantized Filter linear scale, %d taps' % order)
		plt.savefig('Band Pass FIR Unquantized Filter linear scale, %d taps' % order)
		plt.show()
		#plot in logarithmic scale
		xylog_plotter(freq, resp, 'Band Pass FIR Unquantized filter logarithmic scale')
	return taps

def get3dBfreq(coeffs, ws,plot=False):
	freq, resp = signal.freqz(coeffs, fs=ws)
	f = 20*np.log10(abs(resp)+1e-40)			#small epsilon added to avoid divide by zero 
	g = -3
	idx = np.argwhere(np.diff(np.sign(f - g))).flatten()
	if(plot):
		xylog_plotter(freq, resp, "Filter")
	return freq[idx]

def save_resp(filename,freq,resp):
	df = pd.DataFrame({"freq" : freq, "resp" : 20 * np.log10(abs(resp))})
	df.to_csv(filename, index=False)
	
def save_coeffs(filename,coeffs):
	df = pd.DataFrame({"coeffs" : coeffs})
	df.to_csv(filename, index=False)
	
#######################################
## Main function area
#######################################
# Parse all the arguments and store them
print("Parsing arguments ...")
f1, f2, order, no_of_bits, no_of_fractional_bits, f_sample, input_width, filter_type = parse()
print("Arguments parsed successfully. OK")

no_of_non_fractional_bits = no_of_bits - no_of_fractional_bits - 1	# 1 sign bit

print("Extracting taps for given parameters ...")
if filter_type=="lp":
	taps = my_filter_lp(f1, f_sample, 1000, order)
elif filter_type=="bp":
	taps = my_filter_bp(f1, f2, f_sample, 1000, order)
print("Retrieved taps successfully. OK")
#print(taps)

print("Analysing filter ...")
if filter_type=='lp':
	coeffs = taps
	freq3dB = get3dBfreq(coeffs, f_sample)
	print("freq3dB: ", freq3dB)
	freq, resp = signal.freqz(coeffs, fs = f_sample)
	xylog_plotter(freq, resp, 'Low Pass Golden ref FIR Filter logarithmic scale')
elif filter_type=='bp':
	coeffs = taps
	freq3dB = get3dBfreq(coeffs, f_sample)
	print("freq3dB: ", freq3dB)
	freq, resp = signal.freqz(coeffs, fs = f_sample)	
	xylog_plotter(freq, resp, 'Band Pass Golden ref FIR Filter logarithmic scale')
print("Filter analysed. OK")

print("golden ref coeffs:", coeffs)

if filter_type=='lp':
	filename_resp_lp = "o_30" + "_w1_" + str(int(f1)) + "_ws_" + str(int(f_sample)) + "_goldenref_resp.csv"
	save_resp(filename_resp_lp, freq, resp)
	filename_coeffs_lp = "o_30" + "_w1_" + str(int(f1)) + "_ws_" + str(int(f_sample)) + "_goldenref_coeffs.csv"
	save_coeffs(filename_coeffs_lp, coeffs)
elif filter_type=='bp':
	filename_resp_bp = "o_30" + "_w1_" + str(int(f1)) + "_w2_" + str(int(f2)) + "_ws_" + str(int(f_sample)) + "_goldenref_resp.csv"
	save_resp(filename_resp_bp, freq, resp)
	filename_coeffs_bp = "o_30" + "_w1_" + str(int(f1)) + "_w2_" + str(int(f2)) + "_ws_" + str(int(f_sample)) + "_goldenref_coeffs.csv"
	save_coeffs(filename_coeffs_bp, coeffs)