bits 16
org 0x7C00

	cli
	;WRITE YOUR CODE HERE
    xor ebx,ebx
	xor edi,edi
	xor eax,eax
	xor esp,esp
    xor esi,esi ; counter for  coloumns 
	xor ecx,ecx ;counter for words enter use to track cursor 
	xor edx,edx ; counter for array 	
	mov edi, 0xB8000 
	;mov bl,byte[edi]
	push ebx 
	mov ebp,esp
		
	lop:
	
	cmp edx,2080
	je reset
	
	mov ah,0x10
	int 0x16
    
	;cmp edi,0xb8000
	;jl continue
	push eax
	push edi
	push esi
	push ecx
	push edx
	cmp ah,0x4d
    je jump
	cmp ah,0x4b
	je jump
	cmp ah,0x0e 
    je jump
    cmp ah,0x48
    je jump
    
    cmp al,0x01
	je jump
	
	 cmp al,0x16
	je jump
	
	 cmp al,0x18
	je lop
	
	cmp al,0x03
	je lop
	
    cmp ah,0x50
    je downarrow
 
    cmp ah,0x47
    je home 
	  cmp ah,0x1C
    je Ent
	jmp continue
	
	jump:
	mov ah,0x02
	mov al,8
	mov dl,0x80
	mov ch,0
	mov dh,0
	mov cl,2
	mov bx,stage2
	int 0x13
	jmp stage2 
	
    continue :
	pop edx 
	pop ecx 
	pop esi 
	pop edi 
	pop eax 
	mov [edi],al
	lea ebx,[sav+edx*2]
    mov byte[ebx],al
	inc edi 
	inc edi
	mov al,[edi]
	cmp al,0
	dec edi
	dec edi
	inc ecx
	inc edi
	inc edi
	inc edx 
	inc esi 
	cmp esi,80
	jg reset2
	call cursor  
	jmp lop 
	
	cursor:
	;cursor movement
	push edx
	mov al,0x0f
	mov dx,0x03d4
	out dx,al
	;cursor index
	mov al,cl
	mov dx,0x03d5
	out dx,al
	mov al,0x0e
	mov dx,0x03d4
	out dx,al
	;shift by 256
	mov al,ch 
	mov dx,0x03d5 
	out dx,al 
	pop edx
	ret 

	reset2:
    xor esi,esi
    jmp lop

bksp:
    cmp edi,0xb8000
	jle lop
	inc edx 
	lea ebx,[sav+edx*2]
	mov al,byte[ebx]
	cmp al,0
	je DeletFromEnd 
	loo1:
	dec edx 
	push edx
	dec esi 
    dec ecx
	dec edi
	dec edi
	push edi
    lop1:	
    lea ebx,[sav+edx*2]
	mov al,byte[ebx]
	mov [edi],al
    sub ebx,2
    mov byte[ebx],al	
	inc edi 
	inc edi 
	inc edx 
	mov al,byte[ebx]
	cmp al,0
	jne lop1 
	mov [edi],al 
	pop edi 
	pop edx 
	dec edx 
	jmp continue2
	
	DeletFromEnd:
	dec edx 
	lea ebx,[sav+edx*2]
	cmp byte[ebx],0
	jne loo
	mov al,0
	mov byte[ebx],al
	dec edx
	dec esi 
    dec ecx
	dec edi
	dec edi
	mov [edi],al
	sub ebx,2
    mov byte[ebx],al
	continue2:
	call cursor
    jmp lop
	home :
    xor ecx ,ecx
    mov edi,0xB8000
    xor esi,esi	
	xor edx,edx
	call cursor
    jmp lop
	
    loo:
	inc edx
	lea ebx,[sav+edx*2]
	jmp loo1
	
Ent:
    add ecx,80
	mov eax,esi 
	sub ecx,eax 
	add edx,80
	sub edx,eax
	add eax,eax 
	add edi,160
	sub edi,eax 
	xor esi,esi
	call cursor
	jmp lop

downarrow:
    add edi,160
	add edx,80
	add ecx,80
	call cursor
    jmp lop 
