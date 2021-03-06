######################################################################################
################# Georiga Mapper ############################################
library(maps)
library(rgdal)
##############################3
setwd("F:/MEDSL/healthy_elections/GA/reportdata")
list.files()
ga_cty_stats <- read.csv("countylevelstats_simple.csv")
#ga_cty_stats_vbm <- ga_cty_stats[,grepl("VBM",colnames(ga_cty_stats))] 
#View(ga_cty_stats_vbm)
medsl_reds <- c("#EDD0CB","#F59181","#F6573E","#CD3C2B","#8D2115")
medsl_blues <- c("#9FDDF3","#00BAFF","#3791FF","#04448B","#0B2E4F")
medsl_purple <- c("#DDDBFB", "#B1AAFB","#7D76C7","#635E99",  "#4E4A81")
head(cty_cents)
cty_cents <- readRDS("counties_centroids.rds")
cty_cents <- subset(cty_cents, state_po=="GA")
nrow(cty_cents)
cty_cents <- merge(cty_cents,ga_cty_stats,by.x="GEOID",by.y="fips" )
#####good, now let's assign colors and such 
#rejection rates by race  bhreject_2020combopri whreject_2020combopri
quantile(cty_cents$BHreject_2020combopri,seq(0,1,by=0.05))
summary(cty_cents$WHreject_2020combopri)
#0 - 0.25, .25 - .5, .5 - .75, .75 - 1 
names(cty_cents)
cty_cents$color_reject_white <- medsl_reds[1]
cty_cents$color_reject_white[cty_cents$WHreject_2020combopri > 0.01 & cty_cents$WHreject_2020combopri <=0.05] <- medsl_reds[2]
cty_cents$color_reject_white[cty_cents$WHreject_2020combopri > 0.05 & cty_cents$WHreject_2020combopri <=0.1] <- medsl_reds[3]
cty_cents$color_reject_white[cty_cents$WHreject_2020combopri > 0.1 & cty_cents$WHreject_2020combopri <=0.15] <- medsl_reds[4]
cty_cents$color_reject_white[cty_cents$WHreject_2020combopri > 0.15 ] <- medsl_reds[5]
###
cty_cents$color_reject_black <- medsl_reds[1]
cty_cents$color_reject_black[cty_cents$BHreject_2020combopri > 0.01 & cty_cents$BHreject_2020combopri <=0.05] <- medsl_reds[2]
cty_cents$color_reject_black[cty_cents$BHreject_2020combopri > 0.05 & cty_cents$BHreject_2020combopri <=0.1] <- medsl_reds[3]
cty_cents$color_reject_black[cty_cents$BHreject_2020combopri > 0.1 & cty_cents$BHreject_2020combopri <=0.15] <- medsl_reds[4]
cty_cents$color_reject_black[cty_cents$BHreject_2020combopri > 0.15 ] <- medsl_reds[5]
###let's create race weights 
cty_cents$weight_white <- (cty_cents$weight*cty_cents$county_white)*1.5
cty_cents$weight_black <- (cty_cents$weight*cty_cents$county_black)*2

####now let's plot the maps
##mapping results here
#map('county', state_choice , fill = TRUE, col = "white",ylim=c(min_y,max_y),mar=c(0,0,0,0))

setwd("F:/MEDSL/healthy_elections/GA/plots_jc")
jpeg("white_reject_plot.jpg", res=600, height = 6, width =7, units = "in")
maps::map('county', "georgia" , fill = TRUE, col = "white", mar=c(2,2,2,2) )
points(cty_cents$V1,cty_cents$V2,pch=21,bg=cty_cents$color_reject_white,cex=cty_cents$weight_white)
#legend("bottom", legend = legend.text, 
#     fill = shades, title = "Per 100k",cex=0.6,bty = "n",ncol=2,xpd=TRUE)
legend("topright", legend = c("0 to 1%", "1 to 5%", "5 to 10%","10 to 15%", "15% +" ), 
       fill = medsl_reds, title = "Ballot rejections",cex=0.9,bty = "n",ncol=1,xpd = TRUE)
