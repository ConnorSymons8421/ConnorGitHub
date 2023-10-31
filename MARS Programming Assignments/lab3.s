jal main
#                                           CS 240, Lab #3
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                     	DO NOT change anything outside the marked blocks.
# 
#               Remember to fill in your name, student ID in the designated sections.
# 
#
j main
###############################################################
#                           Data Section
.data
# 
# Fill in your name, student ID in the designated sections.
# 
student_name: .asciiz "Connor Symons"
student_id: .asciiz "828475798"

new_line: .asciiz "\n"
space: .asciiz " "
testing_label: .asciiz ""
unsigned_addition_label: .asciiz "Unsigned Addition (Hexadecimal Values)\nExpected Output:\n0154B8FB06E97360 BAC4BABA1BBBFDB9 00AA8FAD921FE305 \nObtained Output:\n"
fibonacci_label: .asciiz "Fibonacci\nExpected Output:\n0 1 5 55 6765 3524578 \nObtained Output:\n"
file_label: .asciiz "File I/O\nObtained Output:\n"

addition_test_data_A:	.word 0xeee94560, 0x0154a8d0, 0x09876543, 0x000ABABA, 0xFEABBAEF, 0x00a9b8c7
addition_test_data_B:	.word 0x18002e00, 0x0000102a, 0x12349876, 0xBABA0000, 0x93742816, 0x0000d6e5

fibonacci_test_data:	.word  0, 1, 2, 3, 5, 6, 

bcd_2_bin_lbl: .asciiz "\nBCD to Binary (Hexadecimal Values)\nExpected output:\n004CC853 00BC614E 00008AE0\nObtained output:\n"
bin_2_bcd_lbl: .asciiz "\nBinary to BCD (Hexadecimal Values) \nExpected output:\n05032019 06636321 00065535\nObtained output:\n"


bcd_2_bin_test_data: .word 0x05032019, 0x12345678, 0x35552

bin_2_bcd_test_data: .word 0x4CC853, 0x654321, 0xFFFF


hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

file_name:
	.asciiz	"lab3_data.dat"	# File name
	.word	0
read_buffer:
	.space	300			# Place to store character
###############################################################
#                           Text Section
.text
# Utility function to print hexadecimal numbers
print_hex:
move $t0, $a0
li $t1, 8 # digits
lui $t2, 0xf000 # mask
mask_and_print:
# print last hex digit
and $t4, $t0, $t2 
srl $t4, $t4, 28
la    $t3, hex_digits  
add   $t3, $t3, $t4 
lb    $a0, 0($t3)            
li    $v0, 11                
syscall 
# shift 4 times
sll $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, mask_and_print
addi $f0, $zero, 5
exit:
jr $ra
###############################################################
###############################################################
###############################################################
#                           PART 1 (Unsigned Addition)
# You are given two 64-bit numbers A,B located in 4 registers
# $t0 and $t1 for lower and upper 32-bits of A and $t2 and $t3
# for lower and upper 32-bits of B, You need to store the result
# of the unsigned addition in $t4 and $t5 for lower and upper 32-bits.
#
.globl Unsigned_Add_64bit
Unsigned_Add_64bit:
move $t0, $a0
move $t1, $a1
move $t2, $a2
move $t3, $a3
############################## Part 1: your code begins here ###
addu $t4, $t0, $t2 #store unsigned addition of lower words in $t4
addu $t5, $t1, $t3 #store unsigned addition of upper words in $t5
blt $t4, $t0, Overflow #branch if overflow caused $t4 to be less than $t0
bge $t4, $t2, Finish #branch if $t4 is greater than or equal to $t2, if not then overflow occurred
Overflow:
addi $t5, $t5, 1 #add 1 if overflow occurred in lower word addition
Finish:

############################## Part 1: your code ends here   ###
move $v0, $t4
move $v1, $t5
jr $ra
###############################################################
###############################################################
###############################################################
#                            PART 2 (BCD to Binary)
# 
# You are given a 32-bits integer stored in $t0. This 32-bits
# present a BCD number. You need to convert it to a binary number.
# For example: 0x7654_3210 should return 0x48FF4EA.
# The result must be stored inside $t0 as well.
.globl bcd2bin
bcd2bin:
move $t0, $a0
############################ Part 2: your code begins here ###
addi $t9, $zero, 10 #store 10 to multiply later
addi $t2, $zero, 0 #ensure $t2 is empty
Loop:
andi $t1, $t0, 0xF0000000 #Create mask to extract leading byte
srl $t1, $t1, 28 #shift right to get decimal value of leading byte
mult $t2, $t9 #increase all previous decimal values significance by 1 decimal place (mult by 10)
mflo $t2
add $t2, $t2, $t1 #updated current solution
sll $t0, $t0, 4 #clear leading byte
bne $t0, $zero, Loop #loop if there is still some value in original number
move $t0, $t2 #move answer to $t0


