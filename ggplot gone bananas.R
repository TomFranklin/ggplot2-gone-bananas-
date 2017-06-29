# TF 29/06/17
# ggplot2 gone bananas

####
# Psuedocode 
# 1. Load packages ---- 

library(grid)
library(png)
library(gtable)
library(ggplot2)
library(ggthemes)
library(dplyr)
library(gridExtra)
library(scales)
library(data.table)
library(RColorBrewer) 
library(jpeg)

# 2. Get data into R ----
setwd('C:/Users/Anthony/Desktop/R/Datasets') # set working directory
data <- read.csv('bananas.csv')
data$Year <- as.character(data$Year) # turn Year into a character
data$Year <- as.Date(data$Year, format = "%m/%d/%Y")
data$Year.POSIXct <- as.POSIXct(data$Year, format = '%m/%d/%y') # Change the time format to POSIXct
data$No.Of.Bananas <- as.numeric(data$No.Of.Bananas)

# 3. Create plot without image ----

d <- ggplot(data, aes(x=Year.POSIXct, y=No.Of.Bananas, fill = No.Of.Bananas)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(name="", 
                     labels = comma, 
                     minor_breaks = seq(0,5000000, 1000000), 
                     breaks=seq(0,5000000, by=1000000)) +
  scale_x_datetime(labels = date_format("'%y"),
                   breaks = date_breaks("1 year"),
                   minor_breaks = date_breaks("1 year"),
                   expand = c(0,0),
                   name = "") +
  scale_fill_gradient(high = "yellow", 
                      low = "black") +
  theme_minimal() +
  theme(plot.margin=margin(10,10,10,10), 
        legend.position="none",
        plot.caption = element_text(colour = "grey", face = "bold")) +
  labs(title="Bananas produced in Columbia", 
       subtitle = "Between 2000 and 2017", 
       caption = 'Source: github.com/TomFranklin') +
  geom_hline(yintercept=0, 
             size=0.4, 
             color="black") 

# print(d)

# 4. Download the image from the internet ----

y = "http://www.bananeramuchachitaus.com/images/slider/banana-3.jpg"
download.file(y, 'y.jpg', mode = 'wb')
jj <- readJPEG("y.jpg",native=TRUE)
g <- rasterGrob(jj)

# 5. Create the grid to place the image in ----

size = unit(2, "cm")

heights = unit.c(unit(1, "npc") - 3*size,size, size, size)
widths = unit.c(unit(1, "npc") - 3*size, size, size, size)
lo = grid.layout(4, 4, widths = widths, heights = heights)

# Show the layout; seriously, run the line of code before so you can see how it works!
grid.show.layout(lo)

# Position the elements within the grid 
grid.newpage()
pushViewport(viewport(layout = lo))

# The graph itself will sit within these rows and columns of the plot
pushViewport(viewport(layout.pos.row=1:4, layout.pos.col = 1:4))
print(d, newpage=FALSE)
popViewport()

# The image will sit here
pushViewport(viewport(layout.pos.row=1:2, layout.pos.col = 3:4))
print(grid.draw(g), newpage=FALSE)
popViewport()
popViewport()

# Save the object 
g = grid.grab()
grid.newpage()

# 6. Run this to view the plot! ----
grid.draw(g)











####