dev.off()
###black rejections 
jpeg("black_reject_plot.jpg", res=600, height = 6, width =7, units = "in")
maps::map('county', "georgia" , fill = TRUE, col = "white", mar=c(2,2,2,2) )
points(cty_cents$V1,cty_cents$V2,pch=21,bg=cty_cents$color_reject_black,cex=cty_cents$weight_black)
#legend("bottom", legend = legend.text, 
#     fill = shades, title = "Per 100k",cex=0.6,bty = "n",ncol=2,xpd=TRUE)
legend("topright", legend = c("0 to 1%", "1 to 5%", "5 to 10%","10 to 15%", "15% +" ), 
       fill = medsl_reds, title = "Ballot rejections",cex=0.9,bty = "n",ncol=1,xpd = TRUE)
dev.off()
##follow up scatterplot
gg_reject_race <- ggplot(cty_cents, aes(x=BHreject_2020combopri*100, y=WHreject_2020combopri*100)) +
  geom_point(aes(size=votedpop_2020combopri*10), color=medsl_reds[4],alpha=0.4) + 
  ylab("White Rej. %") + xlab("Black Rej. %") + theme_bw() + xlim(0,20) + ylim(0,20) + 
  theme(title = element_text(size = rel(1.4), family="Styrene B")) + guides(size=FALSE,alpha=FALSE) + geom_abline(intercept = 0, lty=2)
gg_reject_race
ggsave("rej_race_scatter.jpeg", plot = gg_reject_race, scale = 1, 
       width = 5, height = 4, units = c("in"), dpi = 600)




#####now let's do vbm overall VBM rates, 2016 PPP vs 2020 combined
#graph twoway (scatter bymail_2020combopri bymail_2016prepri 
quantile(cty_cents$bymail_2016prepri,seq(0,1,by=0.05))              
cty_cents$color2020vbm <- medsl_blues[1]              
cty_cents$color2020vbm[cty_cents$bymail_2020combopri > 0.4 & cty_cents$bymail_2020combopri >= 0.5] <- medsl_blues[2]              
cty_cents$color2020vbm[cty_cents$bymail_2020combopri > 0.5 & cty_cents$bymail_2020combopri >= 0.6] <- medsl_blues[3]              
cty_cents$color2020vbm[cty_cents$bymail_2020combopri > 0.6 & cty_cents$bymail_2020combopri >= 0.7] <- medsl_blues[4]              
cty_cents$color2020vbm[cty_cents$bymail_2020combopri > 0.7] <- medsl_blues[5]              
####2016 now 
cty_cents$color2016vbm <- medsl_blues[1]              
cty_cents$color2016vbm[cty_cents$bymail_2016prepri > 0.4 & cty_cents$bymail_2016prepri >= 0.5] <- medsl_blues[2]              
cty_cents$color2016vbm[cty_cents$bymail_2016prepri > 0.5 & cty_cents$bymail_2016prepri >= 0.6] <- medsl_blues[3]              
cty_cents$color2016vbm[cty_cents$bymail_2016prepri > 0.6 & cty_cents$bymail_2016prepri >= 0.7] <- medsl_blues[4]              
cty_cents$color2016vbm[cty_cents$bymail_2016prepri > 0.7] <- medsl_blues[5] 
###now the map here 
jpeg("vbm2020plot.jpg", res=600, height = 6, width =7, units = "in")
maps::map('county', "georgia" , fill = TRUE, col = "white", mar=c(2,2,2,2) )
points(cty_cents$V1,cty_cents$V2,pch=21,bg=cty_cents$color2020vbm,cex=cty_cents$weight)
#legend("bottom", legend = legend.text, 
#     fill = shades, title = "Per 100k",cex=0.6,bty = "n",ncol=2,xpd=TRUE)
legend("topright", legend = c("< 40%", "40 to 50%", "50 to 60%", "60 to 70%", '70% +' ), 
       fill = medsl_blues, title = "VBM %",cex=0.9,bty = "n",ncol=1,xpd = TRUE)
dev.off()
##2016
jpeg("vbm2016plot.jpg", res=600, height = 6, width =7, units = "in")
maps::map('county', "georgia" , fill = TRUE, col = "white", mar=c(2,2,2,2) )
points(cty_cents$V1,cty_cents$V2,pch=21,bg=cty_cents$color2016vbm,cex=cty_cents$weight)
#legend("bottom", legend = legend.text, 
#     fill = shades, title = "Per 100k",cex=0.6,bty = "n",ncol=2,xpd=TRUE)
legend("topright", legend = c("< 40%", "40 to 50%", "50 to 60%", "60 to 70%", '70% +' ), 
       fill = medsl_blues, title = "VBM %",cex=0.9,bty = "n",ncol=1,xpd = TRUE)