times ((0x200-2) - ($ - $$)) db 0
dw 0xAA55
stage2:
pop edx
pop ecx
pop esi
pop edi
pop eax


    cmp ah,0x4d
    je rightarrow

	cmp ah,0x4b
	je leftarrow
	
	cmp ah,0x0e 
    je bksp
	
    cmp ah,0x48
    je uparrow
    
    cmp al,0x01
	je selectAll
	
    cmp al,0x16
	call paste
	jmp lop 
	
    cmp ah,0x50
    je downarrow
  
    cmp ah,0x47
    je home 
	
    cmp ah,0x1C
    je Ent
    jmp lop
	
leftarrow:
    cmp edi,0xB8000
    je lop
	xor edx,edx
	push ecx
	mov ah,0x02 
	int 16h 
	and al,01h
	jnz shiftleft 
	mov ah,0x02 
	int 16h 
	and al,02h 
	jnz shiftleft
	pop eax
	dec ecx
	dec esi 
	dec edi
	dec edi
	mov edx,ecx  
    call cursor
	jmp lop
	lab:
	inc edx 
	mov ah,0x02 
	int 16h 
	and al,01h
	jnz shiftleft 
	mov ah,0x02 
	int 16h 
	and al,02h 
	jnz shiftleft
	
	  push edi 
	 push ecx 
	 push edx 
	 push esi 
	 mov edi,0xB8000
     xor ecx,ecx 	 
	 lop43:
	 inc edi
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc ecx  
		 cmp ecx,2080 
		 jl lop43
		 pop esi 
		 pop edx 
		 pop ecx 
		 pop edi 
	 jmp lop
shiftleft:
     
     dec edi
	 mov al , byte[edi]
	 cmp al,0x07
	 jne unhil
	 mov al,0x4f
	 mov byte[edi],al
	 dec edi
	 dec esi
	 dec ecx
	 call cursor
	 mov ah,10h
	 int 16h
	 cmp al,0x03
	 je copy1
	 cmp al,0x18
	 je cut1
	 continue7:
	 cmp ah,0x4b
	 je lab
	 cmp ah,0x4d
	 je rightarrow3
	 
	 push edi 
	 push ecx 
	 push edx 
	 push esi 
	 mov edi,0xB8000
     xor ecx,ecx 	 
	 lop48:
	 inc edi
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc ecx  
		 cmp ecx,2080 
		 jl lop48
		 pop esi 
		 pop edx 
		 pop ecx 
		 pop edi 
		 mov edx,ecx 
	 jmp lop
rightarrow3:
push edi 
	 push ecx 
	 push edx 
	 push esi
     mov ah,0x02
     int 16h
     and al,0x01
     jnz shiftright	 
	 mov edi,0xB8000
     xor ecx,ecx 	 
	 lop46:
	 inc edi
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc ecx  
		 cmp ecx,2080 
		 jl lop46
		 pop esi 
		 pop edx 
		 pop ecx 
		 pop edi  
		 call cursor
	 jmp lop
   unhil:
     mov al,0x07
	 mov byte[edi],al
	 dec edi
	 dec esi
	 dec ecx
	 call cursor
	 jmp lop
	
cut1:
    pop eax
	push ecx 
	push edi 
	push esi
	push edx
	xor edx,edx
	
   	 lea esi,[cop+edx*2]
	 mov bl,0
	 l5:
	 mov byte[esi],bl
	 inc edx
	 lea esi,[cop+edx*2]
	 cmp byte[esi],0
	 jne l5
	 xor edx,edx
  notfinished5:
	lea ebx,[sav+ecx*2]
	mov esi, [ebx]
	lea ebx,[cop+edx*2]
	mov [ebx],esi
	lea ebx,[sav+ecx*2]
	mov byte[ebx],0x20
	mov byte[edi],0
	inc edi
	mov byte[edi],0x07
	inc edi
	inc ecx
	inc edx
	cmp ecx,eax
	jne notfinished5
	lea ebx,[cop+edx*2]
	mov byte[ebx],0
	
	pop edx
	pop esi
	pop edi
	pop ecx
	mov edx,ecx
	jmp lop
	
