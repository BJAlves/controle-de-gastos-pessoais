.data

msg1: .asciiz "\t\t Programa para controle de gastos pessoais"
msg2: .asciiz "\n\nEscolha uma das opções abaixo:"
msg3: .asciiz "\n\n1 - Registrar despesa \n2 - Excluir despesa \n3 - Listar despesas \n4 - Exibir gasto mensal \n5 - Exibir gasto por categoria \n6 - Exibir ranking de despesas \n7 - Sair\n\n=> "
msg4: .asciiz "\nInsira a data de vencimento da fatura - Dia: "
msg5: .asciiz "\nInsira a data de vencimento da fatura - Mes: "
msg6: .asciiz "\nInsira a data de vencimento da fatura - Ano: "
msg7: .asciiz "\nInsira o nome da despesa com ate 15 caracteres: "
msg8: .asciiz "\nInsira o valor gasto em Reais: "
msg9: .asciiz "\n\n"
msg10: .asciiz "\n Id: "
msg11: .asciiz "\n Dia: "
msg12: .asciiz "\n Mes: "
msg13: .asciiz "\n Ano: "
msg14: .asciiz "\n Categoria: "
msg15: .asciiz "\n Valor: "
msg16: .asciiz "\n Data em dias: "
msg17: .asciiz "\n ID da despesa a excluir: "
msg18: .asciiz "\n ID de despesa nao encontrado \n"
msg19: .asciiz "\n Nao ha o que excluir\n Sem despesas cadastradas\n"
msg20: .asciiz "\n Despesa excluida com sucesso \n"

.align 2
vetorDespesa: .space 400
vetorAux: .space 400

.text
.globl main

main:

	add $t0, $zero,$zero			#contador auxiliar para exibicao de todos os registros
	add $s0,$zero,$zero 			#Id de cada despesa de forma incremental(contador)
	add $s1,$zero,$zero				#contem o valor do campo dia ----- necessario salvar, para utilizarmos do campo (data convertido em dias)
	add $s3,$zero,$zero				#contem o valor do campo ano ----- necessario salvar, para utilizarmos do campo (data convertido em dias)
	add $s7,$zero,$zero
	addi $t1,$zero,30
	addi $s2,$zero, 360

	li $v0,4						#O codigo 4, eh utilizado para escrever Strings
	la $a0, msg1					#Exibindo a msg1
	syscall

menuOpcoes:

	li $v0, 4						#O codigo 4, eh utilizado para escrever Strings
	la $a0, msg2					#Exibindo a msg2
	syscall

	li $v0, 4						#O codigo 4, eh utilizado para escrever Strings
	la $a0, msg3					#Exibindo a msg3 (Menu)
	syscall

	li $v0,5						#O codigo 5, eh utilizado para a leitura de um valor inteiro(uma das opcoes do menu) que será armazenado em $v0
	syscall

	beq $v0,1,cadastroDespesa		#comparacao das opcoes disponiveis no menu, pulando para o label correspondente
	beq $v0,2,excluirDespesa
	beq $v0,3,ordenarPorData
	beq $v0,4,gastoMensal
	beq $v0,5,ordenarPorNome
	beq $v0,6,ordenarPorValor
	
#********************************************************************************************************************************************
#************************************************************* CADASTRO DESPESAS
#********************************************************************************************************************************************

cadastroDespesa:

	addi $s0, $s0, 1				#ID de cada despesa. $s0 será incrementado a cada cadastro realizado
	sw $s0, vetorDespesa($s7)		#Armazenando o Id no vetorDepesa
	addi $s7, $s7, 4

#********************************************************* Cadastro campo Dia ***********************************************************
	li $v0, 4						#Exibindo a msg4 (Insira o dia)
	la $a0, msg4
	syscall

	li $v0,5						#Lendo o dia
	syscall
	add $s1,$v0,$zero				#$s1 contem o valor do campo (dia)

	sw $s1, vetorDespesa($s7) 		#Armazenando o ($s1) no vetorDespesa, onde $s7 eh o ponteiro do vetor
	addi $s7,$s7,4					#Andando 4bytes

