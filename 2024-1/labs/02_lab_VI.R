#' ---
#' title: Aula de laboratório - Variáveis Instrumentais
#' author: Rafael Bressan
#' ---
#' 
#' # Retornos da educação para mulheres casadas
#' 
#' Vamos analizar os retornos de educação para mulheres casadas com os dados 
#' `mroz` do pacote `wooldridge`. Filtraremos para usar somente as observações
#' que onde salário não seja faltante. Como variável instrumental para educação
#' usaremos a educação do pai. Você acha que este é um bom instrumento? Por quê?
#' 
library(wooldridge)
library(fixest)
library(ggplot2)
library(data.table)
library(modelsummary)

data("mroz")

df <- mroz[!is.na(mroz$wage), ]
#' 
#' **Crie uma tabela com as estatíticas descritivas dos dados**
#' 
#+ echo=FALSE
datasummary(All(df)~Ncol+NUnique+Mean+SD+Min+Median+Max,
                          data = df)
#' ## Regressão simples
#' 
#' Estimamos primeiro um MQO simples com a função `feols` do pacote `fixest`.
#' 
s_ols <- feols(lwage~educ, data = df) 
#' 
#' Leia a ajuda da função `feols` (?feols) e descubra como especificar um 
#' modelo de variáveis instrumentais (IVs). 
#' 
#' **Em seguida rode a regressão com `fatheduc` como instrumento para `educ`.**
#' 
#+ echo=FALSE
iv_ols <- feols(lwage~1 | educ ~ fatheduc, data = df)
#' 
#' Apresente os resultados das duas regressões lado a lado em uma tabela
#' 
etable(list(OLS = s_ols, VI = iv_ols))
#' 
#' ## Adicionando regressores exógenos
#' 
#' A abordagem de variáveis instrumentais pode facilmente ser estendida para
#' a inclusão de outros regressores exógenos na regressão.
#' 
#' Inclua em ambas as regressões anteriores os regressores experiência (`exper`)
#' e experiência ao quadrado (`expersq`). Faça também um modelo de MQ2E
#' **manualmente** e apresente os resultados.
#+ echo=FALSE
s_ols <- feols(lwage~educ+exper+expersq, data = df) 
iv_ols <- feols(lwage~exper+expersq | educ ~ fatheduc, data = df)
stage_1 <- feols(educ~exper+expersq+fatheduc, data = df)
mq2e_df <- df
mq2e_df$pred_educ <- fitted(stage_1)
stage_2 <- feols(lwage~pred_educ+exper+expersq, data = mq2e_df)
etable(list(OLS = s_ols, MQ2E = stage_2, VI = iv_ols))
#'
#' ## Teste de endogeneidade de Hausman
#' 
#' Tanto MQO quanto MQ2E serão consistentes se todas as variáveis forem 
#' exógenas. Se os estimadores diferirem de forma significativa, concluímos
#' que o regressor era de fato endógeno (qual hipótese estamos fazendo aqui?).
#' 
#' Portanto, é sempre uma boa ideia calcular tanto o MQO quanto o MQ2E e 
#' compará-los. Para determinar se as estimativas são estatisticamente 
#' diferentes, então um teste de regressão é mais adequado. O teste de Hausman
#' faz esse papel.
#' 
#' O teste é separado em dois passos:
#' 
#' 1) estime a forma reduzida de variável endógena e salve os resíduos
#' 
#' 2) inclua estes resíduos como um regressor adicional na equação estrutural
#' 
#' Um teste t ou F no coeficiente dos resíduos nos fornecerá evidência sobre a
#' endogeneidade do regressor caso rejeite-se a hipótese nula.
#' 
#' **Implemente o teste de Hausman**
#+ echo=FALSE
mq2e_df$resid_educ <- residuals(stage_1)
hausman <- feols(lwage~educ+exper+expersq+resid_educ, data = mq2e_df)
summary(hausman)
#'
#' ## Teste de restrições sobreidentificadoras
#' 
#' Se temos mais instrumentos válidos que variáveis endógenas, a princípio
#' pode-se usar qualquer ou todos os instrumentos. Se todos forem de fato 
#' válidos, então, usar todos trará ganhos de eficiência no estimador MQ2E.
#' 
#' 1) Estime a equação estrutural por MQ2E, usando mais instrumentos que 
#' variáveis endógenas, e salve os resíduos $\hat u_1$
#' 
#' 2) Regrida $\hat u_1$ em todas as variáveis exógenas e salve o $R^2$ desta 
#' regressão
#' 
#' 3) Sob a hipótese nula de que todas as VI são exógenas, a estatística de teste 
#' $n R^2$ é assintoticamente distribuída como uma Qui-quadrado com $q$ graus de
#' liberdade, onde $q$ é a diferença entre o número de instrumentos e de 
#' variáveis endógenas.
#' 
#' **Faça o teste de restrições sobreidentificadoras considerando que a educação da mãe (`motheduc`) também é um instrumento váldio para educação.**
#+ echo=FALSE
sobre_iv <- feols(lwage~exper+expersq|educ~fatheduc+motheduc, data = df)
sobre_df <- df
sobre_df$resid <- residuals(sobre_iv)
resid_reg <- feols(resid~exper+expersq+fatheduc+motheduc, data = sobre_df)
n <- nobs(resid_reg)
r2 <- r2(resid_reg, type = "r2")
sobre_stat <- n*r2
pchisq(sobre_stat, df = 1, lower.tail = FALSE)
