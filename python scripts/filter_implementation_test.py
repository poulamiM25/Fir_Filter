#take sine wave input, quantise it to 10/16 bits in fixed point and 10 bit floating point
from quantiser import fixed_point_quantizer, float_point_quantizer
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

def filter_implementation(band,quantise_case):
    # construct sine wave
        if band == "band1": # 0 to 4 Hz
            sample_rate = 20
            f1 = 2
            f2 = 2.5
            f3 = 7
        elif band == "band2": # 4 to 8 Hz
            sample_rate = 20
            f1 = 5.5
            f2 = 6.5
            f3 = 2
        elif band == "band3": # 8 to 13 Hz
            sample_rate = 40
            f1 = 10
            f2 = 12
            f3 = 17
        elif band == "band4": # 13 to 30 Hz
            sample_rate = 80
            f1 = 6
            f2 = 15
            f3 = 20

        start_time = 0
        end_time = 100
        time = np.arange(start_time, end_time, 1/(sample_rate))
        amplitude = 1
        # sinewave =  amplitude * np.sin(2 * np.pi * f1 * time) #+ amplitude * np.sin(2 * np.pi * f2 * time) + amplitude * np.sin(2 * np.pi * f3 * time)
        sinewave = []
        for i in range(len(time)):
            temp = (1 if time[i]>0 else 0)
            sinewave.append(temp)
        # plot sine wave
        plt.plot(time, sinewave)
        plt.title('Sine wave')
        plt.xlabel('Time')
        plt.ylabel('Amplitude')
        plt.grid(True, which='both')
        plt.axhline(y=0, color='k')
        plt.show()

        # fft of sine wave
        window = np.hanning(len(time))
        fft_arr = np.fft.rfft(sinewave*window)
        freq = np.fft.rfftfreq(len(sinewave), d=1.0/sample_rate)
        # plot FFT 
        fft_norm_db = 20*np.log10(np.abs(fft_arr)/np.abs(fft_arr).max())
        # plt.plot(freq, fft_norm_db)
        plt.title('FFT plot of sine wave')
        plt.grid()
        plt.xlabel('Freq(Hz)')
        plt.ylabel('Amplitude(dB)')
        # plt.show()


        # quantise_case = fxpt10_1/fxpt10_2/fxpt16_1/fxpt16_2/flpt/goldenref
        ################################################
        # Fixed point 10 bit - 
        # case 1 - Multiplier - 10 bit inputs, 20 bit output
        #          Adder      - 20 bit inputs, 20 bit output (drop one bit using quantiser)
        # case 2 - Multiplier - 10 bit inputs, 10 bit output (quantise 20 bit to 10 bit)
        #          Adder      - 10 bit inputs, 10 bit output (drop one bit using quantiser) 
        # Fixed point 16 bit - 
        # case 1 - Multiplier - 16 bit inputs, 32 bit output
        #          Adder      - 32 bit inputs, 32 bit output (drop one bit using quantiser)
        # case 2 - Multiplier - 16 bit inputs, 16 bit output (quantise 32 bit to 16 bit)
        #          Adder      - 16 bit inputs, 16 bit output (drop one bit using quantiser) 
        # Floating point - 
        # Multiplier - 10 bit and Adder - 10 bit
        ################################################
        if quantise_case == "fxpt10_1":
            sin_no_of_frac_bits = 8
            mult_no_of_frac_bits = 18
            add_no_of_frac_bits = 18
        elif quantise_case =="fxpt10_2":
            sin_no_of_frac_bits = 8
            mult_no_of_frac_bits = 8
            add_no_of_frac_bits = 8
        elif quantise_case =="fxpt16_1":
            sin_no_of_frac_bits = 14
            mult_no_of_frac_bits = 30
            add_no_of_frac_bits = 30
        elif quantise_case =="fxpt16_2":
            sin_no_of_frac_bits = 14
            mult_no_of_frac_bits = 14
            add_no_of_frac_bits = 14
        elif quantise_case =="flpt":
            print("float")
        elif quantise_case =="goldenref":
            print("goldenref")

        ################################################

        ######### quantise the sine wave #########
        for i, val in enumerate(sinewave):
            if quantise_case in ["fxpt10_1", "fxpt10_2", "fxpt16_1", "fxpt16_2" ] :
                sinewave[i] = fixed_point_quantizer(val, sin_no_of_frac_bits)
            elif quantise_case in ["flpt"]:
                sinewave[i] = float_point_quantizer(val, 10, 4)
        ######### reading quantised coeffs csv file #########
        if quantise_case in ["fxpt10_1", "fxpt10_2"]:
            
            if band == "band1":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band1_delta\o_30_w1_4_ws_20_10bitfxpt_coeffs.csv')
            elif band == "band2":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band2_theta\o_30_w1_4_w2_8_ws_20_10bitfxpt_coeffs.csv')
            elif band == "band3":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band3_alpha\o_30_w1_8_w2_13_ws_40_10bitfxpt_coeffs.csv')
            elif band == "band4":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band4_beta\o_30_w1_13_w2_30_ws_80_10bitfxpt_coeffs.csv')

        elif quantise_case in ["fxpt16_1", "fxpt16_2"]:

            if band == "band1":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band1_delta\o_30_w1_4_ws_20_16bitfxpt_coeffs.csv')
            elif band == "band2":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band2_theta\o_30_w1_4_w2_8_ws_20_16bitfxpt_coeffs.csv')
            elif band == "band3":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band3_alpha\o_30_w1_8_w2_13_ws_40_16bitfxpt_coeffs.csv')
            elif band == "band4":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band4_beta\o_30_w1_13_w2_30_ws_80_16bitfxpt_coeffs.csv')

        elif quantise_case in ["flpt"]:

            if band == "band1":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band1_delta\o_30_w1_4_ws_20_10bitflpt_coeffs.csv')
            elif band == "band2":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band2_theta\o_30_w1_4_w2_8_ws_20_10bitflpt_coeffs.csv')
            elif band == "band3":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band3_alpha\o_30_w1_8_w2_13_ws_40_10bitflpt_coeffs.csv')
            elif band == "band4":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band4_beta\o_30_w1_13_w2_30_ws_80_10bitflpt_coeffs.csv')

        elif quantise_case in ["goldenref"]:

            if band == "band1":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band1_delta\o_30_w1_4_ws_20_goldenref_coeffs.csv')
            elif band == "band2":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band2_theta\o_30_w1_4_w2_8_ws_20_goldenref_coeffs.csv')
            elif band == "band3":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band3_alpha\o_30_w1_8_w2_13_ws_40_goldenref_coeffs.csv')
            elif band == "band4":
                csvFile = pd.read_csv('D:\SEM 4\RnD\data_new_bands\\band4_beta\o_30_w1_13_w2_30_ws_80_goldenref_coeffs.csv')

        coeff_list = csvFile['coeffs'].tolist()
        # print(coeff_list)
        #########


        ######### pass the sine wave through FIR filter

        ####change this
        # inp_x = [1.345,2,3] #from some function
        # coeff_arr = [0,1,2,3,4,5] # order 30
        inp_x = sinewave#.tolist()
        coeff_arr = coeff_list

        loop_len = len(coeff_arr) + len(inp_x) - 1
        x_mult_arr = [0]*30
        result_arr = []

        for i in range(loop_len):
            if i < len(inp_x):
                next_element = inp_x[i]
            else:
                next_element = 0
            x_mult_arr = [next_element] + x_mult_arr[:-1]
            y_n = 0
            for j in range(len(coeff_arr)):
                # multiplier
                mult_x_coeff = x_mult_arr[j] * coeff_arr[j]
                if quantise_case in ["fxpt10_1", "fxpt10_2", "fxpt16_1", "fxpt16_2" ] :
                    mult_x_coeff = fixed_point_quantizer(mult_x_coeff, mult_no_of_frac_bits)
                elif quantise_case in ["flpt"]:
                    mult_x_coeff = float_point_quantizer(mult_x_coeff, 10, 4)
                # adder
                add_out = y_n + mult_x_coeff
                if quantise_case in ["fxpt10_1", "fxpt10_2", "fxpt16_1", "fxpt16_2" ] :
                    y_n = fixed_point_quantizer(add_out, add_no_of_frac_bits)
                elif quantise_case in ["flpt"]:
                    y_n = float_point_quantizer(add_out, 10, 4)
                elif quantise_case in ["goldenref"]:
                    y_n = add_out
            result_arr.append(y_n)

        # print(result_arr)

        # plot result_arr
        # x_result_arr = np.arange(len(result_arr))
        x_result_arr = np.arange(start_time, 101.45, 1/(sample_rate))
        plt.rcParams.update({'font.size':25})
        plt.plot(x_result_arr, result_arr)
        plt.title('Filter output')
        plt.grid(True)
        plt.xlabel('Time(s)')
        plt.ylabel('Amplitude')
        plt.show()

        # find fft of result
        window = np.hanning(len(result_arr))
        fft_result_arr = np.fft.rfft(result_arr*window)
        freq = np.fft.rfftfreq(len(result_arr), d=1.0/sample_rate)
        # plot FFT
        fft_norm_db = 20*np.log10(np.abs(fft_result_arr)/np.abs(fft_result_arr).max())
        # plt.plot(freq, fft_norm_db)
        plt.title('FFT plot of result')
        plt.grid()
        plt.xlabel('Freq(Hz)')
        plt.ylabel('Amplitude(dB)')
        # plt.show()

        # def save_td_filter_out(filename,time_x,ampl_y):
        #     df = pd.DataFrame({"time" : time_x, "ampl" : ampl_y})
        #     df.to_csv(filename, index=False)

        def save_fft(filename,freq,fft):
            df = pd.DataFrame({"freq" : freq, "fft" : fft})
            df.to_csv(filename, index=False)
            
        filename_q = quantise_case + "_" + band + ".csv"
        save_fft(filename_q,freq, fft_norm_db )


# band_array = ["band1","band2","band3","band4"]
band_array = ["band1"]
# quantise_array = ["fxpt10_1","fxpt10_2","fxpt16_1","fxpt16_2","flpt","goldenref"]
quantise_array = ["goldenref"]
for band in band_array: 
    for quantise_case in quantise_array:
        filter_implementation(band,quantise_case)


# band = "band1"
# quantise_case = "fxpt10_1"
# filter_implementation(band,quantise_case)