![Capsule Render](https://capsule-render.vercel.app/api?type=waving&height=130&color=DAA520&text=💻%20Jogo%20da%20Forca%20com%20Assembly%20💻&section=header&reversal=false&fontSize=30&fontColor=EEE8AA&fontAlignY=65)

Este projeto consiste em um jogo da forca implementado em assembly. O jogo desafia os jogadores a descobrir uma palavra oculta, tentando adivinhar as letras corretas antes de exceder o número limite de tentativas.

## 📈 Objetivo 📈
O jogador deverá adivinhar a palavra que está armazenada na memória sem perder as vidas que ele tem. 

## 🕹️ Passo a Passo do Jogo 🕹️

- Assim que o jogo iniciar, o jogador deve inserir uma letra no UART e enviar.
- Caso tenha a letra na palavra, ela será inserida na primeira fileira.
- Caso não tenha a letra na palavra, ela será mostrada na segunda fileira e uma vida será perdida.
- O jogador deverá descobrir a palavra escondida sem perder todas as vidas.
- Caso não consiga, o jogo será finalizado.

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

start([START])
LCD[[lcd_init]]
ROM[[escreveStringROM]]
cursor[[posicionaCursor]]
display[[clearDisplay]]
compara[[comparaLetra]]
send[[sendCharacter]]
aoba[FORCA]
r1[R1 = #00h]
r3[R3 = #00h]
r3f[R3 = #0FFh]
jmp[JMP $]
loop{loopComparacao}
verifica{verificaProximo}
fimcomp{fimComparacao}
fim[fimDoFim]
r7[R7 = 8]
r7f{R7 = 0}
fraco[FRACASSO]

start-->LCD-->cursor--->|primeiro passo|aoba
aoba-->ROM-->r1-->display-->jmp
jmp--->|entra letra UART - loop|compara
compara-->loop--->|vai e volta|verifica--->|até acabar a palavra|loop
verifica--->|letras corretas|cursor--->|imprime na primeira linha as letras correspondentes|send
send--->|espera uma nova letra no UART|jmp
loop--->|acabou a palavra|fimcomp-->r3--->|letras erradas e decrementa 1 ponto|cursor
cursor--->|imprime na segunda linha as letras não correspondentes|send
fimcomp-->r3f-->fim--->|espera a próxima letra no UART|jmp
cursor--->|imprime no LCD a pontuação|r7-->fimcomp
r7-->r7f-->display-->cursor-->fraco-->ROM-->display--->|reinicia|start

```

## 🖥️ Código do Projeto 🖥️

O código também está disponível no repositório!

```asm

```


## 🧑🏻‍💻 Autores do Projeto 🧑🏻‍💻

#### Anna Carolina Zomer ⬇️
[![E-mail](https://img.shields.io/badge/GitHub-181717.svg?style=for-the-badge&logo=GitHub&logoColor=white)](https://github.com/z0mer)

#### Humberto Pellegrini ⬇️
[![E-mail](https://img.shields.io/badge/GitHub-181717.svg?style=for-the-badge&logo=GitHub&logoColor=white)](https://github.com/Humbertin07)

![Capsule Render](https://capsule-render.vercel.app/api?type=waving&height=130&color=DAA520&text=👋🏻%20Até%20a%20Próxima!!%20👋🏻&section=footer&reversal=false&fontSize=30&fontColor=EEE8AA&fontAlignY=40)
