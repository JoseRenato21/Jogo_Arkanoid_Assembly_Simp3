;------------------------------------------------------------------------------
; ZONA I: Definição de constantes FINALIZADO
;------------------------------------------------------------------------------
WRITE                           EQU     FFFEh           
INITIAL_SP                      EQU     FDFFh           
CURSOR                          EQU     FFFCh           
CURSOR_INIT                     EQU     FFFFh           
TIMER_UNITS 	                EQU 	FFF6H
ACTIVATE_TIMER                  EQU		FFF7H
            ; -- simbolos --
FIM_TEXTO                       EQU     '@'             
CARAC_VAZIO	                    EQU		' '
NAV_CHAR                        EQU     '='
CARAC_BOLA                      EQU     'o'
CARACTER_ESQUERDA_BLOCO         EQU     '['
CARACTER_CENTRAL_BLOCO          EQU     'B'
CARACTER_DIREITA_BLOCO          EQU     ']'
            ; -- tela inicial --
LARGURA_TELA                    EQU      80d
LINHA_TOPO                      EQU       3d
PAREDE_ESQ                      EQU       1d
TAMANHO_LINHA_MAPA              EQU      81d

LINHA_SCORE                     EQU       1d
SCORE_INICIAL                   EQU       0d 
COLUNA_INICIAL_BOLA             EQU      39d    
LINHA_INICIAL_BOLA              EQU      19d
LIFE_MAX                        EQU      51d   ; 3 em ASCII
LIFE_LINHA                      EQU       1d
LIFE_COLUNA                     EQU      76d
PAREDE_DIR                      EQU      78d
TOTAL_LINHAS_MAPA               EQU      24d
            ; -- nave --
NAVE_INICIO                     EQU      33d
TAMANHO_NAV                     EQU      13d
LINHA_NAV	                    EQU		 22d
LINHA_ACIMA_NAV                 EQU      21d
PAREDE_DIR_RELACAO_NAV          EQU      65d   ; o tamanho nav é 13 entao 
            ; -- bloco_fantasma
FILEIRA_FANTASMA_INICIAL        EQU       3d
FILEIRA_FANTASMA_FINAL          EQU      13d
            ; -- direcoes --
DIREITA                         EQU		  1d 
CIMA                            EQU		 -1d
            ;teste_origem
HORIZONTAL                      EQU       1d
VERTICAL                        EQU       2d 
DIAGONAL                        EQU       3d
            ; -- timer --
VELOCIDADE                      EQU       2d
            ; -- score --
COLUNA_CENTENAS_SCORE           EQU      10d
TOTAL_BLOCOS_DISPONIVEIS        EQU      40d
CENTENA                         EQU     100d
DEZENA                          EQU      10d
BASE_ASCII                      EQU      48d
BASE_LIFE                       EQU      51d
PONTO                           EQU       5d

            ; -- game over/winner --
LINHA_MSG_RESTART               EQU      14d
COLUNA_MSG_RESTART              EQU      24d
COLUNA_MSG_LOOSE                EQU      35d
COLUNA_MSG_WIN                  EQU      27d
LINHA_MSG_WIN_LOOSE             EQU      15d
            ; -- auxiliares --
TRUE                            EQU       1d
FALSE                           EQU       0d
VERIFICA_PAR                    EQU       1d
VERIFICA_RESTO                  EQU       2d
PRINT_SHL_CONSTANT              EQU       8d
;------------------------------------------------------------------------------
; ZONA II: Definição de variáveis
;------------------------------------------------------------------------------
                    ORIG    8000h
