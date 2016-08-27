# Requiered Libraries
library(shiny)
library(rCharts)

# Define UI for pokemon viewer application
shinyUI(fluidPage(
        
        # Application title
        titlePanel("Pokemon Data Analisys"),
        
        # Sidebar with controls to select 2 kind of pokemon's attributes (X, Y) and select
        # the number of top pokemons (X Attribute ordered) to view. 
        # The helpText function is also used to include clarifying text.
        # The Submit button apply the changes in the fields and refresh outputs.
        sidebarLayout(
                sidebarPanel(
                        selectInput(inputId = "x", 
                                    label = "X Attribute:", 
                                    choices = c("Total", "HP", "Attack", "Defense", "Special Attack", "Special Defense", "Speed"),
                                    "Attack"
                                    ),
                        
                        selectInput(inputId = "y",
                                    label = "Y Attribute:",
                                    choices = c("Total", "HP", "Attack", "Defense", "Special Attack", "Special Defense", "Speed"), 
                                    "Defense"
                                    ),

                        numericInput("obs", "Number of Top Pokemons:", 50),
                        
                        helpText("Note: while the graph/data view will show only the specified",
                                 "number of top pokemons, the summary will still be based",
                                 "on the full dataset."),

                        submitButton("Update View"),

                        helpText("Note: This dataset was downloaded from kaggle (https://www.kaggle.com/abcsds/pokemon) "),
                        
                        helpText(" The data as described by Myles O'Neil is: "),
                        helpText(" Name: Name of each pokemon "),
                        helpText(" Type 1: Each pokemon has a type, this determines weakness/resistance to attacks "),
                        helpText(" Total: sum of all stats that come after this, a general guide to how strong a pokemon is "),
                        helpText(" HP: hit points, or health, defines how much damage a pokemon can withstand before fainting "),
                        helpText(" Attack: the base modifier for normal attacks (eg. Scratch, Punch) "),
                        helpText(" Defense: the base damage resistance against normal attacks "),
                        helpText(" Special Attack (SPAtk): special attack, the base modifier for special attacks "),
                        helpText(" Special Defense (SPDef): the base damage resistance against special attacks "),
                        helpText(" Speed: determines which pokemon attacks first each round ")

                ),
                
                # Show a summary of the dataset 
                # a scatter graph for x, y attributes
                # and a data table, both with the
                # requested number of top pokemons (order by X attribute)
                mainPanel(
                        h4("Summary of X, Y Attributes"),
                        verbatimTextOutput("summary"),
                        
                        h4("Scatter Plot"),
                        showOutput("splot","polycharts"),
                        
                        h4("Data Table"),
                        DT::dataTableOutput("table")
                )
        )
))