#*********************************************************** Cadastro campo Mes ************************************************************
	li $v0, 4						#Exibindo a msg5 (Insira o mes)
	la $a0, msg5
	syscall

	li $v0,5						#Lendo o mes
	syscall
	add $t3, $v0,$zero				#$t3 contem o valor do campo (mes)

  mult $t3,$t1					#O mês será transformado em dia. Para isso, é multiplicado o valor do mes em $t3, com o $t1 que tem o valor de 30
	mflo $s5						#Resultado em $s5

	sw $t3, vetorDespesa($s7)		#Armazenando o ($t3) no vetorDespesa, onde $s7 eh o ponteiro do vetor
	addi $s7,$s7,4					#Andando 4bytes

#************************************************************** Cadastro campo Ano **********************************************************
	li $v0, 4						#Exibindo a msg6 (Insira o ano)
	la $a0, msg6
	syscall

	li $v0,5						#Lendo o ano
	syscall
	add $s3, $v0,$zero				#$s3 contem o valor do campo (ano)

	mult $s3,$s2					#O mês será transformado em dia. Para isso, é multiplicado o valor do mes em $t3, com o $t1 que tem o valor de 30
	mflo $t3						#Resultado em $s5
	sw $s3, vetorDespesa($s7)		#Armazenando o ($s3) no vetorDespesa, onde $s7 eh o ponteiro do vetor
	addi $s7,$s7,4					#Andando 4bytes

#************************************************************Cadastro campo Caracteres ******************************************************

	li $v0, 4						#Exibindo a msg7 (nome da despesa)
	la $a0, msg7
	syscall

	li $v0,8
	la $a0,vetorDespesa($s7)
	li $a1,16
	syscall
	addi $s7,$s7,16

#******************************************************** Cadastro campo Valor da despesa **************************************************

	li $v0, 4						#Exibindo a msg8 (Insira o valor)
	la $a0, msg8
	syscall

	li $v0,5						#Lendo o valor, que eh armazenado em $v0
	syscall

	sw $v0, vetorDespesa($s7)		#Armazenando o (valor) no vetorDespesa, onde $s7 eh o ponteiro do vetor
	addi $s7,$s7,4

#*********************************************************** Campo data convertido em dias ********************************************

	add $s1,$s1,$s5
	add $s5,$s1,$t3
	sw $s5, vetorDespesa($s7)
	addi $s7,$s7,4

	j menuOpcoes
#********************************************************************************************************************************************
#************************************************************* EXIBICAO DOS DADOS
#********************************************************************************************************************************************




exibirDados:


	add $s3, $zero,$zero
	add $s1,$zero,$s0
	add $s4,$zero,$zero
  loop7:
  beq $s1, $zero, menuOpcoes
#*********************************************************** Print ID ************************************************************
	li $v0, 4						#Exibindo a msg10 (Id)
	la $a0, msg10
	syscall

	li $v0, 1						#O codigo 1, eh utilizado para printar inteiros
	lw $s3,vetorAux($s3)
	lw $a0, vetorDespesa($s3)
	syscall
	addi $s3,$s3,4

#*********************************************************** Print Dia ************************************************************

	li $v0, 4						#Exibindo a msg11 (dia)
	la $a0, msg11
	syscall

	li $v0, 1						#O codigo 1, eh utilizado para printar inteiros
	lw $a0, vetorDespesa($s3)
	syscall
	addi $s3,$s3,4

#*********************************************************** Print mes ************************************************************

	li $v0,4						#Exibindo a msg12 (mes)
	la $a0, msg12
	syscall

	li $v0, 1						#O codigo 1, eh utilizado para printar inteiros
	lw $a0, vetorDespesa($s3)
	syscall
	addi $s3,$s3,4

