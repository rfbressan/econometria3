#' ---
#' title: Aula de laboratório - Diferenças em diferenças
#' author: Rafael Bressan
#' ---
#' 
#+ echo=TRUE, message=FALSE, warning=FALSE
library(wooldridge)
library(bacondecomp)
library(did)
library(haven)
library(ggplot2)
library(tidyverse)
library(modelsummary)
library(fixest)
library(lfe)

#' ## Diferenças em diferenças (DID)
#' 
#' Modelos DID são atualmente os mais utilizados em estudos observacionais
#' para investigar os efeitos de alguma política em uma variável de interesse.
#' Este tipo de _design_ faz uso das variações tanto entre grupo de indivíduos
#' quanto no tempo para obter o **efeito médio do tratamento sobre os tratados**
#' - ATT.
#' 
#' 
#' \begin{align}
#' DID &= \underbrace{\mathbb{E}[Y_{ist}|s = \text{NJ}, t = \text{Nov}] - \mathbb{E}[Y_{ist}|s = \text{NJ}, t = \text{Fev}]}_{\Delta_t^{GT}} 
#' - \Big(\underbrace{\mathbb{E}[Y_{ist}|s = \text{PA},t = \text{Nov}] - \mathbb{E}[Y_{ist}| s = \text{PA},t = \text{Fev}]}_{\Delta_t^{GC}}\Big) \\
#' \end{align}
#' 
#' onde estamos fazendo uso do exemplo Card e Krueger (1994). Pensilvânia (PA) 
#' é o estado de controle e Nova Jersey (NJ) o grupo tratado.
#' 
#' Em um formato de regressão, o estimador DID é obtido regredindo a variável
#' de interesse em uma _dummy_ para o grupo tratamento, uma outra _dummy_
#' para o período após a intervenção e um termo de interação entre os dois, que 
#' denota o efetivo tratamento.
#' 
#' $$Y_{st} = \alpha + \beta TRAT_s + \gamma POS_t + \delta(TRAT_s \times POS_t) + \varepsilon_{st}$$
#' 
#' Nesta especificação $\hat\delta = \text{DID}$ e a vantagem de fazer a 
#' regressão é que podemos fazer inferência sobre o parâmetro estimado 
#' diretamente.
#' 
#' Vamos fazer um exemplo encontrado no livro-texto do Wooldridge, exemplo 13.3
#' os efeitos de um incinerador de lixo no preço das moradias.
#' 
data("kielmc")
# DID manual
tratados <- kielmc[kielmc$nearinc == 1, ]
controles <- kielmc[kielmc$nearinc == 0, ]

delta_t <- mean(tratados[tratados$year == 1981, "rprice"]) - 
    mean(tratados[tratados$year == 1978, "rprice"])
delta_c <- mean(controles[controles$year == 1981, "rprice"]) -
    mean(controles[controles$year == 1978, "rprice"])

did_manual <- delta_t - delta_c
#' **Estime o efeito com um DID em forma de regressão**
#+ echo=FALSE
did_reg <- feols(rprice~nearinc*y81,
                 data = kielmc,
                 vcov = "HC1")
etable(did_reg)
#' 
#' Digamos que a hipótese de tendências paralelas seja válida somente após
#' controlar pela idade do imóvel e idade ao quadrado, distância para uma 
#' rodovia, área do terreno e da moradia, número de quartos e banheiros. 
#' Gostaríamos também que o modelo fosse especificado em logarítimos, para ter
#' uma ideia de variação percentual do preço da moradia em relação a presença 
#' do incinerador.
#' 
#' **Calcule o efeito no cenário acima descrito**
#+ echo=FALSE
did_ctr <- feols(log(rprice)~nearinc*y81+sw0(age+agesq+lintst+log(land)+log(area)+rooms+baths),
                 data = kielmc,
                 vcov = "HC1")

etable(did_ctr)
#'
#'
#' # Replicating Cheng and Hoekstra (2013), sort of
#' 
#' Cheng e Hoekstra (2013) avaliaram o impacto que uma reforma de armas teve 
#' sobre a violência e para ilustrar vários princípios e práticas em relação ao 
#' timing diferencial. Vamos discutir esses princípios no contexto deste artigo. 
#' 
#' Considerando que antes a autodefesa letal era legal apenas dentro de casa, 
#' uma nova lei, “Stand Your Ground”, estendeu esse direito a outros locais 
#' públicos. Entre 2000 e 2010, vinte e um estados expandiram explicitamente o 
#' estatuto da doutrina do castelo, estendendo os locais fora de casa onde a 
#' força letal poderia ser usada legalmente.
#' 
#' Cheng e Hoekstra (2013) escolheram um projeto de diferença em diferenças para 
#' seu projeto, onde a lei da doutrina do castelo era o tratamento e o tempo era 
#' diferenciado entre os estados. Sua equação de estimativa foi
#' 
#' $$Y_{it}=\alpha+\delta D_{it}+\gamma X_{it}+\sigma_i+\tau_t+\varepsilon_{it}$$
#' 
#' Cheng e Hoekstra (2013) não encontraram evidências de que as leis da doutrina 
#' do castelo dissuadissem ofensas violentas, mas descobriram que isso aumentava 
#' os homicídios. Um aumento líquido de 8% nas taxas de homicídios se traduz em 
#' cerca de seiscentos homicídios adicionais por ano nos vinte e um estados que 
#' o adotaram.
#' 
read_data <- function(df)
{
    full_path <- paste("https://raw.github.com/scunning1975/mixtape/master/", 
                       df, sep = "")
    df <- read_dta(full_path)
    return(df)
}

