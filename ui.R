vc_accueil <- fluidRow( 
    
    column(
      width = 10,
      offset = 1,
      
      fluidRow(
        fluidRow(
          box(
            width = 4, status = "primary", solidHeader = TRUE,
            title = "Caractéristique démographique",
            fluidRow(
              column(width = 6, radioButtons("vc_group_age", label = "Groupe d'age", choices = c("< 53 ans", "53 ans et +"))),
              column(width = 6, radioButtons("vc_en_couple", label = "En couple", choices = c("Non", "Oui"))),
            ),
            fluidRow(
              column(width = 6, radioButtons("vc_revenu_uc_enq", label = "Revenu du foyer par unité de consommation", choices = c("Intermédiaire (Q1-Q3)", "Faible (<Q1)", "Elevé (>Q3)"))),
              # column(width = 6, radioButtons("vc_indice_fdep_quartile", label = "Indice territorial de désavantage social (FDep),", choices = c("Intermédiaire (Q1-Q3)", "Faible (<Q1)", "Elevé (>Q3)"))),
              column(width = 6, selectizeInput("vc_indice_fdep_quartile", label = "Commune de résidence", choices = NULL, options = list(maxOptions = 100))),
            )
          ),
          
          box(
            width = 3, status = "warning", solidHeader = TRUE,
            title = "Caratéristique clinique",
            fluidRow(
              column(width = 4, radioButtons("vc_IMC_actuel_cat", label = "Catégories d'IMC", choices = c("[18.5 - 25[", "< 18.5", "[25 à 30[", "30 et +"))),
              column(width = 4, radioButtons("vc_stade_cat4", label = "Stade du cancer", choices = c("Stade I/II", "Stade III/IV", "Stade X"))),
              column(width = 4, radioButtons("vc_diabetique", label = "Diabètique", choices = c("Non", "Oui"))),
            ),
            fluidRow(
              column(width = 4, radioButtons("vc_recepteur_her", label = "HER2", choices = c("Positif", "Négatif"))),
              column(width = 4, radioButtons("vc_recepteur_re", label = "RE", choices = c("Positif", "Négatif"))),
              column(width = 4, radioButtons("vc_recepteur_rp", label = "RP", choices = c("Positif", "Négatif"))),
            )
          ),
          box(
            width = 3, status = "info",  solidHeader = TRUE,
            title = "Traitement en cours",
            fluidRow(
              column(width = 6, radioButtons("vc_act_phy_sport", label = "Pratique une activité physique ou sportive",choices = c("Non", "Oui"))),
              column(width = 6, radioButtons("vc_trait_alter", label = "Traitement alternatif", choices = c("Non", "Oui"))),
            ),
            fluidRow(
              column(width = 12, selectizeInput("vc_indice_icc_enq_2", multiple = TRUE, label = "Médicaments (plusieurs choix possible)", choices = paste("item", 1:22), options = list(placeholder = "Selectionner ..."))),
            )
          ),
          box(
            width = 2, status = "success",  solidHeader = TRUE,
            title = "Perception",
            fluidRow(
              column(width = 12,             radioButtons("vc_fatigue", label = "Sensation de fatigue les 15 derniers jours", choices = c("Parfois / Jamais", "Souvent / Constamment"))),
              column(width = 12, radioButtons("vc_douleur", label = "Sensation de douleur les 15 derniers jours", choices = c( "Parfois / Jamais", "Souvent / Constamment"))),
            )
          )
        )
      ),
      fluidRow(
        column(
          width = 3,
          # fluidRow( 
          #   style = "margin-top: 0px; margin-bottom : 20px;",
          #   column( width = 4,  offset = 2, actionButton("refresh", "Actualiser", class = "btn-info", icon = icon("refresh"))),
          #   column( width = 4, downloadButton("dowload", "Télécharger", icon = icon("download")))
          # ),
          fluidRow(
            box(
              width = 12, status = "primary", solidHeader = TRUE,
              title = "Probabilité de survie",
              fluidRow(
                column(
                  width = 10, 
                  offset = 1, 
                  valueBoxOutput("outBox6mois", width = 12),
                  valueBoxOutput("outBox12mois", width = 12),
                  valueBoxOutput("outBox18mois", width = 12),
                  valueBoxOutput("outBox24mois", width = 12),
                ),
              )
            )
          )
        ),
        column(
          width = 9,
          fluidRow(
            box(
              width = 12, status = "primary", 
              # title = "Courbe de surive",
              plotlyOutput("plot_surv", width = "100%", height = 550,)
              # dataTableOutput("plot_surv")
            )
          )
        )
      )
    )
  )

vc_apropos <- h2("Widgets tab content")

fluidPage(theme = shinytheme("flatly"),
                navbarPage("Prédiction du risque d'évolution péjorative du cancer du sein",
                           
                           tabPanel("Accueil",
                                    # Input values,
                                    useShinydashboard(),
                                    vc_accueil
                                    
                           ), #tabPanel(), Home
                           
                           tabPanel("A propos", 
                                    div(includeMarkdown("about.md"), align="justify")
                           ) #tabPanel(), About
                           
                ) # navbarPage()
)