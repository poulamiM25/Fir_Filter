from custom_fp_to_dec import custom_fp_to_dec
from dec_to_custom_fp import dec_to_custom_fp


def fixed_point_quantizer(decimal_number, no_of_fractional_bits):
	left_shift = decimal_number*(2**no_of_fractional_bits)
	lower_quantize = int(left_shift)/(2**no_of_fractional_bits)
	return lower_quantize


# dec_element = -44.7483
# fixed_quant_val = fixed_point_quantizer(dec_element,8)
# print(fixed_quant_val)


def float_point_quantizer(decimal_number, no_of_bits, no_of_mantissa_bits):
	custom_fp_bin = dec_to_custom_fp(decimal_number, no_of_bits, no_of_mantissa_bits)
	converted_dec = custom_fp_to_dec(custom_fp_bin, no_of_bits, no_of_mantissa_bits)
	return converted_dec

# dec_element = 0.0034248508001325263
# float_quant_val = float_point_quantizer(dec_element,10,4)
# # print(float_quant_val)


# Function for converting decimal to binary
def float_bin(my_number, places = 8):
    my_whole, my_dec = str(format(my_number,'.20f')).split(".")
    # my_whole, my_dec = str(my_number).split(".")
    my_whole = int(my_whole)
    res = (str(bin(my_whole))+".").replace('0b','')
    for x in range(places):
        my_dec = str('0.')+str(my_dec)
        temp = '%1.20f' %(float(my_dec)*2)
        my_whole, my_dec = temp.split(".")
        res += my_whole
    return res

# dec_element = -0.74837896
# fixed_quant_val = float_bin(dec_element)
# print(fixed_quant_val)

def fixed_point_quantizer_bits(decimal_number, no_of_fractional_bits):
	dec_to_bin = float_bin(decimal_number, no_of_fractional_bits)
	dec_to_bin = dec_to_bin.replace(".","")
	sign = 0
	if decimal_number < 0 :
		sign = 1
	dec_to_bin = str(sign) + dec_to_bin
	return dec_to_bin


dec_element = -0.74837896
fixed_quant_val = fixed_point_quantizer_bits(dec_element,14) 
print(fixed_quant_val)