linha0 	    	    STR 	'|------------------------------------------------------------------------------|', FIM_TEXTO
linha1 	    	    STR 	'|  Score: XYZ0                     ARK4NOID                          Lifes: 3  |', FIM_TEXTO
linha2 	    	    STR 	'|------------------------------------------------------------------------------|', FIM_TEXTO
linha3 	    	    STR 	'|                                                                              |', FIM_TEXTO
linha4 	    	    STR 	'|                                                                              |', FIM_TEXTO
linha5 	    	    STR 	'|        [B] [B] [B]                                       [B] [B] [B]         |', FIM_TEXTO
linha6 	    	    STR 	'|                               [B] [B] [B] [B]                                |', FIM_TEXTO
linha7 	    	    STR 	'|        [B] [B] [B]                                       [B] [B] [B]         |', FIM_TEXTO
linha8 	    	    STR 	'|                               [B] [B] [B] [B]                                |', FIM_TEXTO
linha9 	    	    STR 	'|        [B] [B] [B]                                       [B] [B] [B]         |', FIM_TEXTO
linha10     	    STR 	'|                               [B] [B] [B] [B]                                |', FIM_TEXTO
linha11 	        STR 	'|        [B] [B] [B]                                       [B] [B] [B]         |', FIM_TEXTO
linha12 	        STR 	'|                               [B] [B] [B] [B]                                |', FIM_TEXTO
linha13 	        STR 	'|                                                                              |', FIM_TEXTO
linha14 	        STR 	'|                                                                              |', FIM_TEXTO
linha15 	        STR 	'|                                                                              |', FIM_TEXTO
linha16 	        STR 	'|                                                                              |', FIM_TEXTO
linha17 	        STR 	'|                                                                              |', FIM_TEXTO
linha18 	        STR 	'|                                                                              |', FIM_TEXTO
linha19 	        STR 	'|                                                                              |', FIM_TEXTO
linha20 	        STR 	'|                                                                              |', FIM_TEXTO
linha21 	        STR 	'|                                                                              |', FIM_TEXTO
linha22 	        STR 	'|                                =============                                 |', FIM_TEXTO
linha23		        STR 	'|------------------------------------------------------------------------------|', FIM_TEXTO
        ; -- linha auxiliar --
WinnerMsg           STR     'Congratulations! You Win!!! ', FIM_TEXTO    
GameOverMsg         STR     'Game Over', FIM_TEXTO
RestartMsg          STR     'Aperte "R" para Reiniciar o Jogo', FIM_TEXTO
linhaSave1 	        STR 	'|                               [B] [B] [B] [B]                                |', FIM_TEXTO
linhaSave2 	        STR 	'|        [B] [B] [B]                                       [B] [B] [B]         |', FIM_TEXTO
        ; -- Movimento --
blocos_disponiveis  WORD    TOTAL_BLOCOS_DISPONIVEIS
navpos		        WORD	NAVE_INICIO
colunaBola          WORD    COLUNA_INICIAL_BOLA     ; Coluna atual da bola
linhaBola           WORD    LINHA_INICIAL_BOLA     ; Linha atual da bola
dirXBola            WORD    DIREITA      ; Direção X: 1=direita, -1=esquerda  
dirYBola            WORD    CIMA     ; Direção Y: -1=cima, 1=baixo
save_linha	        WORD 	FALSE
save_col	        WORD 	FALSE
game_state 	        WORD	TRUE
life		        WORD	LIFE_MAX
teste_origem        WORD    FALSE
pontuacao           WORD    SCORE_INICIAL
alg_centena         WORD    SCORE_INICIAL
alg_dezena          WORD    SCORE_INICIAL
alg_unidade         WORD    SCORE_INICIAL
linha_ghst_atual    WORD    FILEIRA_FANTASMA_INICIAL
;End_base_mem + Linha*quntCaracteres + col
                ;81*1 + 3(0,1,2,3)
            ;mul r1, r2 result no r2

;java -jar p3sim.jar arkanoid_jose_pereira.exe
;./p3as-linux.exe arkanoid_jose_pereira.as
;------------------------------------------------------------------------------
; ZONA III: Definição de tabela de interrupções
;------------------------------------------------------------------------------
            ORIG    FE00h
INT0        WORD    MinhaInterrupcao
INT1        WORD    NaveEsq
INT2        WORD    NaveDir
INT3        WORD    RestartGame      ; Interrupção 3: reinicia o jogo caso Game Over
INT4        WORD    Pause
            ORIG    FE0Fh
INT15       WORD    Timer           ; Interrupção 15: Timer principal
;------------------------------------------------------------------------------
; ZONA IV: Código principal
;------------------------------------------------------------------------------
            ORIG    0000h
            JMP     Main

;------------------------------------------------------------------------------
; PRINTCHAR
;------------------------------------------------------------------------------
; R1: CARACTERE A ESCREVER (vai para M[WRITE])
; R2: LINHA (cursor) entrada | (vira parte alta do CURSOR após SHL 8)
; R3: COLUNA (cursor) entrada | (vira parte baixa do CURSOR após OR)
;------------------------------------------------------------------------------
Printchar:  PUSH    R1
            PUSH    R2
            PUSH    R3

            SHL     R2, PRINT_SHL_CONSTANT           
            OR      R2, R3          
            MOV     M[CURSOR], R2   
            MOV     M[WRITE], R1    

            POP     R3
            POP     R2
            POP     R1
            RET
