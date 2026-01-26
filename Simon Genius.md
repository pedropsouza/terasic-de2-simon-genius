Gameplay

The original, or "Classic", version has four colored buttons, each producing a particular tone when it is pressed or activated by the device. A round in the game consists of the device lighting up one or more buttons in a random order, after which the player must reproduce that order by pressing the buttons. As the game progresses, the number of buttons to be pressed increases. (This is only one of the games on the device; there are actually other games on the original.)

Simon is named after the simple children's game of Simon Says, but the gameplay is based on Atari's unpopular Touch Me arcade game from 1974. Simon differs from Touch Me in that the Touch Me buttons were all the same color (black) and the sounds it produced were harsh and grating.

Simon's tones, on the other hand, were designed to always be harmonic,[5] no matter the sequence, and consisted of an A major triad in second inversion, resembling a trumpet fanfare:

    E (blue, lower right);
    C♯ (yellow, lower left);
    A (red, upper right).
    E (green, upper left, an octave lower than blue);

Some of the original 1978 models used an alternative set of tones, forming the B♭ minor triad:[16]

    B♭ (blue, lower right);
    D♭ (yellow, lower left);
    F (red, upper right).
    B♭ (green, upper left, an octave higher than blue);

The 1997 rerelease of Simon with a new, clear design

Simon was later re-released by Milton Bradley – now owned by Hasbro – in its original circular form, though with a translucent case rather than plain black. It was also sold as a two-sided Simon Squared version, with the reverse side having eight buttons for head-to-head play, and as a keychain (officially licensed by Fun4All) with simplified gameplay (only having Game 1, Difficulty 4, available). Other variations of the original game, no longer produced, include Pocket Simon and the eight-button Super Simon. Nelsonic released an official wristwatch version of Simon.[17]

Later versions of the game included a pocket version of the original game in a smaller, yellow, oval-shaped case. Another iteration, Simon Trickster, plays the original game as well as variations in which the colors shift around from button to button (Simon Bounce), the buttons have no colors at all (Simon Surprise) and the player must repeat the sequence backwards (Simon Rewind).[18] A pocket version of Simon Trickster was also produced.

In the 2014 version of Simon called Simon Swipe, the notes are as follows:

    G (blue, lower right);
    C (yellow, lower left);
    E (red, upper right).
    G (green, upper left, an octave higher than blue)

The swiping sounds are presented with sliding between notes. The bigger the slide, the bigger the swipe will be. The exact notes and sound effects were also used for a smaller version, called Simon Micro Series. The sounds were then recreated for Simon Air and Simon Optix.

--------------

2026-01-23: Comecei a escrever a testbench

Sei que a intenção é usar a saída de vídeo, mas pra começar
vamos usar os LEDS que acompanham os switches.

Decidi testar com 4 sinais digitais:
- clock
- vetor de entrada com o estado dos 4 botões
- vetor de saída para os 4 LEDS
- vetor de sinais de acerto ou erro, para emitir sons no futuro

Pesquisando sobre o sistema de áudio da placa DE2 descobri que ela usa I2C para transmitir samples para o chip de interface. Acho uma boa ideia acharmos um gist que já tenha um proof-of-concept implementado, vai nos poupar um tempão. Isso se o jogo que o professor colocou no e-aula não tenha algo implementado já.

Descobri também que existem algumas técnicas para gerar números aleatórios no Cyclone 2 usando TRNGs. Não sei qual podemos usar, mas nenhum deles parece ser muito custoso.

Talvez seja bom criar uma entidade que gere toda a sequência de botões e tempos de uma vez e guarde na memória, assim fica bem mais fácil de escrever um reprodutor de sequência e um avaliador de sequência separados. Vai ficar facinho de testar também.

--------------

2026-01-26: Achei uma implementação de LFSR para gerar números aleatórios.
Vou basear o gerador de sequências nesse [vídeo](https://youtu.be/AT8FgkTRW_E), não lembrava que a sequência era estendida ao longo do jogo.

Escrevi o gerador de sequências, e um testbench para verificar o funcionamento dele.
Eu não fiz a testbench assegurar nenhuma propriedade, só conferi o waveform resultante.

Inicializei um repositório git também, fiquei com medo de perder progresso.

subject: [[Sistemas Digitais Avançados]]
submit-url:https://e-aula.ufpel.edu.br/mod/assign/view.php?id=1728515
doc-url:[doc](file:///csem-uf/digsys/simon-genius/Propostas_trabalho_pratico_final.pdf
)
deps:
- [ ] TODO Simon Genius 📅 2026-02-20
desc: Proposta de protótipo de jogo no estilo "Simon Says" ou "Simon Genius"

