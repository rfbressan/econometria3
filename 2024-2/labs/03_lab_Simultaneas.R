#' ---
#' title: Aula de laboratório - Modelos de Equações Simultâneas
#' author: Rafael Bressan
#' ---
#' 
#' ## Introdução
#' 
#' Vamos utilizar a seguinte notação geral para um SEM (Simultaneous Equations 
#' Model) composto de $q$ variáveis endógenas $y_1, \ldots, y_q$ e $k$ variáveis 
#' exógenas $x_1, \ldots, x_k$. 
#' 
#' $$
#' \begin{align*}
#' y_1&=\alpha_{12}y_2+\ldots +\alpha_{1q}y_q + \beta_{10}+\beta_{11}x_1+\ldots+\beta_{1k}x_k+u_1\\
#' y_2&=\alpha_{21}y_1+\ldots +\alpha_{2q}y_q + \beta_{20}+\beta_{21}x_1+\ldots+\beta_{2k}x_k+u_2\\
#' \vdots & \\
#' y_q&=\alpha_{q1}y_1+\ldots +\alpha_{qq-1}y_{q-1} + \beta_{q0}+\beta_{q1}x_1+\ldots+\beta_{qk}x_k+u_q
#' \end{align*}
#' $$
#' 
#' A condição de ordem para identificação de alguma destas equações é tal que o
#' número de variáveis exógenas (ou predeterminadas) excluídas da equação não 
#' deve ser menor que o número de variáveis endógenas incluídas nessa equação 
#' menos 1, $K – k \geq m – 1$.
#' 
#' Conseguida a identificação da equação, os regressores exógenos excluídos servirão de
#' variáveis instrumentais na estimação através de MQ2E.
#' 
#' ## Oferta de Trabalho de Mulheres Casadas Trabalhando
#' 
#' Vimos em aula como estimar esta equação de oferta separadamente usando MQ2E.
#' 
#' $$
#' \begin{align*}
#' hours&=\alpha_1 lwage + \beta_{10}+ \beta_{11}educ+\beta_{12}age+\beta_{13}kidslt6+\beta_{14}nwifeinc+u_1\\
#' lwage&=\alpha_2 hours + \beta_{20}+ \beta_{21}educ+ \beta_{22}exper+\beta_{23}exper^2+ u_2 
#' \end{align*}
#' $$
#' 
#' - **Qual ou quais destas equações são identificadas?**
#' 
#' Vamos então estimar as duas equações de forma conjunta, ambas através de MQ2E
#' utilizando o pacote `systemfit`.
#' 
#+ message = FALSE
library(systemfit)
library(wooldridge)

data("mroz")

df <- mroz[!is.na(mroz$wage), ]

# Definindo o sistema de equações e os instrumentos
eq.hrs <- hours ~ lwage+educ+age+kidslt6+nwifeinc
eq.wage <- lwage ~ hours+educ+exper+expersq
eq.system <- list(eq.hrs, eq.wage)
inst <- ~educ+age+kidslt6+nwifeinc+exper+expersq

# Estimando por MQ2E todas as equações conjuntamente
mq2e <- systemfit(eq.system, inst = inst, data = df, method = "2SLS")
summary(mq2e)

#' Um resultado interessante que foi apresentado é a matriz de correlação dos
#' resíduos. Os resíduos das duas equações são fortemente correlacionados de 
#' forma negativa. O método de estimação de **Mínimos Quadrados em 3 Estágios**
#' (MQ3E) pode ser utilizado para levar em consideração esta correlação e obter
#' um estimador mais eficiente que o MQ2E.
#' 
#' Usar MQ3E com o `systemfit` é tão fácil quanto simplesmente trocar o 
#' argumento "method" da função.
#' 
# Estimando por MQ2E todas as equações conjuntamente
mq3e <- systemfit(eq.system, inst = inst, data = df, method = "3SLS")
summary(mq3e)
