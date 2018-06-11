library(shiny)
library(tidyverse)
library(here)
source(here("code/read_wrangle.R"))

vias = read_wrangle_data()

profissoes_nos_dados = vias %>% 
    filter(!is.na(profissao)) %>%  
    pull(profissao) %>% 
    unique()

function(input, output, session) {
    selectedData <- reactive({
        if(input$caracter == "Arvores")
        {
            carac <- vias$arvore
            cbind(vias, carac)
        }else if(input$caracter == "Semaforos")
        {
            carac <- vias$semaforo
            cbind(vias, carac)
        }else if(input$caracter == "Pontos de taxi")
        {
            carac <- vias$pontotaxi
            cbind(vias, carac)
        }else if(input$caracter == "Pontos de mototaxi")
        {
            carac <- vias$pontomotot
            cbind(vias, carac)
        }else if(input$caracter == "Pontos de onibus")
        {
            carac <- vias$pontoonibu
            cbind(vias, carac)
        }else
        {
            carac <- vias$bancos
        }
    })
    
    output$distPlot <- renderPlot({
        selectedData() %>%
            ggplot(aes(x = comprimento, y = carac)) + 
            geom_point(alpha = .2, color = "blue", size = 3) +
            labs(y = input$caracter, x = "comprimento") +
            ggtitle("Visão geral")  +
            theme(plot.title = element_text(hjust = 0.5)) +
            ylim(0, max(selectedData()$carac, na.rm = TRUE))
    })
    
    output$distPlot2 <- renderPlot({
        selectedData() %>%
            filter(profissao == input$profissao) %>%
            ggplot(aes(x = comprimento, y = carac)) + 
            geom_point(alpha = .2, color = "blue", size = 3) +
            labs(y = input$caracter, x = "comprimento") +
            ggtitle("Por profissão") +
            theme(plot.title = element_text(hjust = 0.5)) +
            xlim(0, 20000) +
            ylim(0, max(selectedData()$carac, na.rm = TRUE))
    })
    
    output$listagem <- renderTable({
        vias %>% 
            filter(profissao == input$profissao) %>% 
            select(nome = nomelograd,
                   comp = comprimento)
    })
    
    output$corr <- renderText({
        correlation <- round(cor(selectedData()$carac, selectedData()$comprimento), 2)
        paste("Correlação entre as variáveis:", correlation, sep=" ")
    })
}
