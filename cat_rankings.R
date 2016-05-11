library(XML)
raw_dat = readHTMLTable("http://games.espn.go.com/flb/standings?leagueId=180523&seasonId=2016")
dat = raw_dat$statsTable
dat = dat[3:nrow(dat), 2:14]
dat$V3 = NULL
dat$V9 = NULL
colnames(dat) = c("TEAM", "R", "HR", "RBI", "SB", "OBP", "K", "W", "SV", "ERA", "WHIP")
rownames(dat) = dat$TEAM
dat$TEAM = NULL

for(i in colnames(dat)) {
    dat[[paste(i, 'RANK', sep = " ")]][order(dat[[i]])] = 1:nrow(dat)
}


