setwd("~/G_WD/swattingham")
library(XML)
library(reshape2)
library(ggplot2)

raw_dat = readHTMLTable("http://games.espn.go.com/flb/standings?leagueId=180523&seasonId=2016")
dat = raw_dat$statsTable
dat = dat[3:nrow(dat), 2:14]
dat$V3 = NULL
dat$V9 = NULL
colnames(dat) = c("TEAM", "R", "HR", "RBI", "SB", "OBP", "K", "W", "SV", "ERA", "WHIP")
rownames(dat) = dat$TEAM
dat$TEAM = NULL

for(i in colnames(dat[,1:10])) {
    if(i == "ERA" | i == "WHIP"){
        dat[[paste(i, 'RANK', sep = " ")]][order(dat[[i]], decreasing = FALSE)] = 1:nrow(dat)
    }else{
        dat[[paste(i, 'RANK', sep = " ")]][order(dat[[i]], decreasing = TRUE)] = 1:nrow(dat)
    }
}

dat$RANK = rowMeans(dat[,11:length(colnames(dat))])

result = dat[order(dat$RANK),]
result = result[,"RANK", drop = FALSE]
colnames(result) = as.character(Sys.Date())
result

## write.csv(result, paste(getwd(), "/cat_rankings.csv", sep = ""))

ranks = read.csv('cat_rankings.csv', row.names = 1, check.names = FALSE)
ranks = merge(ranks, result, by = "row.names")
rownames(ranks) = ranks$Row.names
ranks$Row.names = NULL
ranks = ranks[order(ranks[,length(colnames(ranks))]),]
write.csv(ranks, paste(getwd(), "/cat_rankings.csv", sep = ""))

plot_ranks = t(ranks)
plot_ranks = melt(plot_ranks, id="Date")
colnames(plot_ranks) = c("Date", "Team", "Rank")
plot = ggplot(data=plot_ranks, aes(x=Date, y=Rank, group = Team, colour = Team)) + geom_line()
plot = plot + scale_y_reverse() + ggtitle("SwattingHAM Scoring Category Rankings")

png(filename="/Users/TimHealy/G_WD/swattingham/rank_chart.png")
plot(plot)
dev.off()

quit(save='no')