dev.off()
##scatterplot 
gg_vbm <- ggplot(cty_cents, aes(y=bymail_2020combopri*100, x=bymail_2016prepri*100)) +
  geom_point(aes(size=votedpop_2020combopri*10), color=medsl_blues[4],alpha=0.4) + 
  ylab("VBM 2020 %") + xlab("VBM 2016 %") + theme_bw() + xlim(0,80) + ylim(0,80) + 
  theme(title = element_text(size = rel(1.4), family="Styrene B")) + guides(size=FALSE,alpha=FALSE) + geom_abline(intercept = 0, lty=2)
gg_vbm
ggsave("vbm_scatter.jpeg", plot = gg_vbm, scale = 1, 
       width = 5, height = 4, units = c("in"), dpi = 600)



###now *overall rejection rates, 2016 PPP vs 2020 combined
# scatter rejected_2020combopri rejected_2016prepri
quantile(cty_cents$rejected_2020combopri,seq(0,1,by=0.05))
cty_cents$color2020reject <- medsl_reds[1]
cty_cents$color2020reject[cty_cents$rejected_2020combopri > 0.001 & cty_cents$rejected_2020combopri <= 0.005] <- medsl_reds[2]
cty_cents$color2020reject[cty_cents$rejected_2020combopri > 0.005 & cty_cents$rejected_2020combopri <= 0.01] <- medsl_reds[3]
cty_cents$color2020reject[cty_cents$rejected_2020combopri > 0.01 & cty_cents$rejected_2020combopri <= 0.015] <- medsl_reds[4]
cty_cents$color2020reject[cty_cents$rejected_2020combopri > 0.015] <- medsl_reds[5]
##### 2016 reject colors 
cty_cents$color2016reject <- medsl_reds[1]
cty_cents$color2016reject[cty_cents$rejected_2016prepri > 0.001 & cty_cents$rejected_2016prepri <= 0.005] <- medsl_reds[2]
cty_cents$color2016reject[cty_cents$rejected_2016prepri > 0.005 & cty_cents$rejected_2016prepri <= 0.01] <- medsl_reds[3]
cty_cents$color2016reject[cty_cents$rejected_2016prepri > 0.01 & cty_cents$rejected_2016prepri <= 0.015] <- medsl_reds[4]
cty_cents$color2016reject[cty_cents$rejected_2016prepri > 0.015] <- medsl_reds[5]
###### now the plots 
jpeg("reject2020plot.jpg", res=600, height = 6, width =7, units = "in")
maps::map('county', "georgia" , fill = TRUE, col = "white", mar=c(2,2,2,2) )
points(cty_cents$V1,cty_cents$V2,pch=21,bg=cty_cents$color2020reject,cex=cty_cents$weight)
#legend("bottom", legend = legend.text, 
#     fill = shades, title = "Per 100k",cex=0.6,bty = "n",ncol=2,xpd=TRUE)
legend("topright", legend = c("0 to 0.1%", "0.1 to 0.5%", "0.5 to 1%","1 to 1.5%", "1.5% +" ), 
       fill = medsl_reds, title = "Ballot rejections %",cex=0.9,bty = "n",ncol=1,xpd = TRUE)
dev.off()
##2016
jpeg("reject2016plot.jpg", res=600, height = 6, width =7, units = "in")
maps::map('county', "georgia" , fill = TRUE, col = "white", mar=c(2,2,2,2) )
points(cty_cents$V1,cty_cents$V2,pch=21,bg=cty_cents$color2016reject,cex=cty_cents$weight)
#legend("bottom", legend = legend.text, 
#     fill = shades, title = "Per 100k",cex=0.6,bty = "n",ncol=2,xpd=TRUE)
legend("topright", legend = c("0 to 0.1%", "0.1 to 0.5%", "0.5 to 1%","1 to 1.5%", "1.5% +" ), 
       fill = medsl_reds, title = "Ballot rejections %",cex=0.9,bty = "n",ncol=1,xpd = TRUE)