;------------------------------------------------------------------------------
; PRINTSTRING
;------------------------------------------------------------------------------
; R1: CARACTERE LIDO DA STRING (M[R4]) / usado para comparar com FIM_TEXTO e imprimir
; R2: LINHA NA TELA (cursor) entrada externa (não é salvo aqui!)
; R3: COLUNA NA TELA / índice que anda (incrementa a cada char impresso)
; R4: ENDEREÇO (ponteiro) da string a imprimir (incrementa para percorrer)
;------------------------------------------------------------------------------
Printstring:    PUSH    R1
                PUSH    R3
                PUSH    R4

LoopString:     MOV  R1, M[R4]
                CMP  R1, FIM_TEXTO
                JMP.z FimString
                CALL Printchar

                INC R4
                INC R3
                JMP LoopString

FimString:      POP R4
                POP R3
                POP R1
                RET
;------------------------------------------------------------------------------
;TIMER 
;------------------------------------------------------------------------------
; R1: AUXILIAR (salvo/restaurado)
;------------------------------------------------------------------------------
Timer:          PUSH R1

                CALL movBola

                CALL ConfigureTimer

                POP R1

                RTI

RestartGame:    PUSH  R1
                
                ;já reconfigura o modo de início do jogo
                MOV R1, TRUE                                    
                MOV M[game_state], R1   

                
                ; zera a pontuacao
                MOV R1, FALSE
                MOV M[pontuacao], R1
                MOV R1, BASE_LIFE
                MOV M[life], R1
                
                ; reposiciona nave
                MOV R1, NAVE_INICIO
                MOV M[navpos], R1

                ;bloco fantasma resolucao
                Call BlocoFant

                ; printa mapa já restaurado na memória e score
                CALL PrintMapa
                CALL Printscore


                CALL ConfigureTimer


endRestGame:    POP R1
                RTI

;------------------------------------------------------------------------------
; CONFIGURETIMER                
;------------------------------------------------------------------------------
; R1: AUXILIAR (carrega VELOCIDADE e game_state; escreve em TIMER_UNITS e ACTIVATE_TIMER)
;------------------------------------------------------------------------------
ConfigureTimer: PUSH R1
                    ;define a velocidade do clock e realmente liga o timer
                MOV  R1, VELOCIDADE
                MOV  M[TIMER_UNITS], R1
                MOV  R1, M[game_state]
                MOV  M[ACTIVATE_TIMER], R1
                POP  R1
                RET
;------------------------------------------------------------------------------
;BOLA 
;------------------------------------------------------------------------------
; R1: CHAR A SER ESCRITO
; R2: LINHA DA BOLA
; R3: COLUNA DA BOLA
; R4: DIREÇÃO EM X
; R5: DIREÇÃO EM Y
;------------------------------------------------------------------------------
movBola:    PUSH R1
            PUSH R2
            PUSH R3
            PUSH R4
            PUSH R5
            PUSH R6
            PUSH R7
            
            ; 1. Carrega posição e direção da bola
            MOV R2, M[linhaBola]   ; R2 = linha atual
            MOV R3, M[colunaBola]  ; R3 = coluna atual

            ; 2. Apaga a bola da posição atual
            MOV R1, CARAC_VAZIO
            CALL Printchar

            ; 3. Carrega direções para os registradores
            MOV R4, M[dirXBola] ; R4 = direção X
            MOV R5, M[dirYBola] ; R5 = direção Y

            CMP R3, PAREDE_ESQ
            JMP.z InverteX
            CMP R3, PAREDE_DIR
            JMP.z InverteX
            JMP ContinuaYCheck 

InverteX:   NEG R4 ; Inverte a direção X (-1 vira 1, 1 vira -1)
            MOV M[dirXBola], R4

            ; Colisão com parede de cima (logo abaixo do placar)
ContinuaYCheck: CMP R2, LINHA_TOPO
                JMP.z   InverteY

            CMP R2, LINHA_ACIMA_NAV
            JMP.nz NaoBateuRaquete

            ; inicio = navpos
            MOV R1, M[navpos]
            CMP R3, R1
            JMP.n NaoBateuRaquete      

            ; fim = navpos + TAMANHO_NAV - 1
            ADD R1, TAMANHO_NAV
            DEC R1                     
            CMP R3, R1
            JMP.p NaoBateuRaquete      

            JMP InverteY

            ; Verificação de Game Over (bola caiu no chão)
NaoBateuRaquete:    CMP R2, LINHA_NAV
                    JMP.nz AtualizaPosicao
                    MOV R1, CARAC_VAZIO
                    CALL Printchar
                    CALL Restart

                    JMP endMovB

InverteY:           NEG R5 ; Inverte a direção Y
                    MOV M[dirYBola], R5