#*********************************************************** Print ano ************************************************************

	li $v0,4						#Exibindo a msg13 (ano)
	la $a0, msg13
	syscall

	li $v0,1
	lw $a0, vetorDespesa($s3)
	syscall
	addi $s3,$s3,4

#*********************************************************** Print Caracteres ********************************************************

	li $v0,4
	la $a0, msg14
	syscall

	li $v0,4
	la $a0, vetorDespesa($s3)
	syscall
	addi $s3,$s3,16

#*********************************************************** Print valor ************************************************************

	li $v0,4						#Exibindo a msg15 (valor)
	la $a0, msg15
	syscall

	li $v0,1
	lw $a0, vetorDespesa($s3)
	syscall
	addi $s3,$s3,4

#*********************************************************** Data convertido em dias ****************************************************

	li $v0,4						#Exibindo a msg15 (valor)
	la $a0, msg16
	syscall

	li $v0,1
	lw $a0, vetorDespesa($s3)
	syscall
	addi $s3,$s3,4

	addi $s1,$s1,-1
	addi $s4,$s4,4
	add $s3,$s4,$zero
	j loop7


	#************************************************************** Ordenar por data ****************************************************************************



ordenarPorData:

	add $s6, $zero, $zero
	add $t7,$zero,$zero
	addi $t7,$zero,4
	mult $s0,$t7
	mflo $t7
	add $t2, $zero, $zero		#temporario para ordenar (i)
	add $t3, $zero, $zero		#temporario para ordenar (j)
	add $s1, $zero, $zero


	loop:                           #loop para salvar os enderecos no vetor auxiliar

		sw $s6,vetorAux($t2)    #salva o endereco do registro do vetorDespesa para o vetorAux
		addi $s6, $s6, 40       #anda para o proximo registro
		addi $t2, $t2, 4        #Incrementa o contador do loop
		slt $t4,$t2,$t7       #se o contador alcancou o numero de elementos ele sai do loop
		bne $t4, $zero, loop
		#reseta as variaveis para utiliza-las no bubble
    add $t2, $zero, $zero	#temporario para ordenar (i)
    add $t3, $zero, $zero		#temporario para ordenar (j)

	loop1:    #loop inicial do bubble
		add $t3, $zero, $zero		#temporario para ordenar (j)
		add $s6, $zero, $zero
		add $t5, $zero, $zero
		addi $t2, $t2, 1
		add $s1,$zero,$zero
		slt $t4, $t2, $s0 #k < n;
	  beq $t4, $zero, exibirDados


	loop2:    #segundo loop do bubble

		addi $t4, $s0, -1  # (n-1)
		slt $t4, $t3, $t4 # (j < n-1)
		beq $t4, $zero, loop1 # se a comparacao acima for falsa ele continua no loop2
		lw $s6, vetorAux($s1) #salva o endereço do vetor a ser comparado
		add $s6, $s6, 36 #anda até a casa da data no resgistro convertida para numero
		lw $t6, vetorDespesa($s6) #pega o valor da data do vetor
    	addi $t5,$s1,4
		lw $s6, vetorAux($t5) #salva o endereço do vetor a ser comparado
		add $s6, $s6, 36 #anda até a casa da data no resgistro convertida para numero
		lw $t4, vetorDespesa($s6) #pega o valor da data do vetor
		slt $t4, $t4, $t6 #if (vetor[j] > vetor[j + 1]) {
		beq $t4,$zero,incremento #se nao for > ele n entra no if e incrementa o j e vola para o loop2
		lw $t4, vetorAux($s1) # aux = vetor[j];
		addi $t5, $s1, 4 #j+1
		lw $t6, vetorAux($t5) #carrega o valor de vetor[j + 1];
		sw $t6, vetorAux($s1) #vetor[j] = vetor[j + 1];
		sw $t4, vetorAux($t5) #vetor[j + 1] = aux;


		incremento:
		addi $t3, $t3, 1  #incrementa o contador do loop (j++)
		addi $s1, $s1, 4
		j loop2


	# void bubble_sort_1 (int vetor[], int n) {
	#     int k, j, aux;
	#     for (k = 1; k < n; k++) {
	#         for (j = 0; j < n - 1; j++) {
	#             if (vetor[j] > vetor[j + 1]) {
	#                 aux          = vetor[j];
	#                 vetor[j]     = vetor[j + 1];
	#                 vetor[j + 1] = aux;
	#             }
	#         }
	#     }
	# }
	
	#************************************************************** Excluir despesa ****************************************************************************
	
	excluirDespesa:
	
		add $s1, $s0, $zero # $s1 tem a quantidade de vets (no de iteracoes) - usado pra remanejar
		
		beq $s1,$zero,SemDespesa
		
		li $v0,4 # Exibe mensagem do ID
		la $a0,msg17
		syscall
		
		li $v0,5
		syscall
		add $s3, $v0, $zero # $s3 tem o ID da despesa a excluir
		
		
		
		add $s2, $zero, $zero 
		
		add $t1, $zero, $zero # $t1 caminha na memoria
		
		add $t2, $zero, $zero # zera $t2
		
		addi $t2, $t2, 1 # usado para iterar e identificar o vetor com id a ser excluido
		
		add $t3,$zero,$zero
		addi $t3,$t3,1
		
		add $t4,$zero,$zero
		addi $t4,$t4,40
		
		add $s5,$zero,$zero # pos da regiao de mem p/ comecar a salvar novos dados depois de excluir o ultimo
		
		add $t5, $zero, $zero # salva diferenca entre numero total de vet e 
		
		add $t6, $zero, $zero
		addi $t6, $t6, 1
		
		add $t7,$zero,$zero
		
		
		AcharID:
			bne $t2,$t6,SomaPosMem

		ContinuaAcharID:
			lw $t7,vetorDespesa($t1)
			beq $s3,$t7,Remaneja
			
			addi $t2,$t2,1
			#sle $s2,$t2,$s1
			
			bgt $t2,$s1,NaoEncontrado
			bne $t2,$s1,AcharID
			
			addi $t1,$t1,40
			lw $t7,vetorDespesa($t1)
			beq $s3,$t7,Remaneja
			
			j NaoEncontrado
			
		SomaPosMem:
		
			addi $t1,$t1,40
			j ContinuaAcharID
			
		NaoEncontrado:
			li $v0,4
			la $a0,msg18
			syscall
			
			j menuOpcoes
				
		
		
		Remaneja:
			bne $t2,$s1,NaoEUltimo
			
		EUltimo:
			addi $s1, $s1,-1
			mult $s1,$t4				
			mflo $s5 # s5 tem a posicao (regiao de memoria) no vetorzao para comecar a salvar dados de novo
			
			add $s7,$s7,$zero
			add $s7,$zero,$s5 # Agora $s7 aponta para a mesma regiao de memoria que $s5
			# Posso manipular o vetorDespesas com $s7 no cadastro
			
			add $s0,$zero,$zero
			add $s0,$zero,$s1
			
			li $v0,4 # Exibe mensagem de excluido com sucesso
			la $a0,msg20
			syscall
			
			j menuOpcoes
				
		NaoEUltimo:
			add $t3,$zero,$zero
			add $t3,$zero,$t1 # t1 contem a casa do vetor com o id a excluir
			addi $t3,$t3,40 # t3 contem agora o proximo id de vetor para comecar a remanejar
			
			add $s4,$zero,$zero
			addi $s4,$s4,1
			
			add $s5,$zero,$zero
			add $t2,$zero,$zero
			add $t5,$zero,$zero
			
			sub $t0,$s1,$t2
			mult $t2,$t4
			mflo $s5
			
		troca:
			lw $t2,vetorDespesa($t3)
			sw $t2,vetorDespesa($t1)
			add $t5,$t5,1
			add $t1,$t1,4 # Ando 4 bytes
			add $t3,$t3,4 # Ando 4 bytes
			bne $t5,$t4,troca # Enquanto t5 e diferente de 40, faz a troca 
			
			
		ContDeslT1:
			bne $s4,$t0,IncS4
			j PosicionaParaCadastro
		
		IncS4:
			addi $s4,$s4,1
			add $t5,$zero,$zero
			j troca
		
		PosicionaParaCadastro:
			add $s7,$zero,$zero
			add $s7,$zero,$t1
			add $s0,$zero,$zero
			add $s1,$s1,-1
			add $s0,$s1,$zero
			
			li $v0,4 # Exibe mensagem de excluido com sucesso
			la $a0,msg20
			syscall
			
			j menuOpcoes
			
		SemDespesa:
			li $v0,4 # Exibe mensagem de erro
			la $a0,msg19
			syscall
			j menuOpcoes
			
	
	#********************************************************************************************************************************************
	#************************************************************* GASTO MENSAL
	#********************************************************************************************************************************************

	gastoMensal:
	addi $t0,$zero,1 #contador de meses
	addi $t3,$zero,13 #numero maximo de meses
	add $t2,$zero,$zero #soma dos valores
	add $s3,$zero,$zero # apontador de vertor
	add $s1,$zero,$s0 #copia a quantidade de registros para s1


	gastoMensalLoop:

	beq $s1,$zero,gastoMensalMsg#verificar se chego no fim do vetor se sim pula para gastoMensalMsg exibir mensagem
	addi $s1,$s1,-1
	addi $s3,$s3,4 # pula o id
	addi $s3,$s3,4 # pula o dia
 	lw $t5,vetorDespesa($s3)

  bne $t0,$t5, pulaValor # verifica se o mes for igual ao mes com o valor de t0 que vai de 1 a 12
	addi $s3,$s3,4 # pula o mes
	addi $s3,$s3,4 # pula o ano
	addi $s3,$s3,16 # pula nome
	lw $t4, vetorDespesa($s3) #salva o valor t4
	add $t2,$t2,$t4 #soma ao valor total desse mes
	addi $s3,$s3,4 # pula valor
	addi $s3,$s3,4 # pula valor da data em dias


	j gastoMensalLoop
	pulaValor:
	addi $s3,$s3,4 # pula o mes
	addi $s3,$s3,4 # pula o ano
	addi $s3,$s3,16 # pula nome

	addi $s3,$s3,4 # pula valor
  addi $s3,$s3,4 # proximo valor da data em dias
	j gastoMensalLoop

	gastoMensalMsg:
	li $v0,4						#Exibindo a msg12 (mes)
	la $a0, msg12
	syscall

	li $v0,1
	la $a0,($t0)
	syscall

	li $v0,4						#Exibindo a msg15 (valor)
	la $a0, msg15
	syscall

	li $v0,1
	la $a0,($t2)
	syscall

	add $t2,$zero,$zero #soma dos valores
	add $s3,$zero,$zero # apontador de vertor
	add $s1,$zero,$s0 #copia a quantidade de registros para s1

	gastoMensalCondicao:
	addi $t0,$t0,1
	beq $t0,$t3,menuOpcoes
	j gastoMensalLoop


	#********************************************************************************************************************************************
	#************************************************************* Exibir gasto por categoria
	#********************************************************************************************************************************************
	
	ordenarPorNome:

	add $s6, $zero, $zero
	add $t7,$zero,$zero
	addi $t7,$zero,4
	mult $s0,$t7
	mflo $t7
	add $t2, $zero, $zero		#temporario para ordenar (i)
	add $t3, $zero, $zero		#temporario para ordenar (j)
	add $s1, $zero, $zero


	loopAux:                           #loop para salvar os enderecos no vetor auxiliar

		sw $s6,vetorAux($t2)    #salva o endereco do registro do vetorDespesa para o vetorAux
		addi $s6, $s6, 40       #anda para o proximo registro
		addi $t2, $t2, 4        #Incrementa o contador do loop
		slt $t4,$t2,$t7         #se o contador alcancou o numero de elementos ele sai do loop
		bne $t4, $zero, loopAux
		#reseta as variaveis para utiliza-las no bubble
    	add $t2, $zero, $zero	#temporario para ordenar (i)
    	add $t3, $zero, $zero		#temporario para ordenar (j)

	loopBubble:    #loop inicial do bubble
		add $t3, $zero, $zero		#temporario para ordenar (j)
		add $s6, $zero, $zero
		add $t5, $zero, $zero
		addi $t2, $t2, 1
		add $s1,$zero,$zero
		slt $t4, $t2, $s0 #k < n;
	  	beq $t4, $zero, calculoContas


	loopBubble2:    #segundo loop do bubble

		addi $t4, $s0, -1  # (n-1)
		slt $t4, $t3, $t4 # (j < n-1)
		beq $t4, $zero, loopBubble # se a comparacao acima for falsa ele continua no loop2
		lw $s6, vetorAux($s1) #salva o endereço do vetor a ser comparado
		add $s6, $s6, 16 #anda até a casa da categoria
		la $t8, vetorDespesa($s6) #pega o endereço da categoria
    	addi $t5,$s1,4
		lw $s6, vetorAux($t5) #salva o endereço do vetor a ser comparado
		add $s6, $s6, 16 #anda até a casa categoria
		la $t9, vetorDespesa($s6) #pega o endereço da categoria


		cmploop:
		lb      $t6,($t8)                   # get next char from str1
    	lb      $t4,($t9)                   # get next char from str2
		bne     $t6,$t4,cmpne
		beq     $t6,$zero,incremento2
		beq     $t4,$zero,incremento2        # at EOS? yes, fly (strings equal)

    	addi    $t8,$t8,1                   # point to next char
    	addi    $t9,$t9,1                   # point to next char
    	j       cmploop

		cmpne:
		slt     $t4,$t4,$t6                 # char j > char j + 1
		beq 	$t4,$zero,incremento2 		#se nao for > ele n entra no if e incrementa o j e vola para o loop2
		
		lw $t4, vetorAux($s1) # aux = vetor[j];
		addi $t5, $s1, 4 #j+1
		lw $t6, vetorAux($t5) #carrega o valor de vetor[j + 1];
		sw $t6, vetorAux($s1) #vetor[j] = vetor[j + 1];
		sw $t4, vetorAux($t5) #vetor[j + 1] = aux;

		incremento2:
		addi $t3, $t3, 1  #incrementa o contador do loop (j++)
		addi $s1, $s1, 4
		j loopBubble2


	calculoContas:
		add $t2,$zero,$zero #i
		add $t3,$zero,$zero #endereço valor despesa
		add $t4,$zero,$zero 
		add $t5,$zero,$zero # i + j
		add $s4,$zero,$zero #soma 
		add $t7,$zero,$zero #flag
		add $s6,$zero,$zero #categoria

		loopWhile:
			bne $t7,$zero,jump				#flag é igual a 0? se não pula
			add $s6,$zero,$zero
			lw $s6,vetorAux($t4)			#pega o endereço salvo no vetorAux
			addi  $s6,$s6,16				#soma para chegar na categoria
			la $s3, vetorDespesa($s6) 		#pega o endereço da categoria
			addi  $s6,$s6,16  				#soma para chegar no endereço do valor
			lw $s4,	vetorDespesa($s6)		#carrega valor da despesa direto na soma			
			addi $t7,$t7,1 					#flag
			
			addi $t3, $s0, -1
			beq $t2,$t3,saiLoopWhile 		#chegou no final do vetor?

			jump:
			add $t8, $zero, $s3
			add  $s6,$zero,$zero
			addi $t5, $t4, 4				#t5 recebe i + 1, ou seja proximo registro
			lw $s6,vetorAux($t5)		#pega o endereço de vetorAux no registro i + j
			add $s6,$s6, 16	 			#soma para chegar na categoria
			la $t9, vetorDespesa($s6) 		#carrega endereço da segunda categoria
			

			cmploop2:
			lb $t1,($t8)                   # pega proximo caracter de i
			lb $t3,($t9)                   # pega proximo caracter de i + j
			bne $t1,$t3,cmpne2             # são diferentes? se sim sai

			beq $t1,$zero,cmpeq2           # é o final da string? se sim, strings iguais

			addi $t8,$t8,1                 # aponta para o proximo caracter
			addi $t9,$t9,1                 # aponta para o proximo caracter
			j cmploop2

			cmpeq2:
			add $s6,$s6,16					#soma para chegar no valor da despesa
			lw $t3,vetorDespesa($s6)		#pega o valor da despesa
			add $s4,$s4, $t3				#soma = soma + vet[i + 1][valorDespesa]
			addi $t3, $s0, -1
			addi $t5,$t2,1
			beq $t5,$t3,saiLoopWhile		#verifica se i + j era o ultimo elemento, se sim pula
			addi $t2,$t2,1					# i ++
			addi $t4,$t4,4
			add $s6,$zero,$zero
			j loopWhile	

			cmpne2:

			li $v0, 4						
			la $a0, msg9
			syscall

			li $v0,4
			move $a0, $s3
			syscall

			li $v0,1
			move $a0, $s4
			syscall

			addi $t2,$t2,1		# i ++
			addi $t4,$t4,4
			add $s4,$zero,$zero # soma
			add $t7,$zero,$zero #flag
			add $s6,$zero,$zero 
			j loopWhile	

		saiLoopWhile:
			li $v0, 4						
			la $a0, msg9
			syscall
			
			li $v0,4
			move $a0, $s3
			syscall

			li $v0,1
			move $a0, $s4
			syscall
			j loop7





	#********************************************************************************************************************************************
	#************************************************************* Exibir ranking de despesas
	#********************************************************************************************************************************************
	
	ordenarPorValor:

	add $s6, $zero, $zero
	add $t7,$zero,$zero
	addi $t7,$zero,4
	mult $s0,$t7
	mflo $t7
	add $t2, $zero, $zero		#temporario para ordenar (i)
	add $t3, $zero, $zero		#temporario para ordenar (j)
	add $s1, $zero, $zero


	loopCopia:                           #loop para salvar os enderecos no vetor auxiliar

		sw $s6,vetorAux($t2)    #salva o endereco do registro do vetorDespesa para o vetorAux
		addi $s6, $s6, 40       #anda para o proximo registro
		addi $t2, $t2, 4        #Incrementa o contador do loop
		slt $t4,$t2,$t7         #se o contador alcancou o numero de elementos ele sai do loop
		bne $t4, $zero, loopCopia
		#reseta as variaveis para utiliza-las no bubble
    	add $t2, $zero, $zero	#temporario para ordenar (i)
    	add $t3, $zero, $zero		#temporario para ordenar (j)

	loopBubble0:    #loop inicial do bubble
		add $t3, $zero, $zero		#temporario para ordenar (j)
		add $s6, $zero, $zero
		add $t5, $zero, $zero
		addi $t2, $t2, 1
		add $s1,$zero,$zero
		slt $t4, $t2, $s0 #k < n;
	  	beq $t4, $zero, calculoSomaCat


	loopBubble1:    #segundo loop do bubble

		addi $t4, $s0, -1  # (n-1)
		slt $t4, $t3, $t4 # (j < n-1)
		beq $t4, $zero, loopBubble0 # se a comparacao acima for falsa ele continua no loop2
		lw $s6, vetorAux($s1) #salva o endereço do vetor a ser comparado
		add $s6, $s6, 32 #anda até a casa da categoria
		la $t8, vetorDespesa($s6) #pega o endereço da categoria
    	addi $t5,$s1,4
		lw $s6, vetorAux($t5) #salva o endereço do vetor a ser comparado
		add $s6, $s6, 32 #anda até a casa categoria
		la $t9, vetorDespesa($s6) #pega o endereço da categoria

		
		lw $t6,($t8)                   
    	lw $t4,($t9)
		
		bne $t6, $t4, notEqual
		beq $t6, $t4, incrementar

		notEqual:
		slt     $t4,$t6,$t4                 # char j > char j + 1
		beq 	$t4,$zero,incrementar 		#se nao for > ele n entra no if e incrementa o j e vola para o loop2
		
		lw $t4, vetorAux($s1) # aux = vetor[j];
		addi $t5, $s1, 4 #j+1
		lw $t6, vetorAux($t5) #carrega o valor de vetor[j + 1];
		sw $t6, vetorAux($s1) #vetor[j] = vetor[j + 1];
		sw $t4, vetorAux($t5) #vetor[j + 1] = aux;

		incrementar:
		addi $t3, $t3, 1  #incrementa o contador do loop (j++)
		addi $s1, $s1, 4
		j loopBubble1


	calculoSomaCat:
		add $t2,$zero,$zero #i
		add $t3,$zero,$zero #endereço valor despesa
		add $t4,$zero,$zero 
		add $t5,$zero,$zero # i + j
		add $s4,$zero,$zero #soma 
		add $t7,$zero,$zero #flag
		add $s6,$zero,$zero #categoria

		loopWhile2:
			bne $t7,$zero,jump2				#flag é igual a 0? se não pula
			add $s6,$zero,$zero
			lw $s6,vetorAux($t4)			#pega o endereço salvo no vetorAux
			addi  $s6,$s6,16				#soma para chegar na categoria
			la $s3, vetorDespesa($s6) 		#pega o endereço da categoria
			addi  $s6,$s6,16  				#soma para chegar no endereço do valor
			lw $s4,	vetorDespesa($s6)		#carrega valor da despesa direto na soma			
			addi $t7,$t7,1 					#flag
			
			addi $t3, $s0, -1
			beq $t2,$t3,saiLoopWhile2 		#chegou no final do vetor?

			jump2:
			add $t8, $zero, $s3
			add  $s6,$zero,$zero
			addi $t5, $t4, 4				#t5 recebe i + 1, ou seja proximo registro
			lw $s6,vetorAux($t5)		#pega o endereço de vetorAux no registro i + j
			add $s6,$s6, 16	 			#soma para chegar na categoria
			la $t9, vetorDespesa($s6) 		#carrega endereço da segunda categoria
			

			cmploop3:
			lb $t1,($t8)                   # pega proximo caracter de i
			lb $t3,($t9)                   # pega proximo caracter de i + j
			bne $t1,$t3,cmpne3             # são diferentes? se sim sai

			beq $t1,$zero,cmpeq3           # é o final da string? se sim, strings iguais

			addi $t8,$t8,1                 # aponta para o proximo caracter
			addi $t9,$t9,1                 # aponta para o proximo caracter
			j cmploop3

			cmpeq3:
			add $s6,$s6,16					#soma para chegar no valor da despesa
			lw $t3,vetorDespesa($s6)		#pega o valor da despesa
			add $s4,$s4, $t3				#soma = soma + vet[i + 1][valorDespesa]
			addi $t3, $s0, -1
			addi $t5,$t2,1
			beq $t5,$t3,saiLoopWhile2		#verifica se i + j era o ultimo elemento, se sim pula
			addi $t2,$t2,1					# i ++
			addi $t4,$t4,4
			add $s6,$zero,$zero
			j loopWhile2	

			cmpne3:

			li $v0, 4						
			la $a0, msg9
			syscall

			li $v0,4
			move $a0, $s3
			syscall

			li $v0,1
			move $a0, $s4
			syscall

			addi $t2,$t2,1		# i ++
			addi $t4,$t4,4
			add $s4,$zero,$zero # soma
			add $t7,$zero,$zero #flag
			add $s6,$zero,$zero 
			j loopWhile2	

		saiLoopWhile2:
			li $v0, 4						
			la $a0, msg9
			syscall
			
			li $v0,4
			move $a0, $s3
			syscall

			li $v0,1
			move $a0, $s4
			syscall
			j loop7