#ggplotly_demo
#note:  several of these examples come from https://plot.ly/r/
# for more details, also see https://plotly-book.cpsievert.me/index.html

#  Will use Shiny at end of script.. install if you don't have it.
# install.packages("shiny")

# New package:  maniupulateWidget
install.packages("manipulateWidget")

library(datasets)
library(tidyverse)
library(plotly)
library(shiny)
library(manipulateWidget)

# a first example inspired by plotly website 
# ggplot approach

glimpse(diamonds)
s <- sample(1:nrow(diamonds), 2000)
mydf <- diamonds[s,]
mydf <- diamonds
glimpse(mydf)
pgg <- mydf %>%
     ggplot(aes(x = carat, y = price, color = cut, alpha = 0.5)) +
     geom_point()+
     geom_smooth(method="lm", se=FALSE)+
     theme_classic() 
pggy <- ggplotly(pgg)
pggy  # display the viz

# customize layout -- eg dragmode

layout(pggy, dragmode = "pan")

# range slider
rangeslider(pggy)


##########################333
# filter on cut values using plot_ly from data

lm1 <- lm(mydf$price ~ mydf$carat)

p2 <- mydf %>%
     plot_ly(
          type = 'scatter', 
          x = ~carat, 
          y = ~price,
          color = ~color,
          text = ~cut,
          hoverinfo = 'text',
          mode = 'markers', 
          transforms = list(
               list(
                    type = 'filter',
                    target = ~cut,
                    operation = '=',
                    value = unique(mydf$cut)[1]
               )
          )) 
p2 <- add_lines(p2, x=mydf$carat, y=predict(lm1)) %>%
         layout(
          updatemenus = list(
            list(
                 type = 'dropdown',
                   active = 0,
                   buttons = list(
                      list(method = "restyle",
                           args = list("transforms[0].value", unique(mydf$cut)[1]),
                           label = unique(mydf$cut)[1]),
                      list(method = "restyle",
                           args = list("transforms[0].value", unique(mydf$cut)[2]),
                           label = unique(mydf$cut)[2]),
                      list(method = "restyle",
                           args = list("transforms[0].value", unique(mydf$cut)[3]),
                           label = unique(mydf$cut)[3]),
                      list(method = "restyle",
                           args = list("transforms[0].value", unique(mydf$cut)[4]),
                          label = unique(mydf$cut)[4]),
                      list(method = "restyle", 
                           args = list("transforms[0].value", unique(mydf$cut)[5]),
                           label = unique(mydf$cut)[5])
                      )
                    )
                 )
               )
p2  # now display the object

### 
# manipulate widget -- groupcheckboxes

if (require(plotly)) {
   manipulateWidget(
      {
         if (length(cut) == 0) mydata <- mydf
         else mydata <- mydf[mydf$cut %in% cut,]
         plot_ly(mydata, x = ~carat, y = ~price,
                 color = ~droplevels(cut), type = "scatter", mode = "markers")
      },
      cut = mwCheckboxGroup(levels(mydf$cut))
   )
}