AtualizaPosicao:    ADD R2, R5 ; novaLinha = linhaAtual + dirY
                    ADD R3, R4 ; novaColuna = colunaAtual + dirX
                    MOV M[save_linha], R2
                    MOV M[save_col], R3
                    CALL VerificaBloco


                    MOV R2, M[linhaBola]
                    MOV R3, M[colunaBola]
                    ADD R2, M[dirYBola]
                    ADD R3, M[dirXBola]
                    MOV M[linhaBola], R2
                    MOV M[colunaBola], R3
                    MOV R1, CARAC_BOLA
                    CALL Printchar


endMovB:            POP R7
                    POP R6
                    POP R5
                    POP R4
                    POP R3
                    POP R2
                    POP R1
                    RET

; ========================================
; FUNÇÕES AUXILIARES
; ========================================

;------------------------------------------------------------------------------
; BLOCO FANTASMA (BlocoFant)
;------------------------------------------------------------------------------
; R1: CARACTERE atual da linha salva / comparação com FIM_TEXTO
; R2: LINHA corrente do “ghost restore” e também endereço destino (ponteiro na linha0+offset)
; R4: PONTEIRO da linha “modelo” (linhaSave1/linhaSave2) para copiar
; R5: AUXILIAR de multiplicação (TAMANHO_LINHA_MAPA)
; R6: AUXILIAR geral (resto do DIV, char intermediário para copiar, constantes)
;------------------------------------------------------------------------------

BlocoFant:      PUSH R1
                PUSH R2
                PUSH R4
                PUSH R5
                PUSH R6    ;AUX

                MOV R2, FILEIRA_FANTASMA_INICIAL
                MOV M[linha_ghst_atual], R2        ; linha_ghst = 3 (uma antes)                      

FimlinhaF:      MOV R2, M[linha_ghst_atual]
                INC R2
                MOV M[linha_ghst_atual], R2         ; R2 = 4
                CMP R2, FILEIRA_FANTASMA_FINAL                         
                JMP.z FimStringF
                MOV R6, VERIFICA_RESTO  ; para ver o mod de R2
                MOV R4, R2     ; R6 = 2 , R4 = 4, R2 = 4
                DIV R4, R6      ;DIV resto -> op2, result -> op1 / R4 = 2, R6 = 0
                CMP R6, VERIFICA_PAR
                JMP.z LinhaPar
                
                MOV R4, linhaSave1
                MOV R5, TAMANHO_LINHA_MAPA
                MUL R5, R2
                ADD R2, linha0
                JMP LoopStringF

LinhaPar:       MOV R4, linhaSave2                         ;R4 = linha salva
                MOV R5, TAMANHO_LINHA_MAPA     ;R5 = 81
                MUL R5, R2              ;R2 = 4             
                ADD R2, linha0   ;R2 = linha3
                JMP LoopStringF

LoopStringF:    MOV  R1, M[R4]          ; R1 memoria da linha salva
                CMP  R1, FIM_TEXTO
                JMP.z FimlinhaF
                MOV R6, M[R4]
                MOV M[R2], R6

                INC R2
                INC R4
                JMP LoopStringF


FimStringF:     POP R6
                POP R5
                POP R4
                POP R2
                POP R1
                RET
;------------------------------------------------------------------------------
; RESTART
;------------------------------------------------------------------------------
; R1: VIDA (carrega, decrementa, compara com '0') / e também caractere para mensagens/bola
; R2: LINHA de impressão (vida/mensagens/bola)
; R3: COLUNA de impressão (vida/mensagens/bola)
; R4: PONTEIRO para string (GameOverMsg/WinnerMsg/RestartMsg)
; R5: AUXILIAR (usa para inverter dirYBola via registrador)
;------------------------------------------------------------------------------
Restart:        PUSH    R1
                PUSH    R2
                PUSH    R3
                PUSH    R4           
                PUSH    R5

                MOV     R1, M[life]
                DEC     R1
                MOV     M[life], R1

                MOV     R2, LIFE_LINHA
                MOV     R3, LIFE_COLUNA
                CALL    Printchar     

                MOV     R5, M[dirYBola]
                NEG     R5 ; Inverte a direção Y
                MOV     M[dirYBola], R5

                MOV     R2, LINHA_INICIAL_BOLA
                MOV     R3, COLUNA_INICIAL_BOLA
                MOV     M[linhaBola], R2
                MOV     M[colunaBola], R3

                CMP     R1, BASE_ASCII   ; BASE_ASCII = 48 ('0')
                JMP.z   DoGameOver      


                MOV     R1, CARAC_BOLA

                
                JMP     EndRestart

