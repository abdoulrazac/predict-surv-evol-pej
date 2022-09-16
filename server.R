function(input, output, session) {

  updateSelectizeInput(
    session = session, 
    inputId = "vc_indice_fdep_quartile", 
    choices = c("Sélectionner ...", fdep[['commune']]), 
    server = TRUE
  )
  

  output$outBox6mois <- renderValueBox({
    pred_data <- create_data(input = input)
    get_stat_box(dat = pred_data, times = 6)
  })

  output$outBox12mois <- renderValueBox({
    pred_data <- create_data(input = input)
    get_stat_box(dat = pred_data, times = 12)
  })

  output$outBox18mois <- renderValueBox({
    pred_data <- create_data(input = input)
    get_stat_box(dat = pred_data, times = 18)
  })

  output$outBox24mois <- renderValueBox({
    pred_data <- create_data(input = input)
    get_stat_box(dat = pred_data, times = 24)
  })
  
  output$plot_surv <- renderPlotly({
    pred_data <- create_data(input = input)
    pred_pob <- create_prob_data(dat = pred_data, times = seq(0.5, 35.5, 0.5))
    get_plot(base_prob = base_prob, pred_prob = pred_pob) %>%
      ggplotly()
  })

}
