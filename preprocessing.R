library(dplyr)
library(tm)

setwd(dir = "/Users/mehrgoltiv/Desktop/AI4GoodHack")

a = read.csv("Fact-ory dataset - CBC News.csv", stringsAsFactors = F)
b = read.csv("Fact-ory dataset - CNN.csv", stringsAsFactors = F)
c = read.csv("Fact-ory dataset - Globe and Mail.csv", stringsAsFactors = F)
d = read.csv("Fact-ory dataset - LA Times.csv", stringsAsFactors = F)
e = read.csv("Fact-ory dataset - Montreal Gazette.csv", stringsAsFactors = F)
f = read.csv("Fact-ory dataset - National Post.csv", stringsAsFactors = F)
g = read.csv("Fact-ory dataset - Washington Post.csv", stringsAsFactors = F)
h = read.csv("Fact-ory dataset - Pittsburgh Post-Gazette (1).csv", stringsAsFactors = F)
i = read.csv("Fact-ory dataset - The State.csv")

#merge
full_df = Reduce(function(...) merge(..., all=TRUE), list(a, b, c, d, e, f, g, h, i))

#filter missing rows
full_df = full_df %>% filter(Text != "")     

#turn label column to lower
full_df$Label = sapply(full_df$Label, tolower)
full_df$Title = sapply(full_df$Title, tolower)
full_df$Text = sapply(full_df$Text, tolower)

#stopwords = list(tm::stopwords())
sw = c("a", "an", "the", "of", "and", "if", "to", "in" )
full_df$Text = tm::removeWords(full_df$Text, sw)

#extra_clean = c("washington (cnn) ", "seoul, south korea (cnn) ", "(cnn) ", "ottawa — ")
#full_df$Text = tm::removeWords(full_df$Text, extra_clean)

full_df$Text = stringr::str_replace_all(full_df$Text, " u.s. " , " united states ")
full_df$Title = stringr::str_replace_all(full_df$Title, " u.s. " , " united states ")

full_df$Text = textclean::replace_contraction(full_df$Text, contraction.key = lexicon::key_contractions,
                                              ignore.case = TRUE)

full_df$Text = stringr::str_replace_all(full_df$Text, "it's" , "it is")
full_df$Title = stringr::str_replace_all(full_df$Title, "it's" , "it is")

full_df$Text = stringr::str_replace_all(full_df$Text, "isn't" , "is not")
full_df$Title = stringr::str_replace_all(full_df$Title, "isn't" , "is not")

full_df$Text = stringr::str_replace_all(full_df$Text, "can't" , "cannot")
full_df$Title = stringr::str_replace_all(full_df$Title, "can't" , "cannot")

full_df$Text = stringr::str_replace_all(full_df$Text, "won't" , "will not")
full_df$Title = stringr::str_replace_all(full_df$Title, "won't" , "will not")

full_df$Text = stringr::str_replace_all(full_df$Text, "don't" , "do not")
full_df$Title = stringr::str_replace_all(full_df$Title, "don't" , "do not")

full_df$Text = stringr::str_replace_all(full_df$Text, "doesn't" , "does not")
full_df$Title = stringr::str_replace_all(full_df$Title, "doesn't" , "does not")

full_df$Text = stringr::str_replace_all(full_df$Text, "didn't" , "did not")
full_df$Title = stringr::str_replace_all(full_df$Title, "didn't" , "did not")

full_df$Text = stringr::str_replace_all(full_df$Text, "[.]" , " ")
full_df$Text = stringr::str_replace_all(full_df$Text, "[,]" , "")
full_df$Title = stringr::str_replace_all(full_df$Title, "[.]" , " ")
full_df$Title = stringr::str_replace_all(full_df$Title, "[,]" , "")

full_df$Text = gsub("(\\.+|[[:punct:]])", " \\1 ", full_df$Text)
full_df$Text = stringr::str_replace_all(full_df$Text, ":", " : ")

full_df$Title = gsub("(\\.+|[[:punct:]])", " \\1 ", full_df$Title)
full_df$Title = stringr::str_replace_all(full_df$Title, ":", " : ")

full_df$Text = stringr::str_replace_all(full_df$Text, "[\r\n]" , "")
full_df$Title = stringr::str_replace_all(full_df$Title, "[\r\n]" , "")

full_df$Title = stringr::str_replace_all(full_df$Title, "é" , "e")
full_df$Text = stringr::str_replace_all(full_df$Text, "é" , "e")

full_df$Title = stringr::str_replace_all(full_df$Title, "ç" , "c")
full_df$Text = stringr::str_replace_all(full_df$Text, "ç" , "c")

full_df$Title = stringr::str_replace_all(full_df$Title, "è" , "e")
full_df$Text = stringr::str_replace_all(full_df$Text, "è" , "e")

full_df$Title = stringr::str_replace_all(full_df$Title, "ë" , "e")
full_df$Text = stringr::str_replace_all(full_df$Text, "ê" , "e")

full_df$Title = stringr::str_replace_all(full_df$Title, "’" , "'")
full_df$Text = stringr::str_replace_all(full_df$Text, "’" , "'")

full_df$Title = stringr::str_replace_all(full_df$Title, "“" , "'")
full_df$Text = stringr::str_replace_all(full_df$Text, "“" , "'")

full_df$Title = stringr::str_replace_all(full_df$Title, "”" , "'")
full_df$Text = stringr::str_replace_all(full_df$Text, "”" , "'")


#Bag of words
write.csv(full_df, "Ai4good_pre.csv")

#LSA
dir(path = "/Users/mehrgoltiv/Desktop/AI4good")
myMatrix = lsa::textmatrix(full_df)
myMatrix = lw_logtf(myMatrix) * gw_idf(myMatrix)
myLSAspace = lsa(myMatrix, dims=dimcalc_share())
as.textmatrix(myLSAspace)
# clean up
unlink(td, recursive=TRUE)


