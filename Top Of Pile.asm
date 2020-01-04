#     T o p  o f  P i l e
#
#
# This routine finds the color of the part on top of a pile.
#
# Name: Lifeng Jerry Tang
# Date: 9/28/2019

.data


Pile:  .alloc	1024 
overlapOrNot:   .word 0x00000001
                .word 0x00000000

.text

TopOfPile:	addi    $1, $0, Pile
		swi	545			# generate pile

                # your code goes here
    
                addi    $16, $0, 1              # add 1 to $16
                addi    $18, $0, 0              # init the number of times that we have expanded our check scope
                addi    $19, $0, 0              # init the flag counter
                addi    $5, $0, 1700            # init i = 1700            
Loop:           slti    $4, $5, 3700            # check if i < 3700, since the last few rows are usually mostly black
                beq     $4, $0, checkDone       # if i >= 3700, we have finished checking every pixel other than the first few and the few last lines
                slti    $7, $19, 6              # Have we at least flagged 6 different colors
                beq     $7, $0, finalCheck      # if we have, then we can go check our answer
                lb      $4, Pile($5)            # $4: the current color that we are on  
                beq     $4, $0, updateLoop      # if our current color is black, we are not going to check it.
                addi    $7, $5, 1               # $9: i + 1
                lb      $7, Pile($7)            # $7: Pile[i+1]: the next color from our current color
		beq     $4, $7, updateLoop      # if the current color we are at equals the next color, we are not going to check our current color;
		beq     $7, $0, else1           # if the next color is black, go check horizontally
                lbu     $7, overlapOrNot($4)    # $7 overlapOrNot[current color's value]
                bne     $7, $0, updateLoop2     # if the flag for our current color is 1, then we don't have to flag it
 		addi    $7, $5, 2               # $9: i + 2 the index after the next
                lb      $7, Pile($7)            # $7: Pile[i+2]: the color after the next color
		bne     $4, $7, updateLoop      # if our current color does not equal the color after next, go update the loop       
		sb      $16, overlapOrNot($4)   # store 1 to the flag that corresponds to our current color in the overlapOrNot array          
                addi    $19, $19, 1             # add 1 to $19
                j       updateLoop2             # go update the loop by a whole row

else1:          addi    $7, $5, 64              # $7: i + 64
                lb      $7, Pile($7)            # $7: Pile[i + 64]: the next color below our current color
		beq     $4, $7, updateLoop3     # if the current color we are at equals the color below, we are not going to check our current color; go update the loop
                beq     $7, $0, updateLoop2     # if the color below is black, go update the loop
                lbu     $7, overlapOrNot($4)    # $7 overlapOrNot[current color's value]
                bne     $7, $0, updateLoop      # if the flag for our current color is not 0, then we don't have to flag it
		addi    $7, $5, 128             # $9: i + 128
                lb      $7, Pile($7)            # $7: Pile[i + 128]: the 2nd color below our current color
		bne     $4,  $7, updateLoop3    # if our current color does not equal the 2nd color below , go update the loop
                sb      $16, overlapOrNot($4)   # store 1 to the flag that corresponds to our current color in the overlapOrNot array  
                addi    $19, $19, 1             # add 1 to $19 that keeps the flag counter

updateLoop3:    addi    $5, $5, 2               # add 2 to i
                j       Loop                    # jump to the beginning of our loop

updateLoop:    	addi    $7, $5, 1               # $9: i + 1
                lb      $7, Pile($7)            # $7: Pile[i+1]: the next color from our current color
                beq     $7, $0, updateLoop3     # if our next color is black, go to updateLoop3
		addi    $5, $5, 1               # add 1 to i
                j	Loop                    # jump to the beginning of the loop

updateLoop2:    addi    $5, $5,  20             # add 20 to i
                j       Loop                    # jump to the beginning of the loop

checkDone:      addi    $18, $18, 1             # add 1 to our check scope counter
                bne     $18, $16, finalCheck    # if our check scope is not 1, then stop checking
		slti    $7, $19, 6              # Have we at least flagged 6 different colors other than black
                beq     $7, $0, finalCheck      # if we have, then we can go check our answer
		addi    $5, $0, 400             # decrease our lower bound to increase our check scope
                j       Loop                    # rescan

finalCheck:	addi    $5, $0, 1               # init j = 1
finalLoop:      slti    $7, $5, 7               # if j >= 7
		beq     $5, $0, checkAnswer     # go store our answer
                lbu     $16, overlapOrNot($5)   # $16: overlapOrNot[j]
                beq     $16, $0, checkAnswer    # if overlapOrNot[j] = 0, we have found our color! Go check the answer.
                addi    $5, $5, 1               # j++
                j       finalLoop               # jump to the beginning of our check loop
				               
checkAnswer:    add     $2, $0, $5              # store our answer to register 2
		swi	546			# submit answer and check
		jr	$31			# return to caller