castle <- read_data("castle.dta")

#--- global variables
crime1 <- c("jhcitizen_c", "jhpolice_c", 
            "murder", "homicide", 
            "robbery", "assault", "burglary",
            "larceny", "motor", "robbery_gun_r")
# demographics
demo <- c("emo", "blackm_15_24", "whitem_15_24", 
          "blackm_25_44", "whitem_25_44")
# variables dropped to prevent colinearity
dropped_vars <- c("r20004", "r20014",
                  "r20024", "r20034",
                  "r20044", "r20054",
                  "r20064", "r20074",
                  "r20084", "r20094",
                  "r20101", "r20102", "r20103",
                  "r20104", "trend_9", "trend_46",
                  "trend_49", "trend_50", "trend_51"
)
# Trend columns to keep
lintrend <- castle %>%
    select(starts_with("trend")) %>% 
    colnames %>% 
    # remove due to colinearity
    subset(.,! . %in% dropped_vars) 
# Region columns to keep
region <- castle %>%
    select(starts_with("r20")) %>% 
    colnames %>% 
    # remove due to colinearity
    subset(.,! . %in% dropped_vars) 
exocrime <- c("l_lacerny", "l_motor")
spending <- c("l_exp_subsidy", "l_exp_pubwelfare")
xvar <- c(
    "blackm_15_24", "whitem_15_24", "blackm_25_44", "whitem_25_44",
    "l_exp_subsidy", "l_exp_pubwelfare",
    "l_police", "unemployrt", "poverty", 
    "l_income", "l_prisoner", "l_lagprisoner"
)
law <- c("cdl")
#'
#' Por exemplo, vamos conferir a evolução dos homicídios na Florida (sid = 10) 
#' contra a Califórnia (sid = 5)
fl_ca <- castle |> 
    filter(sid %in% c(5, 10)) |> 
    mutate(sid = as.factor(sid),
           year_fct = as.factor(year))

ggplot(fl_ca, aes(year_fct, l_homicide, group = sid, color = sid)) +
    geom_line() +
    scale_color_discrete(labels = c("California", "Florida")) +
    geom_vline(xintercept = "2005", linetype = 2) +
    labs(x = "Ano",
         y = "Log homicídios por 100K hab.",
         title = "Log homicídios FL vs CA") +
    guides(color = guide_legend(title = "Estado")) +
    theme_classic()
#'
#'
#' Vamos conferir também quais estados passaram este tipo de lei e quando
cdl_sid <- castle |> 
    group_by(sid, state) |> 
    summarise(sum_post = sum(post)) |> 
    filter(sum_post > 0) |> 
    pull(sid)

cdl_states <- castle |> 
    select(sid, state, year, post) |> 
    filter(sid %in% cdl_sid, post == 0) |> 
    group_by(sid) |> 
    slice(n()) |> 
    arrange(year)
kableExtra::kbl(cdl_states[, c("state", "year")],
                col.names = c("Estado", "Ano CDL")) |> 
    kableExtra::kable_classic(full_width = FALSE)
#'
#' Este tipo de design é o que chama-se de adoção escalonada ao tratamento
#' (_staggered adoption_). Existem diversas coortes que aderem ao tratamento em
#' momentos distintos
#' 
dd_formula <- as.formula(
    paste("l_homicide ~ ",
          paste(
              paste(xvar, collapse = " + "),
              paste(region, collapse = " + "),
              paste(lintrend, collapse = " + "),
              paste("post", collapse = " + "), sep = " + "),
          "| year + sid | 0 | sid"
    )
)
#Fixed effect regression using post as treatment variable 
dd_reg <- felm(dd_formula, weights = castle$popwt, data = castle)
msummary(dd_reg,
         output = "kableExtra",
         fmt = 4,
         coef_map = "post",
         gof_map = c("nobs", "adj.r.squared", "vcov.type")) |> 
    kableExtra::kable_classic()
