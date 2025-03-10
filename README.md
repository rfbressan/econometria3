---
from: markdown+emoji
---
# Bem-vindos a Econometria III

Neste curso você aprenderá algumas das principais ferramentas atualmente utilizadas em ***microeconometria***. Modelos com dados em painel, regressão com efeitos-fixos, diferença-em-diferenças, modelos de equações simultâneas, variáveis instrumentais e mínimos quadrados em dois estágios (MQ2E) e, modelos com variável dependente limitada.
 
Você também aprenderá a usar a linguagem de programação `Python` para fazer as manipulações de dados, estimações e testes de hipóteses, entretanto, este **não** é um curso de `Python` e uma leitura complementar é sugerida. 

Este material é baseado no trabalho da equipe `ScPoEcon`, de `Edward Rubin`, de `Nick CH K` e o devido crédito é dado. O material foi traduzido para português e levemente adaptado para o ensino de econometria no Brasil. Os decks de slides originais podem ser encontrados em [ScPoEconometrics-Slides](https://github.com/ScPoEcon/Advanced-Metrics-slides), [EC 421](https://github.com/edrubin/EC421S19) e, [Nick](https://github.com/NickCH-K/EconometricsSlides)


## Pré-requisitos

Você precisa ter feito os cursos de Econometria I e II na Esag (ou equivalente). Você também é incentivado durante o curso a se familiarizar com o conhecimento de [`Python`](https://www.python.org/) para aproveitar ao máximo todo o conteúdo ofertado neste curso.

## Visão geral

Continuamos com nossa abordagem prática para aprender Econometria e `Python`. Conheceremos um importante método para estabelecer relações casuais em dados não experimentais, chamado de “Variáveis Instrumentais”. Aprenderemos sobre dados em painel, ou seja, dados que rastreiam indivíduos ao longo do tempo. Veremos situações em que nossos variáveis dependentes são de natureza discreta, como “sujeito *i* escolhe a opção A (e não B)”, além de modelos de equações simultâneas, onde duas variáveis dependentes são determinadas concomitantemente.


## Programa e slides

Observe que várias dessas aulas se estendem por duas ou mais sessões.

| Tópico | Slides | Lista | Laboratório |
|--------|--------|-------|-------------|
| Apresentação da Disciplina | [HTML](https://raw.githack.com/rfbressan/econometria3/main/2024-2/lectures/Aula0-Apresentacao.html) | [HTML](https://raw.githack.com/rfbressan/econometria3/main/2024-2/psets/Questoes_revisao.html)  |  |
| Aula 1: Causalidade | [HTML](https://raw.githack.com/rfbressan/econometria3/main/2024-2/lectures/01-causalidade/01-causality_pt.html) |  | [Github Copilot](https://raw.githack.com/rfbressan/econometria3/main/2024-2/labs/01_lab_intro_github.html) |
| Aula 2: Variáveis Instrumentais | [HTML](https://raw.githack.com/rfbressan/econometria3/main/2024-2/lectures/02-IV/02-IV_pt.html) | [HTML](https://raw.githack.com/rfbressan/econometria3/main/2024-2/psets/Questoes_causalidade_vi.html) | [Variáveis Instrumentais](https://raw.githack.com/rfbressan/econometria3/main/2024-2/labs/02_lab_VI.html)               |
| Aula 3: Modelos de Equações Simultâneas | [HTML](https://raw.githack.com/rfbressan/econometria3/main/2024-2/lectures/03-simultaneas/03-simultaneas_pt.html) | [HTML](https://raw.githack.com/rfbressan/econometria3/main/2024-2/psets/Questoes_Simultaneas.html)    | [Equações Simultâneas](https://raw.githack.com/rfbressan/econometria3/main/2024-2/labs/03_lab_Simultaneas.html) |
| Aula 4: Dados em Painel - Efeitos Fixos | [HTML](https://raw.githack.com/rfbressan/econometria3/main/2024-2/lectures/04-panel/04-panel_pt.html)             | [HTML](https://raw.githack.com/rfbressan/econometria3/main/2024-2/psets/Questoes_Painel.html)         | [Painel e Efeitos Fixos](https://raw.githack.com/rfbressan/econometria3/main/2024-2/labs/04_lab_Painel_EF.html) |
| Aula 5: Dados em Painel - Diferenças em Diferenças | [HTML](https://raw.githack.com/rfbressan/econometria3/main/2024-2/lectures/05-DID/05_DID_pt.html)                 | [HTML](https://raw.githack.com/rfbressan/econometria3/main/2024-2/psets/Questoes_DID.html)            | [Diferenças em Diferenças](https://raw.githack.com/rfbressan/econometria3/main/2024-2/labs/05_lab_DID.html)     |
| Aula 6: Modelos de Escolha Qualitativa | [HTML](https://raw.githack.com/rfbressan/econometria3/main/2024-2/lectures/06-logit/06-logit_pt.html) | [HTML](https://raw.githack.com/rfbressan/econometria3/main/2024-2/psets/Questoes_Probit.html)         | [Escolha Qualitativa](https://raw.githack.com/rfbressan/econometria3/main/2024-2/labs/06_lab_Probit.html)       |



## :books: Bibliografia Recomendada

* WOOLDRIDGE, Jeffrey M. Introdução à econometria: uma abordagem moderna. São Paulo: Cengage Learning, 2016. Tradução da 4ª edição norte-americana por José Antonio Ferreira. 

* GUJARATI, Damodar N.; PORTER, Dawn C. Econometria básica. Porto Alegre: Amgh Editora, 2011. - 5. ed. 

* BÉKÉS, Gábor; KÉZDI, Gábor. Data analysis for business, economics, and policy. Cambridge University Press, 2021.

* GERTLER, Paul J. et al. Avaliação de Impacto na Prática, 2018. - 2. ed. Banco Mundial.

* PEIXOTO, Betânia et al. Avaliação econômica de projetos sociais. Fundação Itaú Social, 3ª ed, 2017.

* CUNNINGHAM, Scott. Causal Inference: The Mixtape, New Haven: Yale University Press, 2021. URL: https://mixtape.scunning.com/

* ANGRIST, Joshua D.; PISCHKE, Jörn-Steffen. Mastering'metrics: The path from cause to effect. Princeton university press, 2014. URL: http://www.masteringmetrics.com/

* ANGRIST, Joshua D.; PISCHKE, Jörn-Steffen. Mostly harmless econometrics: An empiricist's companion. Princeton university press, 2009.

* WOOLDRIDGE, Jeffrey M. Econometric Analysis of Cross Section and Panel Data. MIT press, 2010. Second Edition. 

* HANSEN, Bruce E. Econometrics. Manuscript, revision of February 2020.

**Programação**

* [Coding for Economists](https://aeturrell.github.io/coding-for-economists/intro.html)

**R**

* [Introdução ao R](http://www.lampada.uerj.br/introducaoaor)
* [Data science for economists](https://github.com/uo-ec607/lectures)
* [R Core Team. An Introduction to R](https://cran.r-project.org/doc/manuals/r-release/R-intro.html)
* [Introduction to Econometrics with R](https://www.econometrics-with-r.org/)
* [Using R for Introductory Econometrics](http://urfie.net/)
* [R for data science: import, tidy, transform, visualize, and model data](https://r4ds.had.co.nz/)
* [Introduction to R by Sievertsen](https://hhsievertsen.shinyapps.io/r_introduction/)
* [Applied Economics with R](https://hhsievertsen.github.io/applied_econ_with_r/)
* [Big book of R](https://www.bigbookofr.com/index.html)

**Stata**

* [The Stata workflow guide](https://medium.com/the-stata-guide/the-stata-workflow-guide-52418ce35006)
* [Coding and do-file structure](https://github.com/michaelstepner/healthinequality-code/tree/main/code)
* [Stata Cheatsheets](https://www.stata.com/bookstore/stata-cheat-sheets/)
* [Customizing Stata Graphs](https://repec.sowi.unibe.ch/files/wp30/Jann-2018-grstyle-set.pdf)
* [Microeconometrics Using Stata](https://cameron.econ.ucdavis.edu/musbook/MUS2_Draft_Contents_November_2020.pdf)
* [Tips for managing large-scale datasets efficiently in Stata](https://www.peretaberner.eu/tips-for-managing-large-scale-datasets-efficiently-in-stata/)

**Python**

* [Python for Econometrics](https://pyecon.org/down/pyecon.pdf)
* [QuantEcon Lectures](https://quantecon.org/lectures/)
* [Introduction to Python for Econometrics, Statistics and Data Analysis](https://www.kevinsheppard.com/teaching/python/notes/)
* [Using Python for Introductory Econometrics](http://urfie.net/)

**LaTeX**

* [LaTex Table Hints and Tips](https://statatexblog.com/wp-content/uploads/2013/09/tabletricks_latex.pdf)

## Videos

* [Causal Data Science](https://www.youtube.com/watch?v=MguFFgUfcbc&list=PLSMHA74lM-x3NTV2vJoxWdB1qdsSMjcFL&index=1&t=5603s) Causal Data Science com Marcel Ribeiro Dantas (Sorbonne University)

* [Introdução Latex](https://www.youtube.com/watch?v=EumeZnyvTzA&list=PLSMHA74lM-x3NTV2vJoxWdB1qdsSMjcFL&index=2&t=3213s) Introdução Latex

* [Economia e Ciência de Dados](https://www.youtube.com/watch?v=6Q3SXs5agaU&list=PLSMHA74lM-x2VglhXkdbHEH80T2a_XgRr&index=2&t=4765s) Economia e Ciência de Dados com prof. Rafael Martins de Souza (FGV/EPGE)

* [Carreira e Aplicações de Econometria](https://www.youtube.com/watch?v=VKZe49nNtxw&list=PLSMHA74lM-x2VglhXkdbHEH80T2a_XgRr&index=3&t=2182s) Carreira e Aplicações de Econometria com Luiz A. Esteves (Economista chefe do Banco do Nordeste)

* [VSCode](https://www.youtube.com/@code)

* [A First Look at Using Python for Econometrics](https://www.youtube.com/watch?v=kltX6XofxG0)

## Outros Recursos

* [Introduction to Causal Inference](https://www.bradyneal.com/causal-inference-course) by Brady Neal

* [Course in Econometrics - part II](https://www.youtube.com/playlist?list=PLwJRxp3blEvb7P-7po9AxuBwquPv75LjU) Course in Econometrics - part II by Ben Lambert

* [Coletânea de cursos de Econometria](https://giuseppecavaliere.wixsite.com/giuseppe/econometrics-courses)

* [Econometrics Course](https://www.youtube.com/playlist?list=PLOQU3c_3DSpLTBa0vqPFVwDCqXlXiu49j)

* [ECON407](https://econ.pages.code.wm.edu/407/notes/docs/index.html)

* [Microsoft's Experimentation](https://www.microsoft.com/en-us/research/group/experimentation-platform-exp/)

* [Booking.datasience](https://booking.ai)

* [Causal AI papers](https://www.causalens.com/causal-ai-papers/)

* [Coding for Economists (Python)](https://aeturrell.github.io/coding-for-economists/intro.html)

* [Mathematics for Economics](https://www.economicsnetwork.ac.uk/maths_refresher/)

* [Causal ML Book](https://causalml-book.org/) por Chernozhukov et al.

* [Machine Learning & Causal Inference: A Short Course](https://www.gsb.stanford.edu/faculty-research/labs-initiatives/sil/research/methods/ai-machine-learning/short-course)

## Replicação de Artigos

- [Como acessar o Portal de Periódicos CAPES](https://www.youtube.com/watch?v=MXtNSpS-3Cc)

- [Angrist Dataverse](https://dataverse.harvard.edu/dataverse/JAngrist)

- [Replication Wiki](https://replication.uni-goettingen.de/wiki/index.php/Main_Page)

- [openICPSR](https://www.openicpsr.org/openicpsr/)

- [American Economic Association](https://www.aeaweb.org/journals)

- [Base dos Dados](https://www.basedosdados.org/)

## Avaliação

O sistema de avaliação da disciplina se dará da seguinte maneira:

- 1 Lista de exercícios de revisão valendo 10% da nota final.

- 2 Provas escritas, presenciais, com os seguintes pesos: 30% e 30%.

- 1 Trabalho econométrico individual de cunho prático com 30% de peso.

- É obrigatória a frequência em no mínimo 75% das aulas para aprovação.

## Legal

Você pode copiar e adaptar este material para seus propósitos, contanto que dê os devidos créditos e compartilhe o trabalho nos mesmos termos. Claro que você pode usar os slides para ensinar em suas salas de aula. *Crédito Apropriado* significa que em algum lugar em seus slides há um link para o repositório [original](https://github.com/ScPoEcon/Advanced-Metrics-slides), [EC 421](https://github.com/edrubin/EC421S19) e, [NickCH-K](https://github.com/NickCH-K/EconometricsSlides) indicando que é sobre aqueles trabalhos que você está construindo. Clique no ícone para detalhes.

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
