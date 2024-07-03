
    ; at 0 the segment is just off
    ; for 0001 middle bar flashes at 500 milliseconds
    ; for 0010 rotate two perimeter segments clockwise
    ; for 0011 rotate two perimeter segments counterclockwise
    ; fixed at .5 seconds
 
    ;SSEG connected to PORTA so that is our output
    ; DIP switches connected at PORTD
config OSC = INTIO2
config BOR = OFF
config STVREN = OFF
config WDT = OFF
config MCLRE = ON
#include <xc.inc>
;for first one
; 0x80 = g bar
    
    goto start
psect data
 
lookup: DB 0xE0, 0xB0, 0x98, 0x8C, 0x86, 0xC2 
 
  ;reliant on sseg being common anode
 
SSEG	    equ 0x20	    ;how i plan to iterate through above pattern
temp	    equ 0x31	    ; for neccesary holding values
I	    equ 0x40 
cCount	    equ 0x00
preCount    equ 0x01
ccCount	    equ 0x01
	    
psect code		    ;essentially a counter
start:	
    ;moving into sseg pattern memory to data mem
    ; may went to set a counter to 6 for a while loop
	movlw	low lookup
	movwf	TBLPTRL, f, a
	movlw	high lookup
	movwf	TBLPTRH, f, a
	movlw	low highword lookup
	movwf	TBLPTRU, f, a   
	
	
    	lfsr	0, SSEG ; starting address in data memory
	movlw	6
	movwf	I, f, a ; initialize counter with 6
loop:	TBLRD*+    ; read 1B from program memory and advance TBLPTR by 1
	movff	TABLAT, POSTINC0 ;copy TABLAT into INDF0 them move FSR0 pointer forward
	decf	I, f, a;
	bnz	loop
	
	
	;set I/O ports
	clrf	PORTA, a
	clrf	TRISA, a    ;sseg output
	
	clrf	PORTD, a    ;clear our input D
	movlw	0x03
	movwf	TRISD, a	    ;bits 0,1,2 our inputs via switches
  
	setf    ADCON1, a
    
	
infloop:
	
	movf	PORTD, w, a ;read dip switch state
	andlw	0x0f   ;this is my mask for lowest 4 bits
	bz	ledOff
	movf	PORTD, w, a
	sublw	00000001B
	bz	negativeLED
	movf	PORTD, w, a
	sublw	00000010
	bz	clockwise
	movf	PORTD, w, a
	sublw	00000011B
	bz	counterClock
	clrf	PORTA, a    ;reset our sseg everytime
	bra	infloop
	
	
ledOff:
    call	delay500ms
    clrf    PORTA, a
    bra	    infloop	
    
    
negativeLED:
    call	delay500ms
    ;i want to set only segment g to be on here
    btfss   PORTA, 6, a		;checks if our g segment is on
    bsf	    PORTA, 6, a		;turns it on if it is not
    btfsc   PORTA, 6, a	    ;bit test skip if clear
    bcf	    PORTA, 6, a	    ;clear it before looping back
    bra	    infloop
       
clockwise:
    
    lfsr    0, SSEG
    movlw   0x06
    movwf   cCount, a
    call    cloop
  
cloop:
    call    delay500ms
    tblrd*+ 
    movff   TABLAT, PORTA
    decf    cCount, f, a
    bnz	    cloop
    bz	    infloop
    
counterClock:
    call    delay500ms
    lfsr    0, SSEG
    movlw	6
    movwf	ccCount, f, a ; initialize counter with 6
    call toRight
    
toRight:
    call    delay500ms
    tblrd*+
    decf    preCount, f, a
    bnz	    Printing
printing:
    tblrd*-
    movff   TABLAT, PORTA
    decf    ccCount, f, a
    bnz	    printing
    bz	    infloop
    
    
    
   

    
    
delay2550us:			    ; 2550 us delay
	movlw	255
l1:	decf	WREG, w, a
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bnz	l1
	return 1
delay500ms:			    
	movlw	100		    
	movwf	0x10, a
l2:	call	delay2550us
	decf	0x10, f, a
	bnz	l2
	return 1
	
end
   

	