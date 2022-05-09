### Structure and Interpretation of Computer Programs

Procurando referências para aprender Ciência da Computação com mais rigor/profundidade, acabei encontrando o site https://teachyourselfcs.com/ e foi daqueles sites que salvei no favorito e sempre dou umas olhadinhas nas referências de lá, embora seja super curtinho.

Iniciei minha jornada pelo primeiro tópico, "Programação", com o livro "Structure and Interpretation of Computer Programs" (SICP). Li, assisti aulas e resolvi mais de 300 exercícios (estes aqui!) por conta própria em um período de aproximadamente 5 meses.

E minha mente realmente deu uma explodida lendo este livro. 

Durante a vida universitária nós estudamos com muitos livros, lemos muitas coisas, resolvemos muitos exercícios, mas sempre tem algo que se separa do restante, talvez por termos tido um bom professor ou talvez pelo livro em si ser muito bom. Como li o livro por conta (tive o apoio das aulas online do Professor Brian Harvey), é o caso da segunda opção.

Primeiro que o livro passou obviamente pelo teste do tempo: primeira edição em 1984, segunda edição em 1996. Isso é algo que vem me convencendo mais e mais ultimamente. Coisas que são úteis em qualquer época sem precisar de buzzwords ou apelo financeiro ("{leia este livro}/{faça este curso} e aumente seu salário em até 100%"). 

Segundo que o livro trata de algo que é ainda um passo antes de algoritmos: linguagens de programação no geral. Me convenci particularmente por conta da seguinte passagem:

*Why? Because SICP is unique in its ability - at least potentially - to alter your fundamental beliefs about computers and programming. Not everybody will experience this. Some will hate the book, others won't get past the first few pages. But the potential reward makes it worth trying.*

E realmente valeu a pena.

Para ser bem honesto com o livro e explicar realmente o quão impressionante ele é, eu teria que copiar todas as palavras dele aqui, o que me daria um Copyright Infringement. Sigo com minhas palavras, definitivamente piores que as dos autores de SICP.

Vou deixar aqui algumas das ideias mais legais que vi no livro:
- Abstração, abstração, abstração:  rapidamente percebemos que programas de computador crescem muito rapidamente. Usamos abstrações SEMPRE que podemos para não pensar no programa em termos do que o computador nos oferece, e sim no problema que queremos resolver.
- First-class procedures: os procedimentos (procedures) podem ser tratados como um DADO, ou seja, podem ser passados como argumentos para outros procedimentos, retornados de procedimentos, nomeados ou agregados (como em um par), i.e., podem ser cidadãos de primeira classe. (inserir exemplo simples).
- Por outro lado, dados podem ser tratados como PROCEDIMENTOS: Quando definimos o que é um par (um agregado de 2 "coisas"), a construção e seleção dos elementos desses pares não precisam ser algo "mágico" dado pela linguagem. Eles podem (e são) ser implementados como procedimentos!
- De 2 e 3 ganhamos que: realmente não há divisão entre o que são dados e o que é código. Dados são códigos, e códigos são dados.
- Recursão: isso aparece inúmeras vezes no livro, muitas vezes disfarçado, muitas vezes bem explícito. Porém fica muito mais interessante quando aprendemos sobre interpretadores, compiladores. Tem inclusive uma nota de rodapé que apresenta muito naturalmente o Y-Combinator para mostrar como implementar recursão em uma linguagem que não suporta recursão naturalmente, usando apenas cálculo lambda. É de arrepiar.
- Cálculo lambda: o livro definitivamente não trata sobre isso especificamente, mas foi meu primeiro contato com o tema, e senti que implementar o Y-Combinator no papel foi muito legal.
- Normal order, applicative order e environment model of evaluation.
- Paradigmas de programação: programação funcional, programação orientada à objetos e programação declarativa. O mais legal é que você começa utilizando programação funcional e o livro explica o conceito de environments ao mesmo tempo que utiliza pela primeira vez os procedimentos "set!" no capítulo 3 para alterar o estado de uma variável (até então nada tinha utilizado estados mutáveis). Quando você se dá conta não só utilizou a programação orientada à objetos (OOP), e sim criou uma versão da linguagem que aceita OOP, basicamente do zero (utiliza aqui o poder dos first-class procedures).
- Programação funcional: assim como em uma função matemática, para entradas iguais em seu procedimento (ou seja, utilizando exatamente os mesmo argumentos) a saída também deve ser a mesma, sempre. 
- Programação orientada à objetos: apenas no segundo capítulo que somos introduzidos
- Paralelismo:
- Deadlock:
- Streams: 
- Memoização: em algoritmos, quando utilizamos uma recursão, às vezes calculamos o mesmo subproblema diversas vezes, e isso pode ser evitado salvando esse valor já calculado em uma tabela. Basicamente "programação dinâmica" é o uso de "divisão e conquista" + "memoização". O livro não fala especificamente da técnica de "divisão e conquista", mas a usa inúmeras vezes.
- Interpretadores: EVAL+APPLY
- Compiladores:

Acho que o principal é entender que as linguagens de programação servem para que os programas que escrevemos reflitam o problema que estamos tratando e não como os computadores funcionam.

### Outras avaliações
Para complementar, algumas outras avaliações sobre o SICP:

*SICP was revolutionary in many different ways. Most importantly, it dramatically raised the bar for the intellectual content of introductory computer science. Before SICP, the first CS course was almost always entirely filled with learning the details of some programming language. SICP is about standing back from the details to learn big-picture ways to think about the programming process. It focused attention on the central idea of abstraction - finding general patterns from specific problems and building software tools that embody each pattern.*
http://people.eecs.berkeley.edu/~bh/sicp.html#:~:text=SICP%20is%20about%20standing%20back,tools%20that%20embody%20each%20pattern.