DoGameOver:     MOV     R1, FALSE                 ;  = 0
                MOV     M[game_state], R1
                MOV     M[ACTIVATE_TIMER], R1   ; para o temporizador 


                MOV     R2, LINHA_MSG_WIN_LOOSE
                MOV     R3, COLUNA_MSG_LOOSE
                MOV     R4, GameOverMsg
                CALL    Printstring

                MOV     R2, LINHA_MSG_RESTART
                MOV     R3, COLUNA_MSG_RESTART
                MOV     R4, RestartMsg
                CALL    Printstring
                JMP     EndGame

DoYouWin:       MOV     R1, FALSE                 ;  = 0
                MOV     M[game_state], R1
                MOV     M[ACTIVATE_TIMER], R1   ; para o temporizador 


                MOV     R2, LINHA_MSG_WIN_LOOSE
                MOV     R3, COLUNA_MSG_WIN
                MOV     R4, WinnerMsg
                CALL    Printstring

                MOV     R2, LINHA_MSG_RESTART
                MOV     R3, COLUNA_MSG_RESTART
                MOV     R4, RestartMsg
                CALL    Printstring
                JMP     EndGame

EndRestart:     POP     R5
                POP     R4
                POP     R3
                POP     R2
                POP     R1
                RET
;------------------------------------------------------------------------------
; ENDGAME (loop pós-fim)
;------------------------------------------------------------------------------
; (não usa registradores “funcionais”; só faz POPs do frame anterior e entra em loop)
;------------------------------------------------------------------------------
EndGame:        POP     R5
                POP     R4
                POP     R3
                POP     R2
                POP     R1

CycleWiner:     ENI     
                JMP CycleWiner
;------------------------------------------------------------------------------
; VERIFICABLOCO
;------------------------------------------------------------------------------
; R1: ENDEREÇO calculado do tile no mapa (linha0 + linha*81 + col)
; R2: (salvo) — aqui não é usado na lógica, mas preservado
; R6: LINHA alvo (save_linha) para calcular offset
; R7: AUXILIAR de multiplicação (81) e também CARACTERE lido do mapa (M[R1])
;------------------------------------------------------------------------------
VerificaBloco:      PUSH R1
                    PUSH R2
                    PUSH R6
                    PUSH R7
                    
                    MOV R6, M[save_linha]
					MOV	R7, TAMANHO_LINHA_MAPA
                    MUL R6, R7
                    MOV R1, R7
                    ADD R1, M[save_col]
                    ADD R1, linha0
                    MOV R7, M[R1]
                    
                    CMP R7, CARACTER_CENTRAL_BLOCO
                    CALL.z QuebraBlocoB
                    CMP R7, CARACTER_DIREITA_BLOCO
                    CALL.z QuebraBlocoDir
                    CMP R7, CARACTER_ESQUERDA_BLOCO
                    CALL.z QuebraBlocoEsq
                    


EndVerificaBloco:   POP R7
                    POP R6
                    POP R2
                    POP R1
                    RET             
;------------------------------------------------------------------------------
; TESTAORIGEM
;------------------------------------------------------------------------------
; R1: ENDEREÇO calculado (ponteiro) para checar vizinho / também valor final (DIAGONAL etc.)
; R6: LINHA base para cálculo (save_linha) e ajustes com dirY
; R7: AUXILIAR de multiplicação (81) e também CARACTERE lido do mapa (M[R1])
;------------------------------------------------------------------------------
TestaOrigem:        PUSH R6
                    PUSH R7
                    PUSH R1

; --- teste VERTICAL (colisão em cima/baixo) => checa (save_linha, save_col - dirX)
                    MOV R6, M[save_linha]
                    MOV R7, TAMANHO_LINHA_MAPA
                    MUL R6, R7
                    MOV R1, R7
                    ADD R1, M[save_col]
                    SUB R1, M[dirXBola]
                    ADD R1, linha0
                    MOV R7, M[R1]
                    CMP R7, CARAC_VAZIO
                    JMP.nz SetVertical        ; se não é vazio, então bateu no "vertical" => inverte Y

; --- teste HORIZONTAL (colisão na lateral) => checa (save_linha - dirY, save_col)
                    MOV R6, M[save_linha]
                    SUB R6, M[dirYBola]
                    MOV R7, TAMANHO_LINHA_MAPA
                    MUL R6, R7
                    MOV R1, R7
                    ADD R1, M[save_col]
                    ADD R1, linha0
                    MOV R7, M[R1]
                    CMP R7, CARAC_VAZIO
                    JMP.nz SetHorizontal      ; se não é vazio, então bateu no "horizontal" => inverte X

