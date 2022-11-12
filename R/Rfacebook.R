install.packages("Rfacebook")
install.packages("Rook")
install.packages("qdap")
library(Rfacebook)
library(Rook)
library(qdap)

fb_oauth <- fbOAuth(app_id="1241897489200219", app_secret="7c7e9f2041f6ed04ff989cd061691f2b",extended_permissions=TRUE)
#save(fb_oauth, file="FBoauth")
#load("FBoauth")
me <- getUsers("me", token=fb_oauth)
me
pgData1 <- getPage("stat.in.life", token=fb_oauth, since="2016/08/30", until="2016/09/30")
pgData2 <- getPage("stat.in.life", token=fb_oauth, since="2016/10/01", until="2016/10/31")
pgData3 <- getPage("stat.in.life", token=fb_oauth, since="2016/11/01", until="2016/11/15")
pgData4 <- getPage("stat.in.life", token=fb_oauth, since="2016/11/16", until="2016/12/12")

si1 <- subset(pgData1, comments_count > 42)
si2 <- subset(pgData2, comments_count > 42)
si3 <- subset(pgData3, comments_count > 42)
si4 <- subset(pgData4, comments_count > 42)

si <- rbind(si1, si2, si3, si4)
si
nop <- length(si$id)
rownames(si) <- 1:nop

comments <- data.frame(from_id=NULL, from_name=NULL, message=NULL, created_time=NULL, post_id=NULL, post_time=NULL)
for(i in 1:nop) {
  tmp <- getPost(si$id[i], token=fb_oauth, comments=TRUE)
## post id
  post.id <- tmp$post$id 
  post.time <- tmp$post$created_time
## user id : comments  
##  comments.user <- tmp$comments$from_id
##  comments.name <- tmp$comments$from_name
##  comments.message <- tmp$comments$message
  tmp2 <- tmp$comments[, c("from_id", "from_name", "message", "created_time")]
  tmp2$post_id <- rep(post.id, nrow(tmp2))
  tmp2$post_time <- rep(post.time, nrow(tmp2))
  comments <- rbind(comments, tmp2)
}
str(comments)
head(comments)
sum(si$comments_count)

str(comments)

#time
comments$created_time <- gsub("T", " ", comments$created_time)
comments$created_time <- gsub("[+]0000", "", comments$created_time)

comments$post_time <- gsub("T", " ", comments$post_time)
comments$post_time <- gsub("[+]0000", "", comments$post_time)

comments$created_time <-as.POSIXct(comments$created_time)
comments$post_time <-as.POSIXct(comments$post_time)

comments$timediff <- floor(difftime(comments$created_time, comments$post_time) /24) 

comments

comments$wc <- word_count(comments$message)
table(comments$from_name)
table(comments$post_id)

# 제출여부
table(comments$from_name, comments$post_id)

tapply(comments$wc, comments$from_name, mean)


#################################################################33333333





tmp <- getPost(si$id[i], token=fb_oauth, comments=TRUE)
tmp$post
tmp$comments
p1 <- getPost("137885989597049_1151394304912874", token=fb_oauth, comments=TRUE)
p1
str( p1$comments )
c1 <- p1$comments
nchar(c1$message[1])
c1.u1 <- getUsers(c1$from_id[1], token=fb_oauth)


word_count(c1$message[1])
character_table(c1$message[1])


my_friends <- getFriends(token=fb_oauth, simplify=TRUE)
mat <- getNetwork(token=fb_oauth, format = "adj.matrix")
