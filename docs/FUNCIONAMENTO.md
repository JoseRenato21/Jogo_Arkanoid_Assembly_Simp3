# Funcionamento do jogo

## Mapa e memória

A tela é uma grade de 80 colunas por 24 linhas. Cada linha é uma string terminada em `@` (`FIM_TEXTO`) guardada a partir do endereço `8000h`. Como cada linha ocupa 81 posições (80 caracteres mais o terminador), o endereço de um caractere é:

```
endereço = base_do_mapa + linha * 81 + coluna
```

Esse cálculo é a base de toda colisão: para saber o que existe na célula seguinte da bola, o programa lê a memória do mapa em vez de consultar a tela.

## Bola

`colunaBola` e `linhaBola` guardam a posição. `dirXBola` e `dirYBola` valem `1` ou `-1` e são somadas a cada tick. A cada passo, `movBola`:

1. Apaga a bola da posição atual.
2. Testa as paredes laterais e inverte `dirXBola` se necessário.
3. Testa o teto (`LINHA_TOPO`) e inverte `dirYBola`.
4. Na linha logo acima da nave, verifica se a coluna da bola está dentro da raquete (`navpos` até `navpos + 12`). Se sim, inverte `dirYBola`. Se a bola chega à linha da nave sem ter batido, chama `Restart`, que desconta uma vida e recoloca a bola no ponto inicial.
5. Consulta o mapa para ver se a próxima célula é parte de um bloco.
6. Desenha a bola na nova posição.

## Blocos

Cada bloco ocupa três células: `[`, `B` e `]`. Quando a bola bate em qualquer uma delas, `VerificaBloco` descobre qual parte foi atingida e chama `QuebraBlocoB`, `QuebraBlocoEsq` ou `QuebraBlocoDir`. A rotina apaga as três células, atualiza o placar com `Printscore` e `AlteraDirecao` escolhe qual eixo inverter.

`TestaOrigem` classifica a colisão como horizontal, vertical ou diagonal (`HORIZONTAL`, `VERTICAL`, `DIAGONAL`) comparando de onde a bola veio. Isso evita que a bola atravesse um bloco ao bater de lado.

O contador `blocos_disponiveis` cai a cada bloco quebrado. Quando chega a zero, `Printscore` desvia para `DoYouWin`.

## Nave

A raquete tem 13 caracteres (`TAMANHO_NAV`) e fica na linha 22. `NaveEsq` e `NaveDir` apagam a ponta que sai, desenham a ponta que entra e atualizam `navpos`, parando nas paredes.

## Interrupções

| Vetor | Rotina | Função |
|-------|--------|--------|
| `INT0` | `MinhaInterrupcao` | Reservada (retorna imediatamente) |
| `INT1` | `NaveEsq` | Nave para a esquerda |
| `INT2` | `NaveDir` | Nave para a direita |
| `INT3` | `RestartGame` | Reinicia o jogo |
| `INT4` | `Pause` | Pausa e retoma |
| `INT15` | `Timer` | Passo do jogo (move a bola) |

O laço principal (`Ciclo: BR Ciclo`) não faz nada. Todo o jogo é dirigido por interrupções, o que deixa o movimento da bola independente da velocidade com que o jogador aperta as teclas. O timer dispara uma vez por vez: a rotina `Timer` chama `movBola` e rearma o temporizador com `ConfigureTimer`, que grava `VELOCIDADE` em `TIMER_UNITS` e o estado do jogo em `ACTIVATE_TIMER`. Com `game_state` zerado, o timer não rearma e o jogo para.

## Placar e vidas

A pontuação é um inteiro. Para imprimir, `Printscore` divide por `CENTENA` e `DEZENA` com `DIV`, soma `BASE_ASCII` (48) a cada dígito e escreve nas colunas do placar. As vidas ficam em `life` como caractere ASCII (`LIFE_MAX` vale 51, o caractere `3`), o que permite imprimir direto sem conversão.

## Estados

`game_state` indica se o jogo está rodando. Quando a bola cai, `Restart` decrementa `life`, redesenha o contador e, se ele chegar ao caractere `0`, entra em `DoGameOver`: zera `game_state`, desliga o timer e imprime as mensagens de fim. `DoYouWin` faz o mesmo ao quebrar o último bloco. Já `RestartGame` (interrupção 3) restaura vidas, pontuação e posição da nave, recompõe o mapa a partir das linhas salvas (`linhaSave1` e `linhaSave2`, pela rotina `BlocoFant`) e rearma o timer.