############################ Part 2: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                            PART 3 (Binary to BCD)
# 
# You are given a 32-bits integer stored in $t0. This 32-bits
# present an integer number. You need to convert it to a BCD.
# The result must be stored inside $t0 as well.
.globl bin2bcd
bin2bcd:
move $t0, $a0
############################ Part 3: your code begins here ###
addi $t9, $zero, 10 #store 10 to divide later
addi $t3, $zero, 0 #ensure $t3 is zero
Repeat:
div $t0, $t9 #divide by 10 to extract least significant decimal value as remainder
mfhi $t2
mflo $t0 #retain dividend for future extractions
sllv $t2, $t2, $t3 #increase significance of extracted BCD byte
add $t1, $t1, $t2 #updated BDC answer
addi $t3, $t3, 4
bne $t0, $zero, Repeat #branch if still some value in original decimal number
move $t0, $t1 #move answer to $t0

############################ Part 3: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
###############################################################
###############################################################


###############################################################
###############################################################
###############################################################
#                           PART 4 (ReadFile)
#
# You will read characters (bytes) from a file (lab3_data.dat) 
# and print them. 
#Valid characters are defined to be
# alphanumeric characters (a-z, A-Z, 0-9),
# " " (space),
# "." (period),
# (new line).
#
# 
# Hint: Remember the ascii table. 
#
.globl file_read
file_read:
############################### Part 4: your code begins here ##
#open input file
addi $v0, $zero, 13 #system call for open file
la $a0, file_name #load first argument with file name
addi $a1, $zero, 0 #open file for reading
addi $a2, $zero, 0
syscall
move $t6, $v0 #save file descriptor 

#read from file
addi $v0, $zero, 14 #system call for read from file
add $a0, $zero, $t6  #file descriptor 
la $a1, read_buffer #address of buffer to which to read
addi $a2, $zero, 300 
syscall


#the below section loops through every character (byte) in the string and checks if it is valid
la $t2, read_buffer #obtain beginning address
addi $v0, $zero, 11 #system call for character print
lb $a0, 0($t2) #load first character into first argument
char_loop:
#check validity of character
beq $a0, 10, sys #syscall immediately if newline, space, or period
beq $a0, 32, sys
beq $a0, 46, sys

blt $a0, 48, return #if not one of the chars above and value is less than '0', then invalid char
ble $a0, 57, sys #in between 48-57 inclusive is a number, valid

blt $a0, 65, return #if not one of the chars above and value is less than 'A', then invalid char
ble $a0, 90, sys #in between 65-90 inclusive is a capital letter, valid

blt $a0, 97, return #if not one of the chars above and value is less than 'a', then invalid char
ble $a0, 122, sys #in between 97-122 inclusive is a lowercase letter, valid

j return #if all conditions fail, char is invalid
sys:
syscall
return: #continue to loop after evaluating validity
addi $t2, $t2, 1 #obtain address of next byte
lb $a0, 0($t2) #store byte in first argument
bnez $a0, char_loop #loop if byte is not zero (null)

# Close the file 
addi $v0, $zero, 16 #system call for close file
move $a0, $t6 
syscall
############################### Part 4: your code ends here   ##
jr $ra
###############################################################
###############################################################
###############################################################

#                          Main Function
main:

li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall  
la $a0, student_id
syscall 
la $a0, new_line
syscall
la $a0, new_line
syscall
##############################################
##############################################
test_64bit_Add_Unsigned:
li $s0, 3
li $s1, 0
la $s2, addition_test_data_A
la $s3, addition_test_data_B
li $v0, 4
la $a0, testing_label
syscall
la $a0, unsigned_addition_label
syscall
##############################################
test_add:
add $s4, $s2, $s1
add $s5, $s3, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 4($s4)
lw $a2, 0($s5)
lw $a3, 4($s5)
jal Unsigned_Add_64bit

move $s6, $v0
move $a0, $v1
jal print_hex
move $a0, $s6
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 8
addi $s0, $s0, -1
bgtz $s0, test_add

li $v0, 4
la $a0, new_line
syscall
##############################################
##############################################
li $v0, 4
la $a0, new_line
syscall
la $a0, bcd_2_bin_lbl
syscall
# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, bcd_2_bin_test_data

test_p2:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal bcd2bin

move $a0, $v0        # hex to print
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p2

##############################################
##############################################
li $v0, 4
la $a0, new_line
syscall
la $a0, bin_2_bcd_lbl
syscall

# Testing part 3
li $s0, 3 # num of test cases
li $s1, 0
la $s2, bin_2_bcd_test_data

test_p3:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal bin2bcd

move $a0, $v0        # hex to print
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p3
##############################################
##############################################
li $v0, 4
la $a0, new_line
syscall
test_file_read:
li $v0, 4
la $a0, new_line
syscall
li $s0, 0
li $v0, 4
la $a0, testing_label
syscall
la $a0, file_label
syscall 
jal file_read
end:
# end program
li $v0, 10
syscall