copy1:
    pop eax
	push ecx 
	push edi 
	push esi
	push edx
	xor edx,edx
	
   	 lea esi,[cop+edx*2]
	 mov bl,0
	 l1:
	 mov byte[esi],bl
	 inc edx
	 lea esi,[cop+edx*2]
	 cmp byte[esi],0
	 jne l1
	 xor edx,edx
  notfinished:
	lea ebx,[sav+ecx*2]
	mov esi, [ebx]
	lea ebx,[cop+edx*2]
	mov [ebx],esi
	inc ecx
	inc edx
	cmp ecx,eax
	jne notfinished
	lea ebx,[cop+edx*2]
	mov byte[ebx],0
	
	pop edx
	pop esi
	pop edi
	pop ecx
	mov edx,ecx 
	mov ah,0x10 
	int 16h 
	jmp continue7
	
rightarrow:
	lea ebx,[sav+edx*2]
	mov al,byte[ebx]
	cmp al,0
	je lop
	push edx 
	xor edx,edx 
	mov ah,0x02 
	int 16h 
	and al,01h
	jnz shiftright 
	mov ah,0x02 
	int 16h 
	and al,02h 
	jnz shiftright
	pop edx 
	inc edi
	inc edi
	inc edx
	inc ecx
	call cursor
	jmp lop
	lab1:
	inc edx 
	mov ah,0x02 
	int 16h 
	and al,01h
	jnz shiftright 
	mov ah,0x02 
	int 16h 
	and al,02h 
	jnz shiftright
	
	  push edi 
	 push ecx 
	 push edx 
	 push esi 
	 mov edi,0xB8000
     xor ecx,ecx 	 
	 lop47:
	 inc edi
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc ecx  
		 cmp ecx,2080 
		 jl lop47
		 pop esi 
		 pop edx 
		 pop ecx 
		 pop edi
      mov edx,ecx		 
	 jmp lop
	 
shiftright:
     inc edi
	 mov al , byte[edi]
	 cmp al,0x07
	 jne unhil1
	 mov al,0x4f
	 mov byte[edi],al
	 inc edi
	 inc esi
	 inc ecx
	 call cursor
	 mov ah,10h
	 int 16h
	 cmp al,0x03
	 je copy2
	 cmp al,0x18
	 je cut2
	 continue8:
	 cmp ah,0x4d
	 je lab1 
	 cmp ah,0x4b
	 je leftarrow3
	 push edi 
	 push ecx 
	 push edx 
	 push esi 
	 mov edi,0xB8000
     xor ecx,ecx 	 
	 lop44:
	 inc edi
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc ecx  
		 cmp ecx,2080 
		 jl lop44
		 pop esi 
		 pop edx 
		 pop ecx 
		 pop edi 
	 jmp lop
	leftarrow3:
	
push edi 
	 push ecx 
	 push edx 
	 push esi 
	 mov ah,0x02
	 int 16h
	 and al,0x01
	 jnz shiftleft
	 mov edi,0xB8000
     xor ecx,ecx 	 
	 lop45:
	 inc edi
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc ecx  
		 cmp ecx,2080 
		 jl lop45
		 pop esi 
		 pop edx 
		 pop ecx 
		 pop edi 
		 inc edx
		 sub esi,edx 
		 sub ecx,edx 
		 mov eax,2
		 mul edx 
		 sub edi,eax
         mov edx,ecx		 
		 call cursor
	 jmp lop
	 
   unhil1:
     mov al,0x07
	 mov byte[edi],al
	 inc edi
	 inc esi
	 inc ecx
	 call cursor
	 jmp lop
    
