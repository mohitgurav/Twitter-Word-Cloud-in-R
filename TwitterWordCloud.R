"
1.Install package Twitter,RCurl
install.packages('twitteR', dependencies=TRUE)
install.packages('RCurl')
install.packages('bitops')
install.packages('base64enc')
install.packages('httpuv')
install.packages('tm')
install.packages('wordcloud')
install.packages('stringr')
library(twitteR)
library(RCurl)
library(bitops)
library(base64enc)
library(httpuv)
library(tm)
library(wordcloud)
library(stringr)
Open Twiiter account
Sign in to developer.twitter.com
Application details
Name: Unique
Description: At least 10 characters
Website: http://test.de/
Cashback URL: empty
API has been created.
API key
API server
Access Token
Access Token Secret
Other info:
Owner
Owner ID
"
options(stringsAsFactors = FALSE)

"
consumer_key <- 'your key'
consumer_secret <- 'your access'
access_token <- 'your access token'
access_secret <- 'your access secret'
"
#read.table reads csv and delimited files
oauthCreds = read.table(cred_file,header=TRUE)

tweets_list = searchTwitter("India + South Africa + IND + SA",lang="en",n=300,resultType="recent")
class(tweets_list)
tweets_list

tweets_text = sapply(tweets_list, function(x) x$getText())
class(tweets_text)

tweets_text[1]

tweets_corpus = Corpus(VectorSource(tweets_text))
class(tweets_corpus)
tweets_corpus
inspect(tweets_corpus[1:3])

#preprocessing pipeline
#strip white space
#remove number
#remove stop words
#tolower
#pattern
#tospace
tweets_corpus_clean = tm_map(tweets_corpus, removePunctuation)
tweets_corpus_clean = tm_map(tweets_corpus_clean, stripWhitespace)
tweets_corpus_clean = tm_map(tweets_corpus_clean, removeNumbers)
tweets_corpus_clean = tm_map(tweets_corpus_clean, removeWords, stopwords("english"))
tweets_corpus_clean = tm_map(tweets_corpus_clean, content_transformer(tolower))
toSpace = content_transformer(function(x, pattern) gsub(pattern,"",x))
tweets_corpus_clean = tm_map(tweets_corpus_clean, toSpace,"https*|youtu*")

tweets_corpus_clean
#not actually a matrix
tweets_tdm = TermDocumentMatrix(tweets_corpus_clean)
#internal representation
str(tweets_tdm)
#convert to matrix
tweets_tdm = as.matrix(tweets_tdm)
tweets_tdm

tdm_term_freq_sort = sort(rowSums(tweets_tdm), decreasing=TRUE)

tdm_term_freq_sort_inc = sort(rowSums(tweets_tdm), decreasing=FALSE)

tdm_term_freq_df = data.frame(word = names(tdm_term_freq_sort),
                              freq = tdm_term_freq_sort)
str(tdm_term_freq_df)
head(tdm_term_freq_df,10)

wordcloud(words=tdm_term_freq_df$word,freq=tdm_term_freq_df$freq,min.freq = 8, max.words = 300, random.order = FALSE, rot.per = 0.35, colors = brewer.pal(8,'Dark2'),
          scale=c(3,0.5))
#homework- add stop words that are not required- customisation