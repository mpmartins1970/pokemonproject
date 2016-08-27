# Required Libraries
library(shiny)
library(rCharts)

# Load full dataset
pkData <- read.csv(
        file = "./data/Pokemon.csv",
        header = TRUE,
        sep = ",", 
        na.strings = "NA"
)

# Create dataset without missing values
pkData <- subset(pkData, complete.cases(pkData))

# Change column names
names(pkData) = gsub("\\.", "", names(pkData))

# Define server logic required to summarize and view the 
# selected characteristic/attribute in a ordered list 
shinyServer(function(input, output) {
        
        # Return the requested attribute
        xInput <- reactive({
                switch(input$x,
                       "Total" = "Total",
                       "HP" = "HP",
                       "Attack" = "Attack",
                       "Defense" = "Defense",
                       "Special Attack" = "SpAtk",
                       "Special Defense" = "SpDef",
                       "Speed" = "Speed"
                )
        })
        
        yInput <- reactive({
                switch(input$y,
                       "Total" = "Total",
                       "HP" = "HP",
                       "Attack" = "Attack",
                       "Defense" = "Defense",
                       "Special Attack" = "SpAtk",
                       "Special Defense" = "SpDef",
                       "Speed" = "Speed"
                )
        })
        
        # Generate a summary of the X,Y attributes
        output$summary <- renderPrint({
                summary(pkData[,c(xInput(), yInput())])
        })

        # Show the ordered first n pokemons in a data table
        output$table <- DT::renderDataTable(DT::datatable({
                xOrd <- eval(parse(text = paste0('pkData$', xInput())))
                data <- head(pkData[order(-xOrd, pkData$Name), ], n = input$obs)
                data[c(2,3,5:11)]
        }))
        
        
        # Generate a scatterplot with the attributes
        output$splot <- renderChart({
                
                xAttr <- eval(parse(text = paste0('pkData$', xInput())))

                pkDataOrd <- head(pkData[order(-xAttr), ], n = input$obs)
                xOrd <- eval(parse(text = paste0('pkDataOrd$', xInput())))
                yOrd <- eval(parse(text = paste0('pkDataOrd$', yInput())))
                
                plotCmd <- paste0("rPlot(",yInput(), " ~ ", xInput(), ",", 
                                  " data = pkDataOrd,", 
                                  " color = 'Type1',",
                                  " type = 'point')"
                                  )

                p1 <- eval(parse(text = plotCmd))
                
                # Format the x and y axis labels
                p1$guides(x = list(min = min(xOrd) - 10, max = max(xOrd) + 10))
                p1$guides(y = list(min = min(yOrd) - 10, max = max(yOrd) + 10))
                
                p1$addParams(dom = "splot")
                
                return(p1)
                
        })
        
        
})