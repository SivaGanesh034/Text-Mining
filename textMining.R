library(qdap)
data('pres_debates2012')
pres_debates2012

pres_debates2012 = pres_debates2012[pres_debates2012$person=='ROMNEY',]

## Sentiment Analysis using qdap
y = polarity(pres_debates2012$dialogue)
pres_debates2012$sentiment = y$all$polarity

positive = pres_debates2012[pres_debates2012$sentiment>0,]
negative = pres_debates2012[pres_debates2012$sentiment<0,]
neutral = pres_debates2012[pres_debates2012$sentiment==0,]

###wordcloud
library(wordcloud)
library(tm)
docs = Corpus(VectorSource(positive$dialogue))
docs = tm_map(docs, removePunctuation)
docs = tm_map(docs, removeNumbers)
docs = tm_map(docs, tolower)
docs = tm_map(docs, removeWords,c(stopwords("english"),'romney','governor','make'))
docs = tm_map(docs, stripWhitespace)
docs = tm_map(docs, stemDocument)

#docs = tm_map(docs, stripWhitespace)

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

library(wordcloud)
library(RColorBrewer)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=T, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))