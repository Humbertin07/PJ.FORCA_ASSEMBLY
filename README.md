![Capsule Render](https://capsule-render.vercel.app/api?type=waving&height=130&color=DAA520&text=💻%20Jogo%20da%20Forca%20com%20Assembly%20💻&section=header&reversal=false&fontSize=30&fontColor=EEE8AA&fontAlignY=65)

Este projeto consiste em um jogo da forca implementado em assembly. O jogo desafia os jogadores a descobrir uma palavra oculta, tentando adivinhar as letras corretas antes de exceder o número limite de tentativas.

## 📈 Objetivo 📈
O jogador deverá adivinhar a palavra que está armazenada na memória sem perder as vidas que ele tem. 

## 📚 Itens Utilizados 📚

### Tecnologias 👾

![AssemblyScript](https://img.shields.io/badge/assembly%20script-%23000000.svg?style=for-the-badge&logo=assemblyscript&logoColor=white)

### Materiais 🖌️

<div>
  <ul>
    <li>edSim 51</li>
    <li>Display LCD 16x2</li>
  </ul>
</div>

### Fluxograma 🔄

```mermaid
graph TD;

    Início[Início do Programa]
    Configurações[Configurações Iniciais]
    LEDs[Inicialização dos LEDs]

    LCD[Inicialização do LCD]
    Porta_Serial[Configuração da Porta Serial]
    Interrupção_Serial[Habilitação de Interrupção Serial]
    Contador_Temporizador[Início do Contador/Temporizador 1]
    Rotina_Interrupção[Rotina de Interrupção Serial]
    Escrita[Escrita]
    Comparação_Letra[Comparação de Letra]
    Funções_Auxiliares[Funções Auxiliares]
    
    Início --> Configurações
    Configurações --> LEDs
    LEDs --> LCD
    LCD --> Porta_Serial
    Porta_Serial --> Interrupção_Serial
    Interrupção_Serial --> Contador_Temporizador
    Contador_Temporizador --> Rotina_Interrupção
    Rotina_Interrupção --> Escrita
    Escrita --> Comparação_Letra
    Comparação_Letra --> Funções_Auxiliares

    subgraph Memórias
        posInicio((ORG 0000h))
        posPalavra((ORG 0040h))
    end

    Início --> posInicio
    Comparação_Letra --> posPalavra

```

## 🖥️ Código do Projeto 🖥️

O código também está disponível no repositório!

```asm

```

## 🕹️ Passo a Passo do Jogo 🕹️

- Assim que o jogo iniciar, o jogador deve inserir uma letra no UART e enviar.
- Caso tenha a letra na palavra, ela será inserida na primeira fileira.
- Caso não tenha a letra na palavra, ela será mostrada na segunda fileira e uma vida será perdida.
- O jogador deverá descobrir a palavra escondida sem perder todas as vidas.
- Caso não consiga, o jogo será finalizado.

## 🧑🏻‍💻 Autores do Projeto 🧑🏻‍💻

#### Anna Carolina Zomer ⬇️
[![E-mail](https://img.shields.io/badge/GitHub-181717.svg?style=for-the-badge&logo=GitHub&logoColor=white)](https://github.com/z0mer)

#### Humberto Pellegrini ⬇️
[![E-mail](https://img.shields.io/badge/GitHub-181717.svg?style=for-the-badge&logo=GitHub&logoColor=white)](https://github.com/Humbertin07)

![Capsule Render](https://capsule-render.vercel.app/api?type=waving&height=130&color=DAA520&text=👋🏻%20Até%20a%20Próxima!!%20👋🏻&section=footer&reversal=false&fontSize=30&fontColor=EEE8AA&fontAlignY=40)
