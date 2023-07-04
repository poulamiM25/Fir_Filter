def custom_fp_to_dec(bin_num, no_of_bits, no_of_mantissa_bits):
    # print(bin_num)
    no_of_exponent_bits = no_of_bits - no_of_mantissa_bits -1 # 1 sign bit
    # print("no_of_bits:",no_of_bits )
    # print("no_of_exponent_bits:",no_of_exponent_bits )
    # print("no_of_mantissa_bits:",no_of_mantissa_bits )
    sign = bin_num[0]
    exponent_bits = bin_num[1:no_of_exponent_bits+1]
    mantissa_bits = bin_num[(no_of_exponent_bits+1):]
    # print("sign:",sign)
    # print("exponent_bits:",exponent_bits )
    # print("mantissa_bits:",mantissa_bits )
    bias = 2**(no_of_exponent_bits-1)-1
    # print("bias:",bias)
    #check for normalised and denormalised
    if int(exponent_bits) == 0 and int(mantissa_bits) == 0:
        dec_num = 0
    else:
        if int(exponent_bits) == 0 and int(mantissa_bits) != 0: #denormalised
            # print("check")
            bin_fp_num = "0." + mantissa_bits
            dec_num = 0
            dec_exp = - bias + 1
        else: #normalised
            bin_fp_num = "1." + mantissa_bits
            dec_num = 1
            dec_exp = int(exponent_bits,2) - bias
        
        
        # print("dec_exp:",dec_exp)
        # print("bin_fp_num:",bin_fp_num)
        int_part, frac_part = str(bin_fp_num).split(".")
        # print(int_part, frac_part)
        
        for index,bit in enumerate(frac_part):
            if int(bit)==1:
                dec_num = dec_num + 2**((index+1)*-1)
        # print(dec_exp)
        dec_num  = dec_num * 2**(dec_exp)
        if sign=="1":
            dec_num = dec_num*-1 
    return dec_num


    




bin1 = "1001001010"
n = 10
m = 4
# print(custom_fp_to_dec(bin1, n, m))