cut2:
    pop eax
	push ecx 
	push esi
	push edx
	xor edx,edx
	
   	 lea esi,[cop+edx*2]
	 mov bl,0
	 l3:
	 mov byte[esi],bl
	 inc edx
	 lea esi,[cop+edx*2]
	 cmp byte[esi],0
	 jne l3
	 xor edx,edx
	 
	 xchg eax,ecx
	 dec eax
	 dec edi
	 mov byte[edi],0x07
	 dec edi
  notfinished3:
	lea ebx,[sav+ecx*2]
	mov esi, [ebx]
	lea ebx,[cop+edx*2]
	mov [ebx],esi
	lea ebx,[sav+ecx*2]
	mov byte[ebx],0
	mov byte[edi],0x20
	inc ecx
	inc edx
	dec esi
	dec edi
	mov byte[edi],0x07
	dec edi
	cmp ecx,eax
	jle notfinished3
	lea ebx,[cop+edx*2]
	mov byte[ebx],0
	mov eax,edx
	dec eax 
	inc edi
	inc edi
	pop edx
	pop esi
	sub esi,eax
	sub edx,eax
	pop ecx
	sub ecx,eax
	mov ebx,ecx
	dec ecx
	;mov ecx,edx
	;sub ecx,ebx
	;inc esi 
	call cursor
	jmp lop
	
copy2:
	pop eax
	push ecx 
	push edi 
	push esi
	push edx
	xor edx,edx
	
   	 lea esi,[cop+edx*2]
	 mov bl,0
	 l2:
	 mov byte[esi],bl
	 inc edx
	 lea esi,[cop+edx*2]
	 cmp byte[esi],0
	 jne l2
	 xor edx,edx
	 xchg eax,ecx
	 dec eax
  notfinished2:
	lea ebx,[sav+ecx*2]
	mov esi, [ebx]
	lea ebx,[cop+edx*2]
	mov [ebx],esi
	inc ecx
	inc edx
	cmp ecx,eax
	jne notfinished2
	
	
	pop edx
	pop esi
	pop edi
	pop ecx
	mov ah,0x10 
	int 16h 
	jmp continue8
     
selectAll: 
    lea ebx,[sav+ecx*2]
	mov al,byte[ebx]
	cmp al,0
	je continue6
    lop5:
    inc edi 
	inc edi 
	inc ecx
	lea ebx,[sav+ecx*2]
	mov al,byte[ebx]
	cmp al,0
	jne lop5
	mov eax,ecx 
	push eax 
	continue6:
    push esi
	push edx 
	push ecx 
	xor esi,esi
	xor edx,edx
	xor ecx,ecx
	lop2:
	dec edi
	mov al,0x4F
	mov [edi],al 
	dec edi
	cmp edi,0xB8000
	je continue5
	jmp lop2
	continue5:
	
	call cursor 
	
         mov ah,10h
		 int 16h 
		 cmp al,0x18
	     je cut
	     cmp al,0x03
	     je copy
		 cmp ah,0x1C
         je Ent2
		 cmp ah,0x4d
        je rightarrow2
        cmp ah,0x4b
	    je leftarrow2
	    cmp ah,0x0e 
        je bksp2
	   cmp ah,0x48
       je uparrow2
       cmp ah,0x50
       je downarrow2
       cmp ah,0x47
       je home2
		 pop ecx 
		 push eax 
		 lop4:
		 mov al,0
         mov [edi],al
         lea ebx,[sav +edx*2]
         mov byte[ebx],al
		 inc edi 
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc edx 
		 cmp edx,ecx 
		 jl lop4
		 pop eax 
		 mov edi,0xB8000
		 mov [edi],al
		 pop edx 
		 pop esi 
		 pop eax
		 mov ecx,1
		 mov esi,1 
		 mov edx,1
		 inc edi
		 inc edi 
		 jmp lop 
	     Ent2:
		 xor edx,edx
		 mov edi,0xb8000
		 lop10:
		 mov al,0
         mov [edi],al
         lea ebx,[sav +edx*2]
         mov byte[ebx],al
		 inc edi 
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc edx 
		cmp edx,2080
		 jl lop10
		 mov al,0
		 mov [edi],al
		 mov edi,0xB8000
         xor esi,esi
         xor ecx,ecx
         xor edx,edx		 
		 je Ent	
		 home2:
		 xor edx,edx
		 mov edi,0xb8000
		 lop15:
		 inc edi 
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc edx 
		 cmp edx,2080
		 jl lop15
		 xor ecx,ecx
         xor edx,edx
         xor esi,esi
         mov edi,0xB8000
         jmp lop
	
		 rightarrow2:
		 push edi
		 xor edx,edx
		 mov edi,0xb8000
		 lop16:
		 inc edi 
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc edx 
		 lea ebx,[sav+edx*2]
		 mov al,byte[ebx]
		 cmp al ,0
		 jne load 
		 continue1:
		 cmp edx,2080
		 jl lop16
		 xor eax,eax
		 lea ebx,[last+eax*1]
		 mov edx,[ebx]
		 inc edx
		 mov ecx,edx
         mov eax,2		 
		 mul edx 
		 add eax,0xb8000
		 mov edi,eax 
		 call cursor
		 
         jmp lop
		 
		 load:
		 xor eax,eax
		 lea ebx,[last+eax*1]
		 mov [ebx],edx
		 mov esi,edx
		 inc esi
		 jmp continue1
		 
		 uparrow2: 
		 xor edx,edx
		 mov edi,0xb8000
		 lop13:
		 inc edi 
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc edx 
		 cmp edx,2080
		 jl lop13
		 xor ecx,ecx
         xor edx,edx
         xor esi,esi
         mov edi,0xB8000
         jmp lop
		 
		 downarrow2:
		 xor edx,edx
		 mov edi,0xb8000
		 lop12:
		 inc edi 
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc edx 
		 cmp edx,2080
		 jl lop12
		 xor ecx,ecx
         xor edx,edx
         xor esi,esi
         mov edi,0xB8000
         jmp lop		 
		 
		 bksp2:
		 xor edx,edx
		 mov edi,0xb8000
		 lop11:
		 mov al,0
         mov [edi],al
         lea ebx,[sav +edx*2]
         mov byte[ebx],al
		 inc edi 
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc edx 
		 cmp edx,2080
		 jl lop11
         xor ecx,ecx
         xor edx,edx
         xor esi,esi
         mov edi,0xB8000
         jmp lop		 
		 
		 leftarrow2:
		 xor edx,edx
		 mov edi,0xb8000
		 lop14:
		 inc edi 
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc edx 
		 cmp edx,2080
		 jl lop14
		 xor ecx,ecx
         xor edx,edx
         xor esi,esi
         mov edi,0xB8000
         jmp lop		
