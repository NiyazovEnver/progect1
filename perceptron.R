
lossPerceptron <- function(x)
{
return (max(-x, 0))
}

#������������ ��������� ������
trainingSampleNormalization <- function(xl) {
  n <- dim(xl)[2] - 1
  for (i in 1:n) {
    xl[, i] <- (xl[, i] - mean(xl[, i])) / sd(xl[, i])
  }
  return(xl)
}

# ���������� ������� �� -1 ��� w0
trainingSamplePrepare <- function(xl) {
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  xl <- cbind(xl[, 1:n], seq(from = -1, to = -1, length.out = l), xl[, n + 1])
}

# ��������� ����� ��������������� ���������
sg <- function(xl, eta = 0.2, lambda = 1/60) {
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  
  # ����������� ������������� ����� w
  w <- c(1/2, 1/2, 1/2)

  iterCount <- 0
  # ���������� Q
  Q <- 0
  for (i in 1:l) {
    wx <- sum(w * xl[i, 1:n])
    margin <- wx * xl[i, n + 1]
    Q <- Q + lossPerceptron(margin)
  }
  repeat {

  margins <- array(dim = l)
   for (i in 1:l)
    {
     xi <- xl[i, 1:n]
     yi <- xl[i, n + 1]
     margins[i] <- crossprod(w, xi) * yi ##������� ������
    }

errorIndexes <- which(margins <= 0) ##�������������� �������, �� ������� ����������� ������
    
if (length(errorIndexes) > 0)
{
    # ��������� ������� �������� ������ �� �������� ������
    i <- sample(1:l, 1)
    iterCount <- iterCount + 1
    xi <- xl[i, 1:n]
    yi <- xl[i, n + 1]
    
    wx <- crossprod(w, xi)
    margin <- wx * yi
    ex <- lossPerceptron(margin)
    w <- w + eta * yi * xi ##����������� ����������� ��� ��� ��������
    
    Qprev <- Q
    Q <- (1 - lambda) * Q + lambda * ex ##��������� Q
  
    } else
  {
      break
    }
  }
  return(w) 
}

test <- function(ObjectsCountofEachClass) {
  library(MASS)
  sigma <- matrix(c(3,0,0,7),2,2)
  
  xy1 <- mvrnorm (ObjectsCountofEachClass,c(1,1),sigma)
  xy2 <- mvrnorm (ObjectsCountofEachClass,c(9,7),sigma)
  
  xl <- rbind(cbind(xy1, 1), cbind(xy2, -1))
  print(xl);
 
  xlNorm <- trainingSampleNormalization(xl)
  xlNorm <- trainingSamplePrepare(xlNorm)
  
  colors <- c("green2", "red")
  plot(xlNorm[, 1], xlNorm[, 2], pch = 21, asp = 1, main="�������� ��������� �������������. ����������� �����������.")
  
  for (i in 1:dim(xlNorm)[1]) {
    points(xlNorm[i, 1], xlNorm[i, 2], pch = 21, bg = colors[ifelse((xl[i, 3] < 0), 1, 2)], asp = 1)
  }
  w <- sg(xlNorm)
  print(w)

  abline(a = w[3] / w[2], b = -w[1] / w[2], lwd = 3, col = "orange")
  

}


test(60)