; --- diagonal (canto): aqui você decide a política
                    MOV R1, DIAGONAL
                    MOV M[teste_origem], R1
                    JMP EndTeste

SetVertical:        MOV R1, HORIZONTAL
                    MOV M[teste_origem], R1
                    JMP EndTeste

SetHorizontal:      MOV R1, VERTICAL
                    MOV M[teste_origem], R1

EndTeste:           POP R1
                    POP R7
                    POP R6
                    RET
;------------------------------------------------------------------------------
; QUEBRABLOCOB
;------------------------------------------------------------------------------
; R1: ENDEREÇO do tile central e variações (inc/dec) / também caractere para Printchar
; R2: LINHA de impressão do bloco (save_linha)
; R3: COLUNA de impressão do bloco (save_col) e deslocamentos (-1, +1)
; R6: AUXILIAR (CARAC_VAZIO para limpar memória / PONTO para somar score)
; R7: AUXILIAR (caractere lido do mapa / pontuação atual / CARAC_VAZIO)
;------------------------------------------------------------------------------
QuebraBlocoB:       PUSH R1
                    PUSH R2
                    PUSH R3
                    PUSH R6
                    PUSH R7
                    

                    MOV R6, M[save_linha]
					MOV	R7, TAMANHO_LINHA_MAPA
                    MUL R6, R7
                    MOV R1, R7
                    ADD R1, M[save_col]
                    ADD R1, linha0
                    MOV R7, M[R1]
                    MOV R6, CARAC_VAZIO
                    MOV M[R1], R6
                    INC R1
                    MOV M[R1], R6
                    DEC R1
                    DEC R1
                    MOV M[R1], R6

                    MOV R2, M[save_linha]
                    MOV R3, M[save_col]
                    
                    MOV R7, M[pontuacao]
                    MOV R6, PONTO
                    ADD R7, R6
                    MOV M[pontuacao], R7
                    CALL Printscore
                    

                    MOV R7, CARAC_VAZIO     ; R7 = caractere vazio
                    
                    ; Quebra o bloco [B]
                    DEC R3
                    MOV R1, R7
                    CALL Printchar          ; Apaga '['
                    
                    INC R3
                    MOV R1, R7
                    CALL Printchar          ; Apaga 'B'
                    
                    INC R3
                    MOV R1, R7
                    CALL Printchar          ; Apaga ']'
                    
                    NEG M[dirYBola]  ; Inverte Y diretamente

                    JMP     EndQB    ; Pula pro final
                    
;------------------------------------------------------------------------------
; QUEBRABLOCOESQ
;------------------------------------------------------------------------------
; R1: ENDEREÇO do tile (memória) e também caractere para Printchar
; R2: LINHA de impressão (save_linha)
; R3: COLUNA de impressão (save_col) e deslocamentos
; R6: AUXILIAR (caractere vazio, teste_origem lido)
; R7: AUXILIAR (multiplicador 81, pontuação, caractere vazio)
;------------------------------------------------------------------------------
QuebraBlocoEsq:     PUSH R1
                    PUSH R2
                    PUSH R3
                    PUSH R6
                    PUSH R7


                    CALL TestaOrigem

                    MOV R6, M[save_linha]
					MOV	R7, TAMANHO_LINHA_MAPA
                    MUL R6, R7
                    MOV R1, R7
                    ADD R1, M[save_col]
                    ADD R1, linha0
                    MOV R7, M[R1]
                    MOV R6, CARAC_VAZIO
                    MOV M[R1], R6
                    INC R1
                    MOV M[R1], R6
                    INC R1
                    MOV M[R1], R6
        
                    
                    ; Quebra o bloco [B]
                    MOV R2, M[save_linha]
                    MOV R3, M[save_col]
                    
                    MOV R7, M[pontuacao]
                    MOV R6, PONTO
                    ADD R7, R6
                    MOV M[pontuacao], R7
                    CALL Printscore

                    MOV R7, CARAC_VAZIO     ; R7 = caractere vazio
                    MOV R1, R7              ; R1 para printchar
                    CALL Printchar          ; Apaga '['
                    
                    INC R3
                    MOV R1, R7
                    CALL Printchar          ; Apaga 'B'
                    
                    INC R3
                    MOV R1, R7
                    CALL Printchar          ; Apaga ']'
                    
                    JMP     AlteraDirecao


                                    