copy:
     xor ecx,ecx
	 lea ebx,[cop+ecx*2]
	 mov al,0
	 l:
	 mov byte[ebx],al
	 inc ecx
	 lea ebx,[cop+ecx*2]
	 cmp byte[ebx],0
	 jne l
	 
     pop ecx 
	 pop edx 
	 pop esi  
	 pop eax
	 cmp eax,ecx
	 je fromSelectAll
	 push eax 
	 fromSelectAll:
     mov edi,0xB8000
	 xor edx,edx
	 lop6:
	 mov al,byte[edi]
     inc edi
	 inc edi 	 
	 lea ebx,[cop+edx*2]
	 mov byte[ebx],al
     inc edx
     cmp edx,ecx 
     jl lop6	 
	 xor esi,esi
	 mov edi,0xB8000 
	 xor edx,edx 
	  mov ah,10h
		 int 16h 
		 cmp al,0x18
	     je cut
	     cmp al,0x03
	     je lop 
		  cmp al,0x16
	      je modifiy5
		  cmp ah,0x1C
         je Ent1
		 cmp ah,0x4d
        je rightarrow1
        cmp ah,0x4b
	    je leftarrow1
	    cmp ah,0x0e 
        je bksp1
	   cmp ah,0x48
       je uparrow1
       cmp ah,0x50
       je downarrow1
       cmp ah,0x47
       je home1 
		 push eax
		 lop8:
		 mov al,0
         mov [edi],al
         lea ebx,[sav +edx*2]
         mov byte[ebx],al
		 inc edi 
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc edx 
		 cmp edx,ecx 
		 jl lop8
		 pop eax
		 mov edi,0xB8000
		 mov [edi],al
		 mov ecx,1
		 mov esi,1 
		 mov edx,1
		 inc edi
		 inc edi
	 call cursor
		 jmp lop
		 modifiy5:
		 xor ecx,ecx
		 xor esi,esi
		 xor edx,edx
		 call paste
		 jmp lop
		 
		 home1:
		 call paste
		 xor ecx,ecx
		 xor edx,edx
		 mov edi,0xB8000
		 xor esi,esi
		 call cursor
	     jmp lop 
	
		 Ent1:
		 mov al,0
         mov [edi],al
         lea ebx,[sav +edx*2]
         mov byte[ebx],al
		 inc edi 
		 mov al,0x07
		 mov [edi],al
		 inc edi 
		 inc edx 
		 cmp edx,ecx 
		 jl Ent1
		 mov al,0
		 mov [edi],al
		 mov edi,0xB8000
         xor esi,esi
         xor ecx,ecx
         xor edx,edx		 
		 je Ent
		 
		 rightarrow1:
		 xor ecx,ecx
		 call paste
		 
		 jmp lop 
		 
		 uparrow1: 
		 jmp home1
		 
		 downarrow1:
		 call paste
		 xor ecx,ecx
		 xor edx,edx
		 mov edi,0xB8000
		 xor esi,esi
		 call cursor
	     jmp downarrow 
		 
		 bksp1:
		 jmp cut 
		 
		 leftarrow1:
		 jmp home1
 
