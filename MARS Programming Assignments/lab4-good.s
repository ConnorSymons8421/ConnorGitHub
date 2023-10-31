#                                           CS 240, Lab #4
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                       DO NOT change anything outside the marked blocks.
# 
#
j main
###############################################################################
#                           Data Section
.data

# 
# Fill in your name, student ID in the designated sections.
# 
student_name: .asciiz "Connor Symons"
student_id: .asciiz "828475798"

new_line: .asciiz "\n"
space: .asciiz " "


t1_str: .asciiz "Testing GCD: \n"
t2_str: .asciiz "Testing LCM: \n"
t3_str: .asciiz "Testing RANDOM SUM: \n"

po_str: .asciiz "Obtained output: " 
eo_str: .asciiz "Expected output: "

#GCD_test_data_A:	.word 1, 2, 128, 148, 36, 360, 108, 75, 28300, 0
#GCD_test_data_B:	.word 12, 12, 96, 36, 54, 210, 144, 28300, 74000, 143

GCD_test_data_A:	.word 1, 36, 360, 108, 28300
GCD_test_data_B:	.word 12,54, 210, 144, 74000

GCD_output:           .word 1, 18, 30, 36, 100

#LCM_test_data_A:	.word 0, 1, 2, 128, 148, 36, 360, 108, 75, 28300
#LCM_test_data_B:	.word 143, 12, 12, 96, 36, 54, 210, 144, 28300, 74000
#LCM_output:           .word 0, 12, 12, 384, 1332, 108, 2520, 432, 84900, 20942000 


LCM_test_data_A:	.word 1, 36, 360, 108, 28300
LCM_test_data_B:	.word 12,54, 210, 144, 74000
LCM_output:           .word 12, 108, 2520, 432, 20942000

RANDOM_test_data_A:	.word 1, 144, 42, 260, 74000
RANDOM_test_data_B:	.word 12, 108,  54, 210, 44000
RANDOM_test_data_C:	.word 4, 109, 36, 360, 28300

RANDOM_output:           .word 26, 720, 216, 3120, 21044400

###############################################################################
#                           Text Section
.text
# Utility function to print an array
print_array:
li $t1, 0
move $t2, $a0
print:

lw $a0, ($t2)
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 4
addi $t1, $t1, 1
blt $t1, $a1, print
jr $ra
###############################################################################
###############################################################################
#                           PART 1 (GCD)
#a0: input number
#a1: input number

#v0: final gcd answer

.globl gcd
gcd:
############################### Part 1: your code begins here ################
bne $a1, $zero, recurse #continue if second argument passed to method is zero, else branch
move $v0, $a0 #set return value to first argument and return from subroutine
jr $ra
recurse:
addi $sp, $sp, -4 
sw $ra, 0($sp) #store return address in stack
move $t0, $a1
div $a0, $a1
mfhi $a1 #set second argument to remainder of the division of the original two arguments
move $a0, $t0 #set first argument to the original second argument
jal gcd
lw $ra, 0($sp) #pop return address from stack
addi $sp, $sp, 4 
jr $ra
############################### Part 1: your code ends here  ##################
jr $ra
###############################################################################
###############################################################################
#                           PART 2 (LCM)

# Find the least common multiplier of two numbers given
# Make a call to the GCD function to compute the LCM
# LCM = a1*a2 / GCD

# Preserve all required values in stack before calls to another function.
# preserve the $ra register value in stack before making the call!!!

#a0: input number
#a1: input number
#v0: final gcd answer

.globl lcm
lcm:
############################### Part 2: your code begins here ################
mult $a0, $a1
mflo $t0 #a1*a2
addi $sp, $sp, -4 
sw $t0, 0($sp)
addi $sp, $sp, -4 
sw $ra, 0($sp) #store return address and product in stack
jal gcd #call gcd function
lw $ra, 0($sp)
addi $sp, $sp, 4 
lw $t0, 0($sp) #pop return address and product from stack
addi $sp, $sp, 4 
div $t0, $v0
mflo $v0 #set return value to quotient and return from subroutine
jr $ra
############################### Part 2: your code ends here  ##################
jr $ra
###############################################################################
#                           PART 3 (Random SUM)

