;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ALunos: Luiz Antonio
;ALunos: Thiago Augusto
;ALunos: Rafael
;ALunos: José Brandão
;ALunos: Marco
;
;
;
;									Projeto de um Banco de dados
;Funcionamento:
;	É alocado uma regiao de memoria (label: memoria) que contem todas as informações sobre o banco
;		O primeito byte índica quais posições na memoria está com cliente ou nao
;	Exemplo: 
;		configuração do primeiro byte: 1|0|1|0|0|0|0|0
;		logo existe cliente na posição 1 e 3 
;	Como achar o cliente?
;		Suponha que queiremos acessar o cliente 3, para isso basta multiplicar 46*(3-1)		
;		e somar 1.
;			46 pois cada cliente contem 46 byte de memoria e somar 1 devido ao primeiro byte ser o 
;			byte do mapa de clientes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




org 0x7e00
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
msgDesvincularCliente: db 'Insira o CPF do cliente', 10,13,0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Mensagems do menu
msgBemVindo: db '#### Bem vindo ao BancoKOF ###', 10,13,0
msgMenu0: db 'Escolha uma opcao:',10,13,0
msgMenu1: db '  1)Inserir Cliente',10,13,0
msgMenu2: db '  2)Alterar Cliente',10,13,0
msgMenu3: db '  3)Consultar Cliente',10,13,0
msgMenu4: db '  4)Desvincular Cliente',10,13,0
msgMenu5: db '#############################',10,13,0

dFNF_Msg: db 'Cliente não encontrado!', 10, 13, 0
deletionEnd_msg: db 'Remoção completa, redirecionando para o menu', 10, 13, 0


;Mensagens do ValidaOpçao
msgOpcaoError: db 'Por favor insira uma das opcoes citadas acima',10,13,0

;;;;;;;;;;;;;;Mensgens usadas na inserção
;MEnsagens para capturar nome, CPF, conta e agência
msgInserirNome: db 'Insira o nome do cliente',10,13,0
msgInserirCPF: db 'Insira o cpf do cliente',10,13,0
msgInserirAgencia: db 'Insira a agencia do cliente',10,13,0
msgInserirConta: db 'Insira a conta do cliente',10,13,0
msgInseridoSucesso: db 'Insercao concluida com sucesso!',10,13,0
msgInserirCheio: db 'O BancoKOF esta lotado, procure o banco de Valgueiro XD!',10,13,0



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


memoria TIMES   46*8   DB   0; declaro um vetor de 46*8 elemento e cada um contem 1 Byte e valor zero
;8 devido ao banco conter 8 clientes
;46 devido a
	;(20 bytes pro nome 1byte fim do nome)
	; (11 por cpf + 1 byte pro fim do cpf)
	; (5 pra agencia + 1 pro fim da agencia )
	; (6 pra conta + 1 pro fim da agencia)


;função de delay
delay: 
;; Função que aplica um delay(improvisado) baseado no valor de dx
	push bp
	push dx

	mov dx,2000

	mov bp, dx
	back:
	dec bp
	nop
	jnz back
	dec dx
	cmp dx,0    
	jnz back
	pop dx
	pop bp
ret