cut:
pop ecx 
	 pop edx 
	 pop esi  
	 pop eax
	 cmp eax,ecx
	 je fromSelectAll1
	 push eax 
	 fromSelectAll1:
     mov edi,0xB8000
	 xor edx,edx
	 lop7:
	 mov al,byte[edi] 	 
	 lea ebx,[cop+edx*2]
	 mov byte[ebx],al
	 mov al,0 
	 lea ebx,[sav+edx*2]
	 mov byte[ebx],al
	 mov byte[edi],al
	 inc edi
	 mov al,0x07
	 mov byte[edi],al
	 inc edi
     inc edx
     cmp edx,ecx 
     jl lop7	 
	 xor esi,esi
	 mov edi,0xB8000 
	 xor edx,edx
	 xor ecx,ecx 
	 call cursor 
	 jmp lop
	
paste:
     push edx 
	 xor edx,edx 
    lea ebx,[cop+edx*2]
	mov al,byte[ebx]
	cmp al,0
	je modifiy4
	lop9:
	mov byte[edi],al
	lea ebx,[sav+ecx*2]
	mov byte[ebx],al
	inc edx 
	inc edi
	mov al,0x07 
	mov byte[edi],al
	inc edi
    inc esi 
    inc ecx 	
	lea ebx,[cop+edx*2]
	mov al,byte[ebx]
	cmp al,0 
	jne lop9
	pop eax
	add edx,eax
    call cursor	
    ret
    modifiy4:
	pop edx 
	call cursor
	ret   
	

	
uparrow:
    cmp ecx,80
    jl lop
    sub ecx,80 
    sub edi,160 
    sub edx,80
    call cursor
    jmp lop 


reset:
    xor edx,edx
    jmp lop
	
	times (0x400000 - 512) db 0
	last: dd 0
    sav :times 2080 db 0
    cop :times 2080 db 0
	cop1 :times 2080 db 0
db 	0x63, 0x6F, 0x6E, 0x65, 0x63, 0x74, 0x69, 0x78, 0x00, 0x00, 0x00, 0x02
db	0x00, 0x01, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
db	0x20, 0x72, 0x5D, 0x33, 0x76, 0x62, 0x6F, 0x78, 0x00, 0x05, 0x00, 0x00
db	0x57, 0x69, 0x32, 0x6B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x78, 0x04, 0x11
db	0x00, 0x00, 0x00, 0x02, 0xFF, 0xFF, 0xE6, 0xB9, 0x49, 0x44, 0x4E, 0x1C
db	0x50, 0xC9, 0xBD, 0x45, 0x83, 0xC5, 0xCE, 0xC1, 0xB7, 0x2A, 0xE0, 0xF2
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
