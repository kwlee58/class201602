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
pgData <- getPage("stat.in.life", token=fb_oauth, since="2016/08/30", until="2016/09/28")
si <- subset(pgData, comments_count > 1)

nop <- length(si$id)
comments <- data.frame(from_id=NULL, from_name=NULL, meaage=NULL, post_id=NULL)
for(i in 1:nop) {
  tmp <- getPost(si$id[i], token=fb_oauth, comments=TRUE)
## post id
  post.id <- tmp$post$id 
## user id : comments  
##  comments.user <- tmp$comments$from_id
##  comments.name <- tmp$comments$from_name
##  comments.message <- tmp$comments$message
  tmp2 <- tmp$comments[, c("from_id", "from_name", "message")]
  tmp2$post_id <- rep(post.id, nrow(tmp2))
  comments <- rbind(comments, tmp2)
}

str(comments)

comments$wc <- word_count(comments$message)
table(comments$from_name)
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
