# Arkanoid em Assembly (simulador P3)

Jogo de quebrar blocos escrito inteiramente em assembly para o processador didático **P3**, executado no simulador **Simp3** (`p3sim.jar`). Tudo roda em baixo nível: o desenho da tela, a física da bola, a detecção de colisão, o placar e as vidas são feitos com registradores, memória e interrupções, sem nenhuma biblioteca.

O projeto nasceu na disciplina de Arquitetura de Computadores (Engenharia de Computação, CEFET/RJ).

```
|------------------------------------------------------------------------------|
|  Score: 030                      ARK4NOID                          Lifes: 3  |
|------------------------------------------------------------------------------|
|                                                                              |
|        [B] [B] [B]                                       [B] [B] [B]         |
|                               [B] [B] [B] [B]                                |
|        [B] [B] [B]                                       [B] [B] [B]         |
|                               [B] [B] [B] [B]                                |
|                                                                              |
|                                   o                                          |
|                                                                              |
|                                =============                                 |
|------------------------------------------------------------------------------|
```

## Como jogar

O simulador expõe os botões de interrupção numerados. O jogo usa quatro deles:

| Botão | Interrupção | Ação |
|-------|-------------|------|
| `1`   | `INT1`      | Move a nave para a esquerda |
| `2`   | `INT2`      | Move a nave para a direita |
| `3`   | `INT3`      | Reinicia a partida (depois do Game Over ou da vitória) |
| `4`   | `INT4`      | Pausa e retoma o jogo |

- Você começa com **3 vidas**. Se a bola passa da nave, perde uma.
- Cada bloco `[B]` destruído soma pontos no placar de três dígitos.
- Quebrar todos os blocos termina a fase com a mensagem de vitória.

## Como executar

Pré-requisitos: **Java 8 ou superior** e o montador da pasta `instalacoes_e_codigo/`.

```bash
cd instalacoes_e_codigo

# 1. Montar o código-fonte (gera arkanoid_jose_pereira.exe)
./p3as-linux arkanoid_jose_pereira.as        # Linux
p3as-win.exe arkanoid_jose_pereira.as        # Windows

# 2. Abrir no simulador
java -jar p3sim.jar arkanoid_jose_pereira.exe
```

No simulador, carregue o `.exe`, abra a janela de texto (terminal) e clique em **Run**. O jogo é desenhado nessa janela.

Há também um `Makefile` na raiz com os atalhos `make build` e `make run` para Linux.

## Como o código está organizado

O arquivo `arkanoid_jose_pereira.as` segue as quatro zonas padrão do assembly P3:

| Zona | Conteúdo |
|------|----------|
| I | Constantes (`EQU`): endereços de E/S, tamanhos da tela, símbolos, posições iniciais |
| II | Variáveis (`ORIG 8000h`): o mapa em texto, mensagens, posição e direção da bola, vidas e pontuação |
| III | Tabela de interrupções (`ORIG FE00h`): nave, reinício, pausa e timer |
| IV | Código: laço principal e as rotinas |

Rotinas principais:

- `Printchar`, `Printstring`, `PrintMapa`: escrevem na tela pelo cursor do simulador.
- `Timer` e `ConfigureTimer`: a interrupção 15 move a bola a cada tick.
- `movBola`: atualiza a posição da bola e testa paredes, teto e raquete.
- `VerificaBloco`, `TestaOrigem`, `QuebraBlocoB`, `QuebraBlocoEsq`, `QuebraBlocoDir`, `AlteraDirecao`: decidem se a bola bateu na lateral ou na face de um bloco, apagam as três células do bloco (`[`, `B`, `]`) e invertem a direção correta.
- `NaveEsq`, `NaveDir`: movem a raquete de 13 caracteres, respeitando as paredes.
- `Printscore`: converte a pontuação em centena, dezena e unidade e imprime em ASCII.
- `Restart`, `RestartGame`, `Pause`: estados do jogo.

A explicação detalhada de cada decisão está em [`docs/FUNCIONAMENTO.md`](docs/FUNCIONAMENTO.md).

## Conceitos praticados

- Registradores, pilha (`PUSH`/`POP`) e chamadas de sub-rotina (`CALL`/`RET`)
- Interrupções por hardware e tabela de vetores
- Entrada e saída mapeada em memória (cursor e porta de escrita)
- Aritmética inteira com `DIV` para extrair dígitos do placar
- Detecção de colisão discreta em uma grade de caracteres

## Estrutura do repositório

```
.
├── README.md
├── Makefile
├── docs/
│   └── FUNCIONAMENTO.md
└── instalacoes_e_codigo/
    ├── arkanoid_jose_pereira.as   # código-fonte do jogo
    ├── p3as-linux                 # montador (Linux)
    ├── p3as-win.exe               # montador (Windows)
    └── p3sim.jar                  # simulador P3
```