;funções do codigo assembler
InserirCliente:
	

	call limpaTela
	mov si,msgInserirCliente
	call printString

	;procura posição livre
			;1|2|3|4|5|6|7|8
			;0|0|0|0|0|0|0|0
	;zero: significa vazio 
	;1 significa ocupado
	inserir:
	
	mov cl,0
	mov si,memoria;move para si a base do vetor nome
	mov al,byte[si]
	;mov al ,10111110b
	
	procuraPosLivre:
		;mov al ,10111110b
		cmp cl,8
		je cheio;só é permitido 8 pessoas no banco

		shl al,1;shift para esquerda e o bit "perdido é colocado na flag do carry"
		inc cl
		jc procuraPosLivre

	
	

	;printa a posição q o cliente está sendo inserido
	add cl,'0';
	;print oq ta em al
	mov al,cl
	mov ah, 0Eh
	mov bh,0
	int 0x10
	sub cl,'0'

	

	

	cmp cl,1
	je um
	cmp cl,2
	je dois
	cmp cl,3
	je tres
	cmp cl,4
	je quatro
	cmp cl,5
	je cinco
	cmp cl,6
	je seis
	cmp cl,7
	je seti
	cmp cl,8
	je oito

	jmp getname

	um:
	or byte[si],10000000b
	jmp getname
	dois:
	or byte[si],01000000b
	jmp getname
	tres:
	or byte[si],00100000b
	jmp getname
	quatro:
	or byte[si],00010000b
	jmp getname
	cinco:
	or byte[si],00001000b
	jmp getname
	seis:
	or byte[si],00000100b
	jmp getname
	seti:
	or byte[si],00000010b
	jmp getname
	oito:
	or byte[si],00000001b
	jmp getname
	;mov byte[si],al


	getname:

	
	 	
	;jmp inserir

	sub cl,1
	mov ax,46;(20 bytes pro nome 1byte fim do nome)
	; (11 por cpf + 1 byte pro fim do cpf)
	; (5 pra agencia + 1 pro fim da agencoa )
	; (6 pra conta + 1 pro fim da agencoa
	mul cl

	inc ax;pula o primeiro byte q é o byte do mapa
	push ax

	;mov si,ax

	;;;;;;captura nome
		mov cx,20;20 caracteres
		
	
		;printa msg para inseir nome
		mov si,msgInserirNome
		call printString
		

		
		mov si,memoria
		add si,ax
		capturandoNome:
		
		
		mov ah,0
		int 16h
		mov byte[si],al
		
		cmp al,13
		je getCPF;se o usuario apertar enter sai do laço
		;printa caracter q está em al
		mov ah, 0Eh
		mov bh,0
		int 0x10

		
		add si,1
		
		loop capturandoNome

		getCPF:

;;;;;;captura cpf
		

		call limpaTela
		pop ax
		
		
		mov cx,11;
		
	
		;printa msg para inseir cpf
		mov si,msgInserirCPF
		call printString
		

		add ax,21;pula 20byte do nome + 1 byte do caracter vazio
		push ax;coloca na pilha para ser consultado qnd for get agencia
		mov si,memoria
		;captura letra e coloca em al
		add si,ax;pula 20bytes do nome
		capturandoCPF:
		
		mov ah,0
		int 16h
		mov byte[si],al
		
		cmp al,13
		je getAgencia;se o usuario apertar enter sai do laço
		;printa caracter q está em al
		mov ah, 0Eh
		mov bh,0
		int 0x10

		
		add si,1
		
		loop capturandoCPF
		

;;;;;;captura agencia
		getAgencia:

		call limpaTela
		pop ax
		;
		
		mov cx,5;
		
	
		;printa msg para inseir agencia
		mov si,msgInserirAgencia
		call printString
		
		add ax,12;configurando para pular os 11 bytes do cpf + 1 byte do fim do cpf
		push ax

		mov si,memoria
		;captura letra e coloca em al
		add si,ax;;pula os 11 bytes do cpf + 1 byte do fim do cpf
		capturandoAgencia:
		
		
		mov ah,0
		int 16h
		mov byte[si],al
		
		cmp al,13
		je getConta;se o usuario apertar enter sai do laço
		;printa caracter q está em al
		mov ah, 0Eh
		mov bh,0
		int 0x10

		
		add si,1
		
		loop capturandoAgencia


;;captura conta		

getConta:

		call limpaTela
		pop ax


		mov cx,6;o usuario só pode digitar 6 vezes
		
	
		;printa msg para inseir agencia
		mov si,msgInserirConta
		call printString
		
		add ax,6;configurando para pular os 6 bytes da agencia + 1 byte do fim da agencia
		
		mov si,memoria
		;captura letra e coloca em al
		add si,ax;pula os 6 bytes da agencia + 1 byte do fim da agencia
		capturandoConta:
		
		
		mov ah,0
		int 16h
		mov byte[si],al
		
		cmp al,13
		je fimInsercao;se o usuario apertar enter sai do laço
		;printa caracter q está em al
		mov ah, 0Eh
		mov bh,0
		int 0x10

		
		add si,1
		
		loop capturandoConta








fimInsercao:;printa msg de insrido com sucesso e dá um delay
	call limpaTela
	mov si,msgInseridoSucesso
	call printString
	call delay
	ret
cheio:;printa msg do banco está cheio dá um delay
	call limpaTela
	mov si,msgInserirCheio
	call printString
	call delay
	ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;AS funções que falta fazer;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alterarCliente:
	call limpaTela
	mov si,msgAlterarCliente
	call printString
	ret

consultarCliente:
	call limpaTela
	mov si,msgConsultarCliente
	call printString
	ret

desvincularCliente:
	call limpaTela
	mov si, msgDesvincularCliente
	call printString

	mov si, memoria
	add si, 21  ;Posiciona si na base do primeiro CPF

	xor cx, cx ;Zera CX
	
	insertCpfForCheck:
		mov ah, 00h
		int 16h     ;Lê o primeiro valor do CPF
	
			cpfCheckLoop:
				cmp [si], al  ;Compara o valor lido com o primeiro valor do CPF
				jne ccF       ;Pula pra falha se não for igual
					ccS: ;CPF Check Success
						inc cx ;Se bem sucedido, incrementa CX
						cmp cx, 11 ;Compara cx com 11 (se chegar a 11 quer dizer que já é o CPF todo)
						je dCPF ;Pula (se já tivermos validado o CPF completo) para dCPF(Delete CPF)

						add si, 1 ;Se ainda não tivermos chegado em 11, adiciona mais um em si para a prox comparação
						jmp insertCpfForCheck ;Pula pra o inicio
					ccF: ;CPF Check Failure
						sub si, cx ;Subtrai o valor de cx de si (Valor de digitos validados até aqui) para setar si para o inicio do CPF que está sendo lido 
						add si, 46 ;Soma si com 46 para ir para o próximo cliente na memória
						cmp si, (memoria + 21)*8 ;Compara o valor de SI com o tamanho máximo da memoria para saber se já estamos fora do range
						jg dFNF ;Se si for maior que o endereçamento da memória, pula  para dFNF (deletion failure NOT FOUND)
						jmp insertCpfForCheck ;Caso contrário pula para o inicio para checar o próximo CPF
	
	dCPF:
		sub si, 32 ;Subtrai 32 ( 11 do CPF lido + 21 do nome)
		mov ax, 46 ;Coloca 46 em ax
		dCPFLoop:
			mov si, 0 ;Coloca 0 no primeiro endereço de si
			inc si    ;Incrementa SI
			dec ax    ;Decrementa AX
			cmp ax, 0 ;Compara ax com zero (já deletamos o cliente)
			jne dCPFLoop ; Repete o loop até zerarmos todos os espaços que o cliente ocupava
			
			mov si, deletionEnd_msg 
			call printString  ;Coloca deletionEndmsg em Si e printa, em seguida chama o menu

			call delay
			call delay

			call menu


    dFNF: ;Deletion Failure NOT FOUND
		mov si, dFNF_Msg 
		call printString  ;Printa a mensagem de cliente não encontrado e manda pra o menu

		call delay
		call delay

		jmp menu

	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




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



;Retorna apenas um dos valores 1 2, 3 ou 4
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
	;empilha os registradores q serão utilizados
	push ax;
	push ds
	push cx

	mov ax, 0
	mov ds,ax

	mov cl,0
	loop:
		lodsb
		cmp cl,al;como para pra ver se se zero
		je exit;se for zero fim da string
		;printa caracter q está em al
		mov ah, 0xE
		mov bh,0
		int 0x10
		jmp loop
	exit:
	;desempilha os registradores q foram utilizados
	pop cx
	pop ds
	pop ax
	ret





;atualmente estou limpando configurando um novo tipo de video
;Há jeito melhor, mas nao sei fazer...
;Mas funciona!!
limpaTela:
	push ax
	mov ah,00h
	mov al ,03h
	int 10h
	pop ax
	
	ret

main: 
	;Zera os byte do mapa de clientes
	mov si,memoria;move para si a base do vetor nome
	mov word[si] ,0

	menu:
	;Printa nome do segundo cliente

		;printa nome
		mov si,memoria
		inc si
		add si, 46
		call printString
		call delay	
		call limpaTela
		;printa cpf
		mov si, memoria
		inc si
		add si,46
		add si, 21
		call printString
		call delay
		call limpaTela
		;printa agencia
		mov si, memoria
		inc si
		add si,46
		add si, 21
		add si,12
		call printString
		call delay
		call limpaTela
		;printa conta
		mov si, memoria
		inc si
		add si,46
		add si, 21;pula nome
		add si,12;pula cpf
		add si,6;pula agencia 
		call printString
		call delay
		call limpaTela

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	

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
		jmp menu

	callOpcao2:
		call alterarCliente
		jmp fim
	callOpcao3:
		call consultarCliente
		jmp fim
	callOpcao4:
		call desvincularCliente
		jmp fim
	
	fim:



