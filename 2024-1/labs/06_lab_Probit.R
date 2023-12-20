#' ---
#' title: Aula de laboratório - Escolha Qualitativa
#' author: Rafael Bressan
#' ---
#'
#+ echo=TRUE
library(wooldridge)
library(fixest)
library(modelsummary)
library(ggplot2)
#' ## Modelo de Probabilidade Linear
#'
#' Vamos analizar participação na força de trabalho de mulheres casadas com os dados
#' `mroz` do pacote `wooldridge`. Nossa variável dependente será o status de
#' participação na força de trabalho, $inlf\in\{0, 1\}$.
#'
#' Se uma variável _dummy_ é usada como variável dependente, nós podemos usar
#' MQO para estimar a relação desta com os regressores normalmente. A
#' probabilidade condicional de ocorrência do evento é:
#'
#' $$P(y=1|x)=E[y|x]=\beta_0 + \beta_1 x$$
#'
#' A interpretação dos coeficientes é direta, um aumento de uma unidade em
#' $x$ provoca um aumento médio na probabilidade do evento de $\beta_1$. Modelos
#' MPL sofrem de heterocedasticidade e, portanto, devemos utilizar erros padrão
#' robustos.
data("mroz")
#' **Cheque a estrutura dos dados com uma tabela de estatísticas descritivas. Qual a diferença para a aula de laboratório anterior?**
#+ echo=TRUE
datasummary(All(mroz) ~ Ncol + NUnique + Mean + SD,
    data = mroz
)
#' Agora faça a regressão da _dummy_ de presença na força de trabalho em relação
#' as seguintes variáveis: nwifeinc, educ, exper, exper^2, age, kidslt6, kidsge6
#+ echo=TRUE
fml <- inlf~nwifeinc + educ + exper + I(exper^2) + age + kidslt6 + kidsge6
mpl <- feols(fml,
    data = mroz,
    vcov = "HC1"
)
msummary(mpl)
#'
#' Por construção, um modelo MPL pode render previsão de probabilidade fora do
#' intervalo $\left[0,1\right]$ para uma certa combinação de regressores (que
#' pode ser realista ou não).
#'
#' Como exemplo, supomos duas mulheres, a primeira com 20 anos, sem experiência,
#' 5 anos de educação, 2 crianças com menos de 6 anos e renda de $ 100
#' (em milhares). A segunda mulher possui 52 anos, 30 anos de experiência e
#' 17 de educação, sem crianças e renda.
#'
#' **Faça a previsão de probabilidade de estarem no mercado de trabalho para
#' ambas hipotéticas mulheres.**
#+ echo=TRUE
xpred <- data.frame(
    nwifeinc = c(100, 0),
    educ = c(5, 17),
    exper = c(0, 30),
    age = c(20, 52),
    kidslt6 = c(2, 0),
    kidsge6 = c(0, 0)
)
predict(mpl, newdata = xpred)
#'
#' ## Modelos Logit e Probit
#'
#' Estes são modelos especializados em variáveis dependentes binárias e,
#' portanto, não sofrem do problema de predição de probabilidade fora do
#' intervalo $\left[0,1\right]$. A um indexador linear, estes modelos aplicam
#' uma função (não-linear) que garante $y\in \left[0,1\right]$. Esta é chamada
#' de função _link_.
#'
#' * no modelo **probit** a função link é $G(z)=\Phi(z)$, a função de
#' distribuição da Normal, e;
#'
#' * no modelo **logit** a função link é $G(z)=\Lambda(z)=\frac{\exp(z)}{1+\exp(z)}$,
#' a função de distribuição Logística.
#'
#' Desta forma, a probabilidade do evento é definida como:
#'
#' $$P(y=1|x)=G(\beta_0 + \beta_1 x)$$
#'
#' No `R` estimamos esses modelos através da função `glm`, de _Generalized
#' Linear Models_, especificando o argumento `family`. Vejamos um exemplo.
#'
logit <- glm(fml,
    data = mroz,
    family = binomial(link = logit)
)

probit <- glm(fml,
    data = mroz,
    family = binomial(link = probit)
)

msummary(list(Logit = logit, Probit = probit))
#'
#' Uma forma visual de apresentar os resultados de uma regressão é através de
#' um gráfico de coeficientes (coefficients plot). Este gráfico mostra a estimativa
#' pontual acompanhada de uma barra denotando o intervalo de confiança (e.g. 90%).
#' É muito utilizado em apresentações sobre a pesquisa ou estudo sendo realizada.
modelplot(list(Logit = logit, Probit = probit),
    conf_level = 0.9
)
#'
#' Podemos fazer a previsão da probabilidade das mesmas mulheres anteriores estarem no
#' mercado de trabalho.
#'
predict(logit, newdata = xpred, type = "response")
predict(probit, newdata = xpred, type = "response")
#'
#' As previsões de logit e probit são semelhantes, mas especialmente nas caudas
#' elas podem diferirem de forma significativa. O comando `predict` também
#' pode retornar o valor do índice linear ($\hat\beta_0 + \hat\beta_1 x_i$)
#' quando o argumento for type = "link"
#'
predict(logit, newdata = xpred, type = "link")
predict(probit, newdata = xpred, type = "link")
#'
#' **Simule valores para o índice linear entre -5 e 5 e plote qual seriam as
#' respostas em probabilidades dos modelos logit e probit.**
#+ echo=TRUE
index <- seq(-5, 5, by = 0.5)
logit_response <- plogis(index)
probit_response <- pnorm(index)
df <- data.frame(index, logit_response, probit_response)

ggplot(df, aes(x = index)) +
    geom_line(aes(y = logit_response, color = "Logit")) +
    geom_line(aes(y = probit_response, color = "Probit")) +
    guides(color = guide_legend(title = "Modelo")) +
    labs(
        x = "Índice linear",
        y = "Probabilidade",
        title = "Resposta em Probabilidade"
    ) +
    theme_classic()
#'
#' ## Efeitos Parciais
#'
#' Os parâmetros de modelos não-lineares como logit e probit não possuem uma
#' interpretação direta dos efeitos _ceteris paribus_ do regressor sobre a
#' variável dependente. Uma medida utilizada é o efeito parcial (ou efeito
#' marginal) que é dependente do ponto $x_i$ em que se faz a análise. Este
#' efeito marginal é equivalente a inclinação da curva de resposta do modelo
#' em um determinado ponto.
#'
#' \begin{align}
#' \frac{\partial\hat y}{\partial x}&=\frac{\partial G(x\hat\beta)}{\partial x}\\
#' &=\hat\beta \cdot g(x\hat\beta)
#' \end{align}
#'
#' Onde é possível verificar que o efeito marginal depende tanto do valor
#' estimado $\hat\beta$ quanto do ponto onde se faz a análise, $x$. O fato
#' de este efeito diferir por valor do regressor faz com que seja difícil
#' apresentar os resultados de uma maneira concisa. Adota-se, em geral, duas
#' medidas de efeito parcial:
#'
#' * Efeito Parcial na Média (PEA): $PEA(X_j)=g(\bar{x} \beta) \beta_j$
#'
#' * Efeito Parcial Médio (APE): $APE(X_j)=\frac{1}{n} \sum_{i=1}^N g(x_i \beta) \beta_j$
#'
#' **Calcule manualmente o PEA do modelo logit**
#+ echo=TRUE
# Ponto médio dos regressores
regressors <- c("nwifeinc", "educ", "exper", "age", "kidslt6", "kidsge6")
x_mean <- mroz[, regressors] |>
    colMeans()
betas <- coef(logit)
# x_mean deve conter 1 na primeira posicao e exper^2 na quinta
x_mean <- c(1, x_mean[1:3], mean(mroz[, "exper"]^2), x_mean[4:6])
# xb
index_mean <- sum(x_mean * betas)
# Agora o PEA
print("PEA de cada regressor é:")
dlogis(index_mean) * betas

# usando o pacote mfx
mfx::logitmfx(fml, data = mroz, atmean = TRUE)
#'
#' **Calcule manualmente o APE do modelo logit**
#+ echo=TRUE
g_mean <- predict(logit) |>
    dlogis() |>
    mean()
print("APE de cada regressor é:")
betas * g_mean
# usando o pacote mfx
mfx::logitmfx(fml, data = mroz, atmean = FALSE)