;------------------------------------------------------------------------------
; QUEBRABLOCODIR
;------------------------------------------------------------------------------
; R1: ENDEREÇO do tile (memória) e também caractere para Printchar
; R2: LINHA de impressão (save_linha)
; R3: COLUNA de impressão (save_col) e deslocamentos
; R6: AUXILIAR (caractere vazio, teste_origem lido)
; R7: AUXILIAR (multiplicador 81, pontuação, caractere vazio)
;------------------------------------------------------------------------------
QuebraBlocoDir:     PUSH R1
                    PUSH R2
                    PUSH R3
                    PUSH R6
                    PUSH R7

                    CALL TestaOrigem        

                    MOV R6, M[save_linha]
					MOV	R7, TAMANHO_LINHA_MAPA
                    MUL R6, R7
                    MOV R1, R7
                    ADD R1, M[save_col]
                    ADD R1, linha0
                    MOV R7, M[R1]
                    MOV R6, CARAC_VAZIO
                    MOV M[R1], R6
                    DEC R1
                    MOV M[R1], R6
                    DEC R1
                    MOV M[R1], R6   



                    ; Quebra o bloco [B] em reverso
                    MOV R2, M[save_linha]
                    MOV R3, M[save_col]
                    MOV R7, M[pontuacao]
                    MOV R6, PONTO
                    ADD R7, R6
                    MOV M[pontuacao], R7
                    CALL Printscore

                    MOV R7, CARAC_VAZIO     ; R7 = caractere vazio
                    MOV R1, R7              ; R1 para printchar
                    CALL Printchar          ; Apaga ']'
                    
                    DEC R3
                    MOV R1, R7
                    CALL Printchar          ; Apaga 'B'
                    
                    DEC R3
                    MOV R1, R7
                    CALL Printchar          ; Apaga '['
                    
                    JMP     AlteraDirecao

;------------------------------------------------------------------------------
;ALTERA DIREÇOES DA BOLA
;------------------------------------------------------------------------------
AlteraDirecao:      MOV R6, M[teste_origem]

                    CMP R6, HORIZONTAL
                    JMP.Z   HorizontalCaso
                    JMP     FazInverteYE

HorizontalCaso:     NEG     M[dirYBola]
                    JMP     EndQB

FazInverteYE:       CMP R6, VERTICAL
                    JMP.Z   VerticalCaso
                    JMP     FazInverteXYE

VerticalCaso:       NEG     M[dirXBola]  
                    JMP     EndQB
                    
FazInverteXYE:      NEG M[dirYBola]
                    NEG M[dirXBola]
                                

EndQB:              POP R7
                    POP R6
                    POP R3
                    POP R2
                    POP R1
                    RET

;------------------------------------------------------------------------------
;NAVE
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; NAVEESQ (INT1)
;------------------------------------------------------------------------------
; R1: CARACTERE a escrever (NAV_CHAR ou CARAC_VAZIO)
; R2: LINHA fixa da nave (LINHA_NAV)
; R3: COLUNA (posição atual da nave / posição onde escreve)
;------------------------------------------------------------------------------
NaveEsq:    PUSH R1
            PUSH R2
            PUSH R3

            MOV 	R3, M[navpos]       ;COLUNA ATUAL
            CMP 	R3, PAREDE_ESQ
            JMP.z 	EndMovE             ;pega pos nave e verifica se esta na dentro  -------

            MOV		R1, NAV_CHAR
            MOV 	R2, LINHA_NAV
            DEC 	R3
            CALL 	Printchar

            MOV 	R1, CARAC_VAZIO
            ADD     R3, TAMANHO_NAV 
            CALL    Printchar
            DEC     M[navpos]


EndMovE:    POP		R3
            POP		R2
            POP		R1
            RTI

;------------------------------------------------------------------------------
; NAVEDIR (INT2)
;------------------------------------------------------------------------------
; R1: CARACTERE a escrever (CARAC_VAZIO ou NAV_CHAR)
; R2: LINHA fixa da nave (LINHA_NAV)
; R3: COLUNA (posição atual da nave / posição onde escreve)
;------------------------------------------------------------------------------
NaveDir:    PUSH R1
            PUSH R2
            PUSH R3
           

			MOV 	R3, M[navpos]       ;COLUNA ATUAL
			CMP 	R3, PAREDE_DIR_RELACAO_NAV   ; -13 pois a contagem da posicao é no lado esquerdo
			JMP.z 	EndMovR             

			MOV		R1, CARAC_VAZIO
			MOV 	R2, LINHA_NAV
			CALL 	Printchar

            MOV 	R1, NAV_CHAR
            ADD     R3, TAMANHO_NAV
            CALL    Printchar
			INC 	M[navpos]
            

EndMovR:	POP		R3
			POP		R2
			POP		R1
			RTI 
