# Adapted from Odd Connections Inside The NASDAQ-100
# https://aschinchon.wordpress.com/2015/05/08/odd-connections-inside-the-nasdaq-100/

library("quantmod")
library("TSdist")
library("ade4")
library("ggplot2")
library("Hmisc")
library("zoo")
library("scales")
library("reshape2")
library("tseries")
library("RColorBrewer")
library("ape")
library("sqldf")
library("gridExtra")

# interesting stocks
data <- cbind(c("ADI", "DISCA", "PCAR", "PAYX", "CA", "BBBY", "FOX", "EBAY"))
data.labels<- c("Analog Devices Inc. makes semiconductors",
                "Discovery Communications Inc. is a mass media company",
                "PACCAR Inc. manufactures trucks",
                "Paychex Inc. provides HR outsourcing",
                "CA Inc. creates software",
                "Bed Bath & Beyond Inc. sells goods for home",
                "Twenty-First Century Fox Inc. is a mass media company",
                "EBAY Inc. does online auctions")

# load stocks from quantmod cache if available
if (file.exists("data/quantmod-cache.RData")) {
  load("data/quantmod-cache.RData")
  if (!(sum(sapply(data, exists)) == length(data))) {
    for (i in 1:nrow(data)) getSymbols(as.character(data[i,1]))    
  }
}
results=t(apply(combn(sort(as.character(data[,1]), decreasing = TRUE), 2), 2,
                function(x) {
                  ts1=drop(Cl(eval(parse(text=x[1]))))
                  ts2=drop(Cl(eval(parse(text=x[2]))))
                  t.zoo=merge(ts1, ts2, all=FALSE)
                  t=as.data.frame(t.zoo)
                  m=lm(ts2 ~ ts1 + 0, data=t)
                  beta=coef(m)[1]
                  sprd=t$ts1 - beta*t$ts2
                  ht=adf.test(sprd, alternative="stationary", k=0)$p.value
                  c(symbol1=x[1], symbol2=x[2], (1-ht))
                })
          )
results=as.data.frame(results)
colnames(results)=c("Sym1", "Sym2", "TSdist")
results$TSdist=as.numeric(as.character(results$TSdist))
m=as.dist(acast(results, Sym1~Sym2, value.var="TSdist"))

# Plots
opts2=theme(
  panel.background = element_rect(fill="gray98"),
  panel.border = element_rect(colour="black", fill=NA),
  axis.line = element_line(size = 0.5, colour = "black"),
  axis.ticks = element_line(colour="black"),
  panel.grid.major = element_line(colour="gray75", linetype = 2),
  panel.grid.minor = element_blank(),
  axis.text = element_text(colour="gray25", size=12),
  axis.title = element_text(size=18, colour="gray10"),
  legend.key = element_rect(fill = "white"),
  legend.text = element_text(size = 14),
  legend.background = element_rect(),
  plot.title = element_text(size = 35, colour="gray10"))

plotPair = function(...) {
  Symbol1 <- ...[1]
  Symbol2 <- ...[2]
  getSymbols(Symbol1)
  getSymbols(Symbol2)
  close1=Cl(eval(parse(text=Symbol1)))
  close2=Cl(eval(parse(text=Symbol2)))
  cls=merge(close1, close2, all = FALSE)
  df=data.frame(date = time(cls), coredata(cls))
  names(df)[-1]=c(Symbol1, Symbol2)
  df1=melt(df, id.vars = "date", measure.vars = c(Symbol1, Symbol2))
  ggplot(df1, aes(x = date, y = value, color = variable))+
    geom_line(size = I(1.2))+
    scale_color_discrete(name = "")+
    scale_x_date(labels = date_format("%Y-%m-%d"))+
    labs(x="Date", y="Closing Price")+
    opts2
}
my.pairs <- list(c("ADI", "DISCA"),
                 c("PCAR", "PAYX"),
                 c("CA", "BBBY"),
                 c("FOX", "EBAY"))

my.labels <- sapply(X = my.pairs, FUN = function(x) { paste(x, collapse = " vs ") })

