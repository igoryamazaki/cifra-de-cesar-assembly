.data

	Introd: .asciiz "Cifra de Cesar - MIPS32"
	Msg1: .asciiz "\n(0) Criptografar \n(1) Descriptografar \nDigite a op��o desejada: "
	Msg2: .asciiz "Digite a palavra: "
	Msg3: .asciiz "Digite o n�mero do fator: "
	Msg4: .asciiz "Mensagem Criptografada: "
	MsgErro: .asciiz "ERRO" #se escolher um n�mero != de 1 e 2 na Msg1
	MsgFim: .asciiz "\nFim do programa..."
	palavra: .space 20

.text

	##Introdu��o
	li $v0,4 
	la $a0,Introd
	syscall 
	##Criptografar ou Descriptografar
	li $v0,4 
	la $a0,Msg1
	syscall
	
	jal LeInteiro
	
	move $s1,$v0                #Insere o numero a opcao(0 ou 1) para $s1
	addi $t1,$zero,1
	slt $t0,$t1,$s1				 #se 1 < $s1(opcao do usu�rio) ent�o $t0 = 1
	bne $t0,$t1,L0			     #se $t0 != 1, j para L0
	
	jal ERROR
	L0:
	addi $t2,$zero,0
	slt $t0,$s1,$t2				 #se $s1 < 0(opcao do usu�rio) ent�o $t0 = 1
	bne $t0,$t1,L1				 #se $t0 != 1, j para L1
	
	jal ERROR
	
	L1:
	beq $v0,$t1,L2             # se a op��o digitada for == 1, logo Descriptografa

	jal Criptografar 
	                           #se n�o, Criptografa
	L2:
	jal Descriptografar
	
	ERROR: 
		li $v0,4
		la $a0,MsgErro
		syscall
		jal EncerraPrograma
	
	LeInteiro:
		li $v0,5
		syscall
		jr $ra
		
	LeString:
		la $a0, palavra
		la $a1, 32
		li $v0,8
		syscall
		jr $ra
		
	EncerraPrograma:
		li $v0,4 
		la $a0,MsgFim
		syscall
		li $v0, 10
		syscall
	
	Criptografar:
		#lendo String
		li $v0,4 
		la $a0,Msg2
		syscall 
		jal LeString
		la $t0,($a0)
		
		#lendo o n�mero fator da Cifra
		li $v0,4 
		la $a0,Msg3
		syscall
		jal LeInteiro
		move $t1,$v0 			#atribui o inteiro lido em $t1
		
		#Criptografando
		li $v0,4
		la $a0,Msg4
		syscall
			
		li $s0, 125######
    	li $s1, 33#######
    	li $s2, 1########
		
		LoopCrip:
 			lb $t2, 0($t0)  		#carrega o byte da posi��o $t0 da palavra	 	
 			beq $t2,10,SaiDoLoop 	#metodo de parada � o LF(line feed, pr�xima linha)	
 			
 			#verifica se o caracter est� presente no conjunto X
 			#{X|X>33 e X<125
 			#nesta parte � analisado somente os n�meros maiores que 125
 			#caso forem, ap�s chegar no caractere 125, o $t2 � levado at� o 33
 			
 			addi $t4,$t1,1			#$t4 = fator + 1
 			add $t3,$t2,$t4		    #$t3 = caracter + $t4
 			slt $t4,$s0,$t3			#se 125 < $t3, $t4 = 1
 			beq $t4,$s2,L3			#se $t4 == 1, pula para L3
 			j L4 					#caso n�o for continua o programa pulando para L4
 			L3:
 			addi $t2,$zero,32		#a palavra pula para o caracter 33 da tabela ascii										
 			L4:
 			
 			#faz a opera��o da cifra de Cesar
 			
 			li $t4,0																																																																																																																																	
 			add $t2, $t2, $t1		#soma o fator ao caracter correspondente
 			move $a0, $t2    		#coloca o resultado da opera��o $a0
 			li $v0,11 				#chama o codigo do syscall para imprimir caracter
 			syscall
 			add $t0,$t0,1 			#incrementa para o pr�ximo caracter(e posi��o) do vetor
 		
 			j LoopCrip				#retorna no Loop
		
	Descriptografar:
		#lendo String
		li $v0,4 
		la $a0,Msg2
		syscall 
		jal LeString
		la $t0,($a0)
		
		#lendo o n�mero fator da Cifra
		li $v0,4 
		la $a0,Msg3
		syscall
		jal LeInteiro
		move $t1,$v0 				#atribui o inteiro lido em $t1
		
		#Criptografando
		li $v0,4
		la $a0,Msg4
		syscall
			
		LoopDesc:
 			lb $t2, 0($t0)  		#carrega o byte da posi��o $t0 da palavra	 	
 			beq $t2,10,SaiDoLoop 	#metodo de parada � o LF(line feed, pr�xima linha)		
 			
 			subi $t3,$t2,1			
 			slt $t4,$s1,$t3
 			beq $t4,$s2,L5
 			j L6 				
 			L5:
 			addi $t2,$zero,126											
 			L6:	
 						
 			sub $t2, $t2, $t1		#subtrai o fator ao caracter correspondente
 			move $a0, $t2   		#coloca o resultado da opera��o $a0
 			li $v0,11 				#chama o codigo do syscall para imprimir caracter
 			syscall
 			add $t0,$t0,1 			#incrementa para o pr�ximo caracter(e posi��o) do vetor
 		
 			j LoopDesc					#retorna no Loop
			
		SaiDoLoop:
			jal EncerraPrograma
		
