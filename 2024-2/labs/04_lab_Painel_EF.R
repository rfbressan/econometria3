#' ---
#' title: Aula de laboratório - Efeitos Fixos
#' author: Rafael Bressan
#' ---
#' 
#' ## Organizando dados em painel 
#' 
#' $y_{it}=\beta_0+\beta_1 x_{it}+v_{it};$ com $t=1,\ldots , T$ e 
#' $i=1,\ldots , n$. Denotamos $nT=N$, o número total de observações do painel.
#' 
#' Dados em painel são melhor organizados no formato "longo" onde cada linha
#' corresponde a uma combinação de $i$ e $t$. Nós temos de definir qual das
#' variáveis corresponde a $i$ e qual será representante de $t$. Podemos fazer
#' isso com o pacote `plm`.
#' 
library(plm)
library(fixest)
library(wooldridge)

data(crime4)

#' Os dados `crime4` já estão organizados no formato longo, e possui as
#' variáveis indicando o indivíduo (`county`) e o tempo (`year`). O painel é 
#' balanceado. Neste caso podemos transformar os dados em painel indicando 
#' estas colunas para o argumento index. 
crime4_p <- pdata.frame(crime4, index = c("county", "year"))
pdim(crime4_p)
#'
#' ## Cálculos típicos de painel
#' 
#' Uma vez com os dados organizados em painel, o pacote `plm` fornece uma série
#' de funções úteis para fazer as transformações que são típicas em econometria 
#' de dados em painel: _lag_, diferença, _between_ e _within_.
#' 
crime4_p$cr_l <- plm::lag(crime4_p$crmrte) # Vários pacotes possuem `lag`
crime4_p$cr_d <- diff(crime4_p$crmrte) # Diff usa base
crime4_p$cr_B <- plm::Between(crime4_p$crmrte)
crime4_p$cr_W <- plm::Within(crime4_p$crmrte)

head(crime4_p[, c("county", "year", "cr_l", "cr_d", "cr_B", "cr_W")])
#' 
#' ## Modelo em primeira diferença
#' 
#' Agora que temos um painel de dados devidamente organizados, podemos fazer
#' uso destes dados para rodas as regressões. Começaremos com um modelo do 
#' efeito do desemprego na taxa de crimes.
#' 
data(crime2)
crime2_p <- pdata.frame(crime2, index = 46) # Balanceado com n=46, T=2
# Manualmente calcular as diferenças e fazer a regressão
crime2_p$dcrmrte <- diff(crime2_p$crmrte)
crime2_p$dunem <- diff(crime2_p$unem)
manual_reg <- lm(dcrmrte~dunem, data = crime2_p)
# Especificar um modelo em PD no `plm`
fd_reg <- plm(crmrte~unem, data = crime2_p, model = "fd")
#'
#' Apresentando os resultados das regressões
#' 
modelsummary::msummary(list(manual_reg, fd_reg), 
                       gof_map = c("nobs", "r.squared"))
#'
#' ## Efeitos Fixos
#' 
#' O estimador de efeito fixo estima os parâmetros através da transformação
#' within e então faz uma regressão _pooled_ sobre estes dados transformados.
#' O pacote `plm` pode fazer a transformação e a regressão de uma só vez, ou 
#' podemos fazer manualmente.
#' 
data("wagepan")
wagepan_p <- pdata.frame(wagepan, index = c("nr", "year"))
pdim(wagepan_p)
# Usando plm
fe_plm <- plm(lwage~married+union+educ,
              data = wagepan_p,
              model = "within")
summary(fe_plm)
# Manualmente
wagepan_p$wi_lwage <- Within(wagepan_p$lwage)
wagepan_p$wi_married <- Within(wagepan_p$married)
wagepan_p$wi_union <- Within(wagepan_p$union)
wagepan_p$wi_educ <- Within(wagepan_p$educ)

fe_lm <- lm(wi_lwage~wi_married+wi_union-1,
            data = wagepan_p)
summary(fe_lm)
#'
#' ### Efeitos fixos com fixest
#' 
#' 
fe_fix <- feols(lwage~married+union+educ|nr, data = wagepan)
summary(fe_fix)
#' O [fixest](https://lrberge.github.io/fixest/) é muito útil pois pode fazer 
#' regressões com múltiplos efeitos fixos.
#' Por exemplo, se quisermos utilizar um modelo para investigar a mudança dos
#' retornos de educação no salário ao longo do tempo, supondo que exista
#' heterogeneidade não-observada tanto no indivíduo, quanto no ano, podemos fazer
#' a seguinte regressão.
#' 
fe_many <- feols(lwage~married+union+i(year, educ, ref = "1980")|nr+year, 
                 data = wagepan)
summary(fe_many)
#' O pacote também produz gráficos para estas regressões com interações.
#' 
iplot(fe_many)
#'
#' ## Comparando diversos modelos
#'
#' Vamos usar os dados de salários para checar as variáveis constantes no 
#' tempo e constantes no indivíduo para o painel. Após, estimaremos modelos de
#' MQO, Efeitos Aleatórios e Efeitos Fixos e investigar o modelo mais adequado.
#'
pvar(wagepan_p)
# Converte year para factor
wagepan_p$year <- factor(wagepan_p$year)
# Faz as regressões
reg_ols <- plm(lwage~educ+black+hisp+exper+I(exper^2)+married+union+year,
               data = wagepan_p,
               model = "pooling")
reg_re <- plm(lwage~educ+black+hisp+exper+I(exper^2)+married+union+year,
              data = wagepan_p,
              model = "random")
reg_fe <- plm(lwage~I(exper^2)+married+union+year,
              data = wagepan_p,
              model = "within")
# Show results
modelsummary::msummary(list(OLS = reg_ols, EA = reg_re, EF = reg_fe),
                       coef_map = c("educ", "black", "hisp", "exper", 
                                    "I(exper^2)", "married", "union"))
#'
#' Para escolher qual modelo utilizar é importante entender as hipóteses que 
#' cada um assume sobre a heterogeneidade não observada. O _Pooled_ MQO assume 
#' inexistência de heterogeneidade, enquanto que o modelo de Efeitos Aleatórios
#' assume que este heterogeneidade não está correlacionada com nenhum regressor.
#' Ambas as hipóteses são pouco factíveis em inúmeros casos práticos e, portanto,
#' o estimador de Efeito Fixo é muito utilizado pelos econometristas empíricos.
#' 
#' Ainda assim, se o pesquisador achar necessário, existe o teste formal de 
#' Haussman para decidir entre EA ou EF. O pacote plm implementa este teste 
#' com a função `phtest`.
#' 
phtest(reg_fe, reg_re)
#' 
#' Neste caso rejeitamos a H0 que ambos os modelos são consitentes. Como EF
#' é sempre consistente dada a correta especificação, é o caso de rejeitarmos
#' a hipótese de consistência do modelo EA. Portanto, neste caso, devemos
#' utilizar o modelo de efeitos fixos.