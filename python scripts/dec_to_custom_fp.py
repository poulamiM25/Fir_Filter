# Function for converting decimal to binary
def float_bin(my_number, places = 3):
    my_whole, my_dec = str(format(my_number,'.15f')).split(".")
    # my_whole, my_dec = str(my_number).split(".")
    my_whole = int(my_whole)
    res = (str(bin(my_whole))+".").replace('0b','')
    for x in range(places):
        my_dec = str('0.')+str(my_dec)
        temp = '%1.20f' %(float(my_dec)*2)
        my_whole, my_dec = temp.split(".")
        res += my_whole
    return res

def dec_to_custom_fp(dec_num, no_of_bits, no_of_mantissa_bits):
    # print(dec_num)
    no_of_exponent_bits = no_of_bits - no_of_mantissa_bits -1   # 1 sign bit
    # print("no_of_bits:",no_of_bits )
    # print("no_of_exponent_bits:",no_of_exponent_bits )
    # print("no_of_mantissa_bits:",no_of_mantissa_bits )
    
    # max_exp = 2**no_of_exponent_bits-2-bias
    bias = 2**(no_of_exponent_bits-1)-1 #bias =15 for exp bit = 5 mantissa bit = 4 
    min_exp = 1 - bias
    max_possible = (2-(2**(-1*no_of_mantissa_bits))) * (2**bias)
    # min_possible = (1+(2**(-1*no_of_mantissa_bits))) * (2**min_exp)
    min_possible = ((2**(-1*no_of_mantissa_bits))) * (2**min_exp)
    # print("min_possible:", min_possible)
    # print("max_possible:", max_possible)
    # identifying whether the number is positive or negative    
    sign = 0
    if dec_num < 0 :
        sign = 1
        dec_num = dec_num * (-1)
    # convert float to binary
    p = 20
    dec_to_bin = float_bin (dec_num, places = p) #edit places to fit custom FP number of bits
    # print("dec_to_bin:",dec_to_bin)
    
    dotPlace = dec_to_bin.find('.')
    onePlace = dec_to_bin.find('1')
    # print("dotPlace: ",dotPlace)
    # print("onePlace: ",onePlace) #oneplace will be either 0 for int.something or >=2 for 0.something
    dec_to_bin = dec_to_bin.replace(".","")
    # print(dec_to_bin)
    dotPlace -= 1
    if onePlace > dotPlace: #this will happen when number is like 0.0001101010101 i.e. 0.something
        onePlace -= 1        
        # print(onePlace)
    # calculate the exponent(E)
    exponent = dotPlace - onePlace
    bias = 2**(no_of_exponent_bits-1)-1
    # print("bias:",bias)
    exponent_dec = exponent + bias
    # print("dec exp:", exponent_dec)
    # if exponent_dec == 0:
    #     #find denormalised mantissa
    #     mantissa = dec_to_bin[onePlace:]
    #     mantissa = mantissa[0:no_of_mantissa_bits]
    #     # mantissa = str("1") + mantissa
    #     print("denormalised mantissa:",mantissa)
    # else:
    #     #find normalised mantissa
    #     mantissa = dec_to_bin[onePlace+1:]
    #     mantissa = mantissa[0:no_of_mantissa_bits]
    #     print("normalised mantissa:",mantissa)

    if exponent_dec > 0:
        #find normalised mantissa
        mantissa = dec_to_bin[onePlace+1:]
        mantissa = mantissa[0:no_of_mantissa_bits]
        # print("normalised mantissa:",mantissa)
        # converting the exponent from decimal to binary
        exponent_bits = bin(exponent_dec).replace("0b",'')
        exponent_bits = exponent_bits.zfill(no_of_exponent_bits)
        # print("exponent:",exponent_bits)
    else:
        #find denormalised mantissa
        # print("onePlace:",onePlace)
        # print("dotPlace:", dotPlace)
        # denormal_exp = 1 - bias
        mantissa = dec_to_bin[bias:]
        mantissa = mantissa[0:no_of_mantissa_bits]
        # print("denormalised mantissa:",mantissa)
        exponent_bits = '0' * no_of_exponent_bits

    
    
    # the FP notation in binary	
    if int(dec_to_bin)==0 or dec_num==0 or (exponent_dec==0 and int(mantissa)==0):
        final = "0000000000"
    else:
        final = str(sign) + exponent_bits + mantissa
    return (final)




# decimal = 0.0054114353
# decimal = 0.75 #correct
# decimal = 0.000049591064453125
# decimal = 0.000049591064453125
# decimal = 0.00002288818359375
# decimal = 0.000049591064453125
# decimal = 0.00002288818359375
# 0.0000 0000 0000 0000 1001
# decimal = 0.000019073486328125
# decimal = 0.00000905990600585938
decimal = 0.00127170288
n = 10
m = 4
# print(dec_to_custom_fp(decimal, n, m))


#works correctly for IEEE754 32 bit single precision
# decimal = -23.543745
# n = 32
# m = 23
# print(dec_to_custom_fp(decimal, n, m))
# 3.5498765e-18
# 0.0000 0000 0000 0001 1000