# You are given three integers. You need to find the smallest 
# one and the largest one.
# 
# Then find the GCD and LCM of the two numbers. 
#
# Return the sum of Smallest, largest, GCD and LCM
#
# Implementation details:
# The three integers are stored in registers $a0, $a1, and $a2.
# Store the answer into register $v0. 
# Preserve all required values in stack before calls to another function.
# preserve the $ra register value in stack before making the call!!!
# Use stacks to store the smallest and largest values before making the function call. 

.globl random_sum
random_sum:
############################### Part 3: your code begins here ################
ble $a0, $a1 B1
ble $a0, $a2 C1 #if both statements are false, a0 holds largest value
move $t0, $a0
j after_1
B1: #a1 >= a0
ble $a1, $a2 C1 #if false, a1 holds largest value
move $t0, $a1
j after_1
C1: #a2 is largest
move $t0, $a2
j after_1


after_1: #after largest has been set to $t0
bge $a0, $a1 B2
bge $a0, $a2 C2 #if both statements are false, a0 holds smallest value
move $t1, $a0
j after_2
B2: #a1 <= a0
bge $a1, $a2 C2 #if false, a1 holds smallest value
move $t1, $a1
j after_2
C2: #a2 is smallest
move $t1, $a2
j after_2


after_2: #after smallest has been set to $t1
addi $sp, $sp, -4 
sw $t0, 0($sp)
addi $sp, $sp, -4 
sw $t1, 0($sp)
addi $sp, $sp, -4 
sw $ra, 0($sp) #store return address and numbers in stack
move $a0, $t0
move $a1, $t1
jal gcd #call gcd function with the two numbers
lw $a0, 8($sp)
lw $a1, 4($sp) #peek the stack and load arguments with the two numbers again
addi $sp, $sp, -4 
sw $v0, 0($sp) #store return value in stack
jal lcm #call lcm function with the two numbers
lw $t2, 0($sp) 
addi $sp, $sp, 4 
lw $ra, 0($sp)
addi $sp, $sp, 4 
lw $t1, 0($sp)
addi $sp, $sp, 4 
lw $t0, 0($sp) #pop return address and numbers from stack
addi $sp, $sp, 4 

#add four values together and store them in $v0
add $t2, $t2, $v0
add $t0, $t1, $t0
add $v0, $t0, $t2
jr $ra
############################### Part 3: your code ends here  ##################
jr $ra
###############################################################################

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
###############################################################################
#                          TESTING PART 1 - GCD
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t1_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, GCD_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0
la $s2, GCD_test_data_A
la $s3, GCD_test_data_B
#j skip_line
##############################################
test_gcd:
#li $v0, 4
#la $a0, new_line
#syscall
#skip_line:
add $s4, $s2, $s1
add $s5, $s3, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 0($s5)
jal gcd

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_gcd

###############################################################################

#                          TESTING PART 2 - LCM
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t2_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, LCM_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0
la $s2, LCM_test_data_A
la $s3, LCM_test_data_B
#j skip_line
##############################################
test_lcm:
#li $v0, 4
#la $a0, new_line
#syscall
#skip_line:
add $s4, $s2, $s1
add $s5, $s3, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 0($s5)
jal lcm

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_lcm

###############################################################################
#                          TESTING PART 3 - RANDOM SUM
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t3_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, RANDOM_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0
la $s2, RANDOM_test_data_A
la $s3, RANDOM_test_data_B
la $s4, RANDOM_test_data_C
#j skip_line
##############################################
test_random:
#li $v0, 4
#la $a0, new_line
#syscall
#skip_line:
add $s5, $s2, $s1
add $s6, $s3, $s1
add $s7, $s4, $s1
# Pass input parameter
lw $a0, 0($s5)
lw $a1, 0($s6)
lw $a2, 0($s7)
jal random_sum

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_random

###############################################################################

_end:

# new line
li $v0, 4
la $a0, new_line
syscall

# end program
li $v0, 10
syscall
###############################################################################
