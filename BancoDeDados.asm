org 0x7c00
jmp main



;funções importantes porem não vale a pena ficar chaando(call) pois diminui a eficiencia do codigo
printaCaracter:
mov ah, 0Eh
mov bh,0
int 0x10
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pularLinha: db '', 10,13,0
msgInserirCliente: db 'Inserir Cliente', 10,13,0
msgAlterarCliente: db 'Alterar Cliente', 10,13,0
msgConsultarCliente: db 'Consultar Cliente', 10,13,0
msgDesvincularCliente: db 'Desvincular Cliente', 10,13,0


;Mensagems do menu
msgBemVindo: db '#### Bem vindo ao BancoKOF ###', 10,13,0
msgMenu0: db 'Escolha uma opcao:',10,13,0
msgMenu1: db '  1)Inserir Cliente',10,13,0
msgMenu2: db '  2)Alterar Cliente',10,13,0
msgMenu3: db '  3)Consultar Cliente',10,13,0
msgMenu4: db '  4)Desvincular Cliente',10,13,0
msgMenu5: db '#############################',10,13,0

;Mensagens do ValidaOpçao
msgOpcaoError: db 'Por favor insira uma das opcoes citadas acima',10,13,0


;funções do codigo assembler
InserirCliente:
	call limpaTela
	mov si,msgInserirCliente
	call printString
	ret

;alterarCliente:
;	call limpaTela
;	mov si,msgAlterarCliente
;	call printString
;	ret
;
;consultarCliente:
;	call limpaTela
;	mov si,msgConsultarCliente
;	call printString
;	ret
;desvincularCliente:
;	call limpaTela
;	mov si,msgDesvincularCliente
;	call printString
;	ret





;printa o menu de opçoes
printMenu:

	mov si, msgBemVindo
	call printString

	mov si, msgMenu0
	call printString

	mov si, msgMenu1
	call printString

	mov si, msgMenu2
	call printString

	mov si, msgMenu3
	call printString

	mov si, msgMenu4
	call printString

	mov si, msgMenu5
	call printString
	ret




validaOpcao:
	;printaPulaLinha
	mov si, pularLinha
	call printString
	
	;captura letra e coloca em al
	mov ah,0
	int 16h
	
	;verifica a opçao desejada
	cmp al,'1'
	je opcao1
	
	cmp al,'2'
	je opcao2

	cmp al,'3'
	je opcao3

	cmp al,'4'
	je opcao4

	jmp error

	;direciona para a opçao desejada
	opcao1:
		mov al,1
		ret
	opcao2:
		mov al,2
		ret
	opcao3:
		mov al,3
		ret
	opcao4:
		mov al,4
		ret
	
	;printa msg de error
	error:
	mov si,msgOpcaoError
	call printString
	jmp validaOpcao



;printa a string aponda por si
;nao printa acentos
printString:
	push ax;
	push ds
	mov ax, 0
	mov ds,ax

	mov cl,0
	loop:

	lodsb

	cmp cl,al
	je exit

	mov ah, 0xE
	mov bh,0
	int 0x10
	jmp loop
	exit:
	pop ds
	pop ax
	ret





;atualmente estou limpando configurando um novo tipo de video
;Há jeito melhor, mas nao sei fazer...
limpaTela:
	push ax
	mov ah,00h
	mov al ,03h
	int 10h
	pop ax
	
	ret

main: 

	call limpaTela

	call printMenu
	call validaOpcao;fica na subrotina até retorna uma das opções 1,2,3,4 no registrador al

	;verifica a opçao desejada
	cmp al,1
	je callOpcao1
	
	cmp al,2
	je callOpcao2

	cmp al,3
	je callOpcao3

	cmp al,4
	je callOpcao4

	jmp fim

	;direciona para a opçao desejada
	callOpcao1:
		call InserirCliente
		jmp fim

	callOpcao2:
		call InserirCliente
		jmp fim
	callOpcao3:
		call InserirCliente
		jmp fim
	callOpcao4:
		call InserirCliente
		jmp fim
	
	fim:





times 510-($-$$) db 0

dw 0AA55h ; some BIOSes require this signature