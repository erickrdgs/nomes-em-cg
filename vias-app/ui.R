library(shiny)
library(tidyverse)
library(here)
source(here("code/read_wrangle.R"))

profissoes_nos_dados = read_wrangle_data() %>% 
    filter(!is.na(profissao)) %>%  
    pull(profissao) %>% 
    unique()

pageWithSidebar(
    headerPanel('Pensar em um título'),
    sidebarPanel(
        selectInput("caracter", 
                    "Característica", 
                    FEATURES),
        selectInput("profissao", 
                    "Profissão", 
                    profissoes_nos_dados),
        tableOutput("listagem")
    ),
    
    mainPanel(
        plotOutput("distPlot"),
        plotOutput("distPlot2"),
        textOutput("corr")
    )
)