#'
#' Agora, vamos ir além do estudo deles e implementar um **estudo de evento**. 
#' Para fazer isso, usamos uma variável “time_til”, que é o número de anos até 
#' ou depois que o estado recebeu o tratamento. Usando essa variável, criamos os 
#' leads (que serão os anos anteriores ao tratamento) e os 
#' lags (os anos pós-tratamento). Felizmente o dataset providenciado já possui
#' estas dummies.
#' 
event_study_formula <- as.formula(
    paste("l_homicide ~ + ",
          paste(
              paste(region, collapse = " + "),
              paste(paste("lead", 1:9, sep = ""), collapse = " + "),
              paste(paste("lag", 1:5, sep = ""), collapse = " + "), sep = " + "),
          "| year + state | 0 | sid"
    ),
)

event_study_reg <- felm(event_study_formula, weights = castle$popwt, data = castle)
msummary(event_study_reg,
         output = "kableExtra",
         fmt = 4,
         coef_omit = "^(?!lead|lag)", # lookahed regex. starts with lead or lag
         gof_map = c("nobs", "adj.r.squared", "vcov.type")) |> 
    kableExtra::kable_classic()
#' 
#' É comum plotar esses estudos de eventos. Utiliza-se gráficos tipo
#' point-range, onde a estimativa pontual e o intervalo de confiança são 
#' mostrados. Vamos fazer isso agora.
#' 
# order of the coefficients for the plot
plot_order <- c("lead9", "lead8", "lead7", 
                "lead6", "lead5", "lead4", "lead3", 
                "lead2", "lead1", "lag1", 
                "lag2", "lag3", "lag4", "lag5")
# grab the clustered standard errors
# and average coefficient estimates
# from the regression, label them accordingly
# add a zero'th lag for plotting purposes
leadslags_plot <- tibble(
    sd = c(event_study_reg$cse[plot_order], 0),
    mean = c(coef(event_study_reg)[plot_order], 0),
    label = c(-9:-1, 1:5, 0)
)
# This version has a point-range at each
# estimated lead or lag
# comes down to stylistic preference at the
# end of the day!
leadslags_plot %>%
    ggplot(aes(x = label, y = mean,
               ymin = mean - 1.96*sd, 
               ymax = mean + 1.96*sd)) +
    geom_hline(yintercept = coef(dd_reg)["post"], 
               color = "red") +
    geom_pointrange() +
    theme_classic() +
    xlab("Anos antes e depois da expansão da lei doutrina do castelo") +
    ylab("Log homicídios por 100K hab.") +
    geom_hline(yintercept = 0,
               linetype = "dashed") +
    geom_vline(xintercept = 0,
               linetype = "dashed")
# This version includes
# an interval that traces the confidence intervals
# of your coefficients
leadslags_plot %>%
    ggplot(aes(x = label, y = mean,
               ymin = mean-1.96*sd, 
               ymax = mean+1.96*sd)) +
    # this creates a red horizontal line
    geom_hline(yintercept = coef(dd_reg)["post"], 
               color = "red") +
    geom_line() + 
    geom_point() +
    geom_ribbon(alpha = 0.2) +
    theme_minimal() +
    # Important to have informative axes labels!
    xlab("Anos antes e depois da expansão da lei doutrina do castelo") +
    ylab("Log homicídios por 100K hab.") +
    geom_hline(yintercept = 0) +
    geom_vline(xintercept = 0)
#' Uma literatura recente tem demonstrado que esta especificação pode ser viesda
#' para o efeito do tratamento sobre os tratados, ou seja, TWFE com adocação 
#' escalonada pode não ser equivalente ao estimador de DID. Vamos utilizar a
#' mesma especificação, porém utilizando o estimador de Callaway & Sant'anna 
#' encontrado no pacote `did`.
#' 
#+ warning=FALSE
# Precisamos adaptar o data.frame para a funcao att_gt
castle_cs <- replace_na(castle, list(effyear = 0)) |> 
    select(sid, year, effyear, popwt, l_homicide, r20001)
did_gt <- att_gt(
    yname = "l_homicide",
    tname = "year",
    idname = "sid",
    gname = "effyear",
    weightsname = "popwt",
    # xformla = ~r20001,
    control_group = "notyettreated",
    data = castle_cs
)
did_es <- aggte(did_gt, type = "dynamic")

ggdid(did_es) +
    scale_x_continuous(n.breaks = 10) +
    geom_hline(yintercept = coef(dd_reg)["post"], 
               color = "red") +
    labs(x = "Anos antes e depois da expansão da lei doutrina do castelo",
         y = "Log homicídios por 100K hab.")
#' Vejam que as estimativas mudaram ligeiramente apenas. Muito embora a 
#' especificação TWFE deva ser viesada em teoria, este viés aparentemente é
#' pequeno. Podemos averiguar esta situação através da decomposição de 
#' Goodman-Bacon. Se nenhum dos pesos atribuídos as estimativas for negativo,
#' então o viés do TWFE tende a ser pequeno (pesos negativos exacerbam o viés 
#' além de prejudicar uma interpretação causal do estimador TWFE).
#' 
bacon_d <- bacon(l_homicide~post, 
                 data = castle, 
                 id_var = "sid", 
                 time_var = "year")