dev.off()
##scatter for rejections 
gg_rej1 <- ggplot(cty_cents, aes(y=rejected_2020combopri*100, x=rejected_2016prepri*100)) +
  geom_point(aes(size=votedpop_2020combopri*10), color=medsl_reds[4],alpha=0.4) + 
  ylab("Rejected 2020 %") + xlab("Rejected 2016 %") + theme_bw() + xlim(0,100) + ylim(0,100) + 
  theme(title = element_text(size = rel(1.4), family="Styrene B")) + guides(size=FALSE,alpha=FALSE) + geom_abline(intercept = 0, lty=2)
gg_rej1
ggsave("rej_time_scatter.jpeg", plot = gg_rej1, scale = 1, 
       width = 5, height = 4, units = c("in"), dpi = 600)



### election day voting : electionday_2020combopri electionday_2016prepri
quantile(cty_cents$electionday_2020combopri, seq(0,1,by=0.05)) # 0.1 to .39

cty_cents$color2020ed <- medsl_purple[1]
cty_cents$color2020ed[cty_cents$electionday_2020combopri > 0.2 & cty_cents$electionday_2020combopri <= 0.3] <- medsl_purple[2]
cty_cents$color2020ed[cty_cents$electionday_2020combopri > 0.3 & cty_cents$electionday_2020combopri <= 0.4] <- medsl_purple[3]
cty_cents$color2020ed[cty_cents$electionday_2020combopri > 0.4 & cty_cents$electionday_2020combopri <= 0.5] <- medsl_purple[4]
cty_cents$color2020ed[cty_cents$electionday_2020combopri > 0.5 ] <- medsl_purple[5]
###2016 colors 
cty_cents$color2016ed <- medsl_purple[1]
cty_cents$color2016ed[cty_cents$electionday_2016prepri > 0.2 & cty_cents$electionday_2016prepri <= 0.3] <- medsl_purple[2]
cty_cents$color2016ed[cty_cents$electionday_2016prepri > 0.3 & cty_cents$electionday_2016prepri <= 0.4] <- medsl_purple[3]
cty_cents$color2016ed[cty_cents$electionday_2016prepri > 0.4 & cty_cents$electionday_2016prepri <= 0.5] <- medsl_purple[4]
cty_cents$color2016ed[cty_cents$electionday_2016prepri > 0.5 ] <- medsl_purple[5]
###map now 
jpeg("electionday2020plot.jpg", res=600, height = 6, width =7, units = "in")
maps::map('county', "georgia" , fill = TRUE, col = "white", mar=c(2,2,2,2) )
points(cty_cents$V1,cty_cents$V2,pch=21,bg=cty_cents$color2020ed,cex=cty_cents$weight)
#legend("bottom", legend = legend.text, 
#     fill = shades, title = "Per 100k",cex=0.6,bty = "n",ncol=2,xpd=TRUE)
legend("topright", legend = c("< 20%", "20 to 30%", "30 to 40%","40 to 50%", "50% +" ), 
       fill = medsl_purple, title = "Election Day %",cex=0.9,bty = "n",ncol=1,xpd = TRUE)
dev.off()
jpeg("electionday2016plot.jpg", res=600, height = 6, width =7, units = "in")
maps::map('county', "georgia" , fill = TRUE, col = "white", mar=c(2,2,2,2) )
points(cty_cents$V1,cty_cents$V2,pch=21,bg=cty_cents$color2016ed,cex=cty_cents$weight)
#legend("bottom", legend = legend.text, 
#     fill = shades, title = "Per 100k",cex=0.6,bty = "n",ncol=2,xpd=TRUE)
legend("topright", legend = c("< 20%", "20 to 30%", "30 to 40%","40 to 50%", "50% +" ), 
       fill = medsl_purple, title = "Election Day %",cex=0.9,bty = "n",ncol=1,xpd = TRUE)
dev.off()
#### scatter for elections day
gg_ed_ga <- ggplot(cty_cents, aes(y=electionday_2020combopri*100, x=electionday_2016prepri*100)) +
  geom_point(aes(size=votedpop_2020combopri*10), color=medsl_purple[4],alpha=0.4) + 
  ylab("Election Day 2020 %") + xlab("Election Day 2016 %") + theme_bw() + xlim(0,100) + ylim(0,100) + 
  theme(title = element_text(size = rel(1.4), family="Styrene B")) + guides(size=FALSE,alpha=FALSE) + geom_abline(intercept = 0, lty=2)
gg_ed_ga
ggsave("elecday_time_scatter.jpeg", plot = gg_ed_ga, scale = 1, 
       width = 5, height = 4, units = c("in"), dpi = 600)