;------------------------------------------------------------------------------
; PAUSE
;------------------------------------------------------------------------------
; R1: liga e desliga o timer
;------------------------------------------------------------------------------
Pause:      PUSH R1

            MOV     R1, M[game_state]
            CMP     R1, TRUE
            JMP.nz  DesPause
            MOV     R1, FALSE
            MOV     M[game_state], R1
            CALL    ConfigureTimer
            JMP     EndPause

DesPause:   MOV     R1, TRUE    
            MOV     M[game_state], R1
            CALL    ConfigureTimer


EndPause:   POP R1
            RTI
;------------------------------------------------------------------------------
; PRINTMAPA
;------------------------------------------------------------------------------
; R1: (salvo) — não é usado diretamente na lógica
; R2: LINHA atual de impressão (0..23)
; R3: COLUNA inicial (0) para Printstring
; R4: PONTEIRO para a string da linha atual (linha0, linha1, ...)
; R5: CONTADOR de linha (0..TOTAL_LINHAS_MAPA-1)
;------------------------------------------------------------------------------
PrintMapa:		PUSH 	R1
				PUSH 	R2
                PUSH    R3
				PUSH 	R4
				PUSH 	R5

				MOV     R4, linha0          ; R6 armazena o endereço da string atual, começando com linha0
        		MOV     R5, FALSE              ; R5 é o contador de linha (começa em 0)

PrintLoop:		CMP     R5, TOTAL_LINHAS_MAPA ; Já imprimiu as 24 linhas (0 a 23)?
        		JMP.z   EndPrintLoop        ; Se sim, sai do loop

        		MOV     R2, R5              ; Define a linha de impressão (0, 1, 2, ...)
        		MOV     R3, FALSE           ; Define a coluna de impressão como 0
        		CALL    Printstring              ; Chama a rotina para imprimir a string

        		ADD     R4, TAMANHO_LINHA_MAPA  ; Avança o ponteiro para a próxima string (80 chars + 1 terminador = 81 palavras)
        		INC     R5                  ; Incrementa o contador de linha
        		JMP     PrintLoop           ; Repete o loop

EndPrintLoop:   POP 	R5
				POP 	R4
                POP     R3
				POP 	R2
				POP 	R1
				RET
;------------------------------------------------------------------------------
; PRINTSCORE
;------------------------------------------------------------------------------
; R1: AUXILIAR geral
; - decrementa blocos_disponiveis
; - carrega pontuacao
; - guarda centena (alg_centena)
; - depois vira caractere ASCII para imprimir
; R2: AUXILIAR do DIV
; - primeiro CENTENA (divisor) e depois vira “resto”/parcial p/ extrair dezena/unidade
; R3: COLUNA de impressão do score (vai incrementando para centena/dezena/unidade)
; R4: BASE_ASCII (48) para converter dígito em caractere
;------------------------------------------------------------------------------
Printscore: PUSH 	R1
			PUSH 	R2
            PUSH    R3
			PUSH 	R4

            MOV     R1, M[blocos_disponiveis]
            DEC     R1
            MOV     M[blocos_disponiveis], R1

            MOV     R1, M[pontuacao]
            MOV     R2, CENTENA
            DIV     R1,R2
            MOV     M[alg_centena], R1
            MOV     R1, DEZENA
            DIV     R2, R1
            MOV     M[alg_dezena], R2
            MOV     M[alg_unidade], R1

            MOV R1, M[alg_centena]
            MOV R4, BASE_ASCII
            ADD R1, R4
            MOV R2, LINHA_SCORE
            MOV R3, COLUNA_CENTENAS_SCORE
            CALL  Printchar

            MOV R1, M[alg_dezena]
            MOV R4, BASE_ASCII
            ADD R1, R4
            INC R3
            CALL  Printchar

            MOV R1, M[alg_unidade]
            MOV R4, BASE_ASCII
            ADD R1, R4
            INC R3
            CALL  Printchar

            MOV     R1, M[blocos_disponiveis]
            CMP     R1, FALSE
            JMP.z  DoYouWin


            POP 	R4
            POP     R3
            POP 	R2
            POP 	R1
            RET
;------------------------------------------------------------------------------
;______________________MAIN_________________________
;------------------------------------------------------------------------------
Main:       ENI                     ; Habilita interrupções
            MOV     R1, INITIAL_SP
            MOV     SP, R1          
            MOV     R1, CURSOR_INIT
            MOV     M[CURSOR], R1   
            CALL    PrintMapa
            CALL    ConfigureTimer

            
Ciclo:      BR      Ciclo           

MinhaInterrupcao: RTI

Halt:   BR      Halt