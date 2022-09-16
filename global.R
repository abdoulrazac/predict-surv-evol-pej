# Pakages
library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinyWidgets)
library(randomForestSRC)
library(dplyr)
library(plotly)
library(ggplot2)
library(ggplotify)
library(pec)


# Import des données
best_model <- readRDS("best_model.rds")
fdep <- read.csv2(file = "fdep_commune_data.csv", encoding = "UTF-8") %>% 
  mutate(commune = paste(ID_COMMUNE, NOM_COMMUNE))
base_prob <- read.csv2("surv_risk.csv", fileEncoding = 'UTF-8')

# Recuperer indice de comorbidite
get_icc_value <- function(vals = NULL){
  return("< Q2")
}

# Recuperer fdep
get_fdep_value <- function(commune = NULL){
  if(commune %in% fdep[["commune"]])
    value <- fdep[['vc_indice_fdep_quartile']][fdep[["commune"]] == commune]
  else
    value <- "Intermédiaire (Q1-Q3)"
  return(value)
}

## Valid value
get_valid_value <- function(val){
  ifelse(is.null(val) , NA, val)
}

## Creation des donnees de prediction
create_data <- function(input){
  data.frame(
    vc_group_age            = get_valid_value(input$vc_group_age),
    vc_en_couple            = get_valid_value(input$vc_en_couple),
    vc_stade_cat4           = get_valid_value(input$vc_stade_cat4),
    vc_IMC_actuel_cat       = get_valid_value(input$vc_IMC_actuel_cat),
    vc_diabetique           = get_valid_value(input$vc_diabetique),
    vc_act_phy_sport        = get_valid_value(input$vc_act_phy_sport),
    vc_trait_alter          = get_valid_value(input$vc_trait_alter),
    vc_fatigue              = get_valid_value(input$vc_fatigue),
    vc_douleur              = get_valid_value(input$vc_douleur),
    vc_revenu_uc_enq        = get_valid_value(input$vc_revenu_uc_enq),
    vc_indice_fdep_quartile = get_fdep_value(input$vc_indice_fdep_quartile),
    vc_recepteur_her        = get_valid_value(input$vc_recepteur_her),
    vc_recepteur_re         = get_valid_value(input$vc_recepteur_re),
    vc_recepteur_rp         = get_valid_value(input$vc_recepteur_rp),
    vc_indice_icc_enq_2     = get_icc_value(input$vc_indice_icc_enq_2)
  )
}

create_prob_data <- function(data_new, times){
  prob <- predictSurvProb(best_model, newdata = data_new, times = times) %>%
    as.vector() %>% 
    round(3)
  
  data.frame(
    estimate = c(1, prob, tail(prob, 1)),
    time = c(0, times, 36)
  ) %>% return()
}

get_proba <- function(data_new, times){
  predictSurvProb(best_model, newdata = data_new, times = times) %>%
    as.vector() %>% 
    round(3)
}


## Graphique de survie
get_plot <- function(base_prob, pred_prob = NULL){

  plt_df = base_prob %>% 
    round(3) %>% 
    mutate(source = "Ensemble")
  
  if(!is.null(pred_prob)){
    pred_prob <- pred_prob %>% 
      round(3) %>% 
      mutate(source = "Prédiction") %>% 
      select(time, estimate, source)

      plt_df <- bind_rows(
        base_prob %>% 
          round(3) %>% 
          mutate(source = "Ensemble") %>% 
          select(time, estimate, source),
        pred_prob
      )
  }
  
  plt <- ggplot(data = plt_df) +
    aes(x = time,  y = estimate, colour = source) +
    geom_line(size = 1) +
    geom_ribbon(aes(x = time, ymin = conf.low, ymax = conf.high, color = 'Ensemble'), data = base_prob %>% round(3), alpha = 0.1, color = 'gray70') +
    labs(
      x = 'Temps (en mois)', 
      y = 'Probabilité de survie', 
      title = "Courbe de survie d'une évolution péjorative du cancer du sein") +
    scale_x_continuous(breaks = seq(0, 36, 6), limits = c(0, 36)) +
    scale_y_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1), labels = scales::percent) +
    scale_color_manual(
      name = NULL,
      breaks = c("Ensemble", "Prédiction"),
      values = c("Ensemble" = '#4477AA',  "Prédiction" = '#EE6677')
    ) +
    theme_bw() +
    theme(
      text = element_text(size = 14),
      legend.position = c(0.8, .2)
    )
  return(plt)
}

get_stat_box<- function(dat, times){
  
  proba <- predictSurvProb(best_model, newdata = dat, times = times) %>%
    as.vector() %>% 
    round(3)
  
  icone <- "thumbs-up"
  couleur <- "green"
  
  if(proba < 0.95){
    icone <- "thumbs-down"
    couleur <- "red"
  }
  
  proba <- proba %>% scales::percent(accuracy = 0.1)
    
  valueBox(
    proba, paste(times,"mois"), icon = icon(icone, lib = "glyphicon"), color = couleur
  )

}

