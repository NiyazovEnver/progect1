
Задачи классификации
 =======================
 Метрические алгоритмы классификации 
------------------------------------------------------------------------

**Метрические методы обучения** - методы, основанные на анализе сходства объектов. Для формализации понятия сходства вводится функция расстояния между объектами ![](http://latex.codecogs.com/gif.latex?p(x_1,x_2)). Чем меньше расстояние между объектами, тем больше объекты похожи друг на друга. Метрические классификаторы опираются на гипотезу компактности, которая предполагает, что *схожим объектам чаще соответствуют схожие ответы*.

**Опр 1.1.** Метрические алгоритмы классификации с обучающей выборкой ![](https://latex.codecogs.com/gif.latex?%5Cinline%20X%5E%7Bl%7D) относят классифицируемый объект *u* к тому классу *y*, для которого суммарный вес ближайших обучающих объектов максимален.  

Ниже представлена таблица, в которой сравниваются разные алгоритмы классификации:  

| Метод         | Параметры       | Точность      |
|:------------- |:---------------:| -------------:|
| knn           | k=6             |     0.0333    |
| kwnn          | k=6,q=0.5       |     0.0466    |  
| PW.Pryamoyg   | h=0.3           |     0.04      |
| PW.Treyg      | h=0.3           |     0.04      |  
| PW.Kvartch    | h=0.3           |     0.04      |
| PW.Epanech    | h=0.3           |     0.04      |  
| PW.Gays       | h=0.1           |     0.04      |



Алгоритм k ближайших соседей (kNN)
-------------------------------------
Данный алгоритм классификации относит классифицируемый объект *z* к тому классу *y*, к которому относится большинство из *k* его ближайших соседей.    
Имеется некоторая выборка ![](https://latex.codecogs.com/gif.latex?%5Cinline%20X%5E%7Bl%7D), состоящая из объектов *x(i), i = 1, ..., l* (например, выборка ирисов Фишера), и класифицируемый объект, который обозначим *z*. Чтобы посчитать расстояние от классифицируемого объекта до остальных точек, нужно использовать функцию расстояния(Евклидово расстояние).  
Далее отсортируем объекты согласно посчитаного расстояния до объекта *z*:  
```diff
sortObjectsByDist <- function(xl, z, metricFunction = euclideanDistance) ## задаем функцию расстояния
 {
    distances <- matrix(NA, l, 2)## задаем матрицу расстояния
     for (i in 1:l)
       {
        distances[i, ] <- c(i, metricFunction(xl[i, 1:n], z)) ## считаем расстояние от классифицируемой точки до остальных точек выборки
       }

 orderedXl <- xl[order(distances[, 2]), ] ##сортируем согласно посчитаного расстояния
 return (orderedXl);
 }
```
Применяем сам метод kNN, то есть создаем функцию, которая сортирует выборку согласно нашего классифицируемого объекта *z* и относит его к классу ближайших соседей:
```diff
kNN <- function(xl, z, k)
{
 orderedXl <- sortObjectsByDist(xl, z) ## Сортируем выборку согласно классифицируемого объекта
 n <- dim(orderedXl)[2] - 1

 classes <- orderedXl[1:k, n + 1] ## Получаем классы первых k соседей
 counts <- table(classes) ## Составляем таблицу встречаемости каждого класса
 class <- names(which.max(counts)) ## Находим класс, который доминирует среди первых соседей
 return (class) ## возвращаем класс
 }

```
 В конце задаем точку *z*, которую нужно классфицировать(ее координаты, выборку и тд).  

Ниже представлен итог работы алгоритма при *k=6*.  
![knn](https://user-images.githubusercontent.com/43229815/48431971-23601980-e784-11e8-9b3a-f1736d24173b.png)   
[kNN](https://github.com/sefayehalilova/progect1/blob/master/knn.R)

**Скользящий контроль(leave-one-out) для knn**  
   
LeaveOneOut (или LOO) - простая перекрестная проверка, которая необходима, чтобы оценить при каких значениях k алгоритм knn оптимален, и на сколько он ошибается.  
Нужно проверить, как часто будет ошибаться алгоритм, если по одному выбирать элементы из обучающей выборки.  
*Алгоритм состоит в следующем*: извлечь элемент, обучить оставшиеся элементы, классифицировать извлеченный, затем вернуть его обратно. Так нужно поступить со всеми элементами выборки.  
Если классифицируемый объект xi не исключать из обучающей выборки, то ближайшим соседом xi всегда будет сам xi, и минимальное (нулевое) значение функционала LOO(k) будет достигаться при k = 1.  
Реализация самого LOO в коде выглядит так:  
```diff

for(k in Ox) {
  R <- 0 
  for(i in 1:l) {
    iris_new <- iris[-i, ] 
    z <- iris[i, 3:4]
    if(knn(iris_new, z, k) != iris[i, 5]) { 
      R <- R + 1 
    } 
  }
#после того как мы перебрали все элементы, считаем loo
  LOO <- R/l #где R накопитель ошибки, а l-количество элементов выборки
  Oy <- c(Oy, LOO)
  
#Если найденное loo оказалось меньше изначального оптимального значения, то сделаем это новое значение оптимальным и соотвественно k тоже оптимально
  if(LOO < LOO_opt) {
    LOO_opt <- LOO
    k_opt <- k
  }
}

```

*График зависимости LOO от k*:  
![loo](https://user-images.githubusercontent.com/43229815/48148795-adfbd100-e2cb-11e8-9c79-b74f736a31bd.png)  

k оптимальное (k_opt) достигается при минимальном LOO (оптимальное k равно 6).  

Алгоритм 1NN
-----------------------------------
Алгоритм ближайшего соседа(1NN) является самым простым алгоритмом клссификации.  
Данный алгоритм классификации относит классифицируемый объект u к тому классу y, к которому относится его ближайший сосед.
Для начала нужно задать метрическую функцию, затем нужно отсортировать выборку по расстояниям от точек до классфицируемой точки, после чего классифицируемый элемент относим к классу, к которому принадлежит ближайший элемент(первый в отсортированной выборке).

Имеется некоторая выборка Xl, состоящая из объектов x(i), i = 1, ..., l (снова выборка ирисов Фишера). Как и в задаче kNN, задаем функцию расстояния, считаем расстояния от классифицируемой точки до остальных точек выборки, сортируем эти расстояния.  


Далее применяем метод 1NN и классифицируем данный объект, то есть найти ближайший объект выборки и вернуть класс, к которому принадлежит наш объект:
```diff
# применяем метод 1NN
NN1 <- function(xl, point) {	  
	  orderedXl <- sortObjectsByDist(xl, point) # сортировка выборки согласно классифицируемого объекта    
	  n <- dim(orderedXl)[2] - 1 
	  class <- orderedXl[1, n + 1] # получение класса соседа
	  return (class) # возвращаем класс
}

for(i in OX){
	for(j in OY){
	  point<-c(i,j)
	  class <- NN1(xl, point) 
	  points(point[1], point[2], pch = 21, col = colors[class], asp = 1) } # классификация заданного объекта
}
```
Ниже представлен итог работы данного алгоритма:
![1nn](https://user-images.githubusercontent.com/43229815/48433796-1691f480-e789-11e8-8c17-54f60a593be9.png)   

[1NN](https://github.com/sefayehalilova/progect1/blob/master/1nn.R)  

Алгоритм k взвешенных ближайших соседей (kwNN)
----------------------------------------------------------------------  
  Имеется некоторая выборка Xl, состоящая из объектов x(i), i = 1, ..., l ( выборка ирисов Фишера). Данный алгоритм классификации относит объект u к тому классу y, у которого максимальна сумма весов w_i его ближайших k соседей x(u_i), то есть объект относится к тому классу, который набирает больший суммарный вес среди k ближайших соседей.  
  В алгоритме kwNN используется весовая функция, которая оценивает степень важности при классификации заданного элемента к какому-либо классу, что и отличает его от алгоритма kNN.  
  kwNN отличается от kNN, тем что учитывает порядок соседей классифицируемого объекта, улучшая качество классификации.  
  Весовая функция kwNN выглядит следующим образом:  
  ```diff
for(i in 1:l) {
       weights[i] <- q^i
    }
```    
Сама функция выглядит так:  
  ```diff
distances <- matrix(NA, l, 2)# расстояния от классифицируемого объекта u до каждого i-го соседа 
    for(p in 1:l) {
      distances[p, ] <- c(p, euclideanDistance(xl[p, 1:n], z))
    }
    orderedxl <- xl[order(distances[ , 2]), ]# сортировка расстояний
    
    weights <- c(NA)# подсчёт весов для каждого i-го объекта
    for(i in 1:l) {
       weights[i] <- q^i 
    }
    orderedxl_weighted <- cbind(orderedxl, weights)
    classes <- orderedxl_weighted[1:k, (n + 1):(n + 2)] # названия первых k ближайших соседей и их веса
    sumSetosa <- sum(classes[classes$Species == "setosa", 2])
    sumVersicolor <- sum(classes[classes$Species == "versicolor", 2])
    sumVirginica <- sum(classes[classes$Species == "virginica", 2])
    answer <- matrix(c(sumSetosa, sumVersicolor, sumVirginica), 
                  nrow = 1, ncol = 3, byrow = TRUE, list(c(1), c('setosa', 'versicolor', 'virginica')))#матрица имен классов и их сумм весов, которая заполняется по строкам
points(z[1], z[2], pch = 21, col = colors[which.max(answer)], asp=1) #закрашиваем точки в тот цвет класса, чей вес максимальный
```    
Результат работы алгоритма:  
![kwnn](https://user-images.githubusercontent.com/43229815/48442083-3253c580-e79e-11e8-879e-847b926014df.png)  
*Ниже представлен график зависимости LOO от q*:  

![wknnloo](https://user-images.githubusercontent.com/43229815/48499976-cd09de00-e84a-11e8-918d-baa683dad670.png)  

Метод Парзеновского окна  
---------------------------------  
Имеется некоторая выборка Xl, состоящая из объектов x(i), i = 1, ..., l (в нашем случае выборка ирисов Фишера).  
В данном алгоритме используется такая весовая функция, которая зависит от расстояния между классфицируемым объектом и его соседями, тогда как в алгоритме взвешенных kNN весовая функция зависела от ранга соседа.  
Весовая функция для данного алгоритма выглядит так:  
![](https://camo.githubusercontent.com/7c2ed26a40e7613a600b2f6a7cf6fbe7341bd68b/68747470733a2f2f6c617465782e636f6465636f67732e636f6d2f6769662e6c617465783f5725323869253243253230752532392532302533442532304b2535436c6566742532302532382532302535436672616325374225354372686f25323025323875253243253230785f2537427525374425354525374269253744253239253744253742682537442532302535437269676874253230253239), где K(z)-функция ядра, а h-ширина окна.  

Используют 5 ядер:  
*1.* прямоугольное:  
![](https://camo.githubusercontent.com/025171a6fc01cd4b059c86262757f8d3a8acd6ed/68747470733a2f2f6c617465782e636f6465636f67732e636f6d2f6769662e6c617465783f4b2532387a2532392532302533442532302535436672616325374231253744253742322537442535422537437a25374325323025334325334425323031253544).  
*2.* треугольное:  
![](https://camo.githubusercontent.com/a513b3e1d90529afd518141b2bb2e5cd279d588c/68747470733a2f2f6c617465782e636f6465636f67732e636f6d2f6769662e6c617465783f4b2532387a253239253230253344253230253238312532302d2532302537437a2537432532392535422537437a25374325323025334325334425323031253544).  
*3.* квартическое:  
![](https://camo.githubusercontent.com/9621b1489712f591c395330ef15e6456097b13fc/68747470733a2f2f6c617465782e636f6465636f67732e636f6d2f6769662e6c617465783f4b2532387a25323925323025334425323025354366726163253742313525374425374231362537442a253238312532302d2532307a253545253742322537442532392535422537437a25374325323025334325334425323031253544).  
*4.* Епанечникова:  
![](https://camo.githubusercontent.com/046fe35bcec11a1aad941201159c6b72111d3bf5/68747470733a2f2f6c617465782e636f6465636f67732e636f6d2f6769662e6c617465783f4b2532387a2532392532302533442532302535436672616325374233253744253742342537442a253238312532302d2532307a253545322532392535422537437a25374325323025334325334425323031253544).  
*5.* Гауссовское:  
![](https://camo.githubusercontent.com/639585d43d5e398c76c8240cdcb79f1600056192/68747470733a2f2f6c617465782e636f6465636f67732e636f6d2f6769662e6c617465783f4b2532387a253239253230253344253230253238253238322535437069253239253545253742253545253742253238253543667261632537422d31253744253742322537442537442532392537442532392a65253545253742253238253543667261632537422d7a2535453225374425374232253744253239253744).  

Программная реализация данных функций:  
 ```diff
RectangularКernel = function(z){
  return ((0.5 * (abs(z) <= 1) )) #функция прямоугольного ядра
}
TriangularKernel = function(z){
  return ((1 - abs(z)) * (abs(z) <= 1)) #функция для треугольного ядра
}
QuarticKernel = function(z){
  return ((15 / 16) * (1 - z ^ 2) ^ 2 * (abs(z) <= 1)) #функция для квартического ядра
}
EpanechnikovKernel = function(z){
  return ((3/4*(1-z^2)*(abs(z)<=1))) #функция для ядра Епанечникова
}
GaussianKernel = function(z){
  (((2*pi)^(-1/2)) * exp(-1/2*z^2)) #функция для Гауссовского ядра
}
```  
Программная реализация самой функции PW:  

 ```diff
PW <- function(xl,point, h)
{
    weight <- matrix(NA, l, 2) #матрица расстояний и весов
    for (p in 1:l) {
      weight[p, 1] <- euclideanDistance(xl[p, 1:n], point) # расстояния от классифицируемого объекта u до каждого i-го соседа
      z <- weight[p, 1] / h # аргумент функции ядра
      cores <- c(RectangularКernel(z), TriangularKernel(z), QuarticKernel(z), EpanechnikovKernel(z), GaussianKernel(z)) #функции ядер
      
      weight[p, 2] <- cores[2] # подсчёт веса для треугольного ядра
    }
    
     
    colnames(classes) <- c("Distances", "Weights", "Species")
    
   
    sumSetosa <- sum(classes[classes$Species == "setosa", 2])
    sumVersicolor <- sum(classes[classes$Species == "versicolor", 2])
    sumVirginica <- sum(classes[classes$Species == "virginica", 2])
    answer <- matrix(c(sumSetosa, sumVersicolor, sumVirginica), 
                     nrow = 1, ncol = 3, byrow = T, list(c(1), c('setosa', 'versicolor', 'virginica')))
    if(answer[1,1]==0&&answer[1,2]==0&&answer[1,3]==0){
      class='white'
    }
    else{
      class = colors[which.max(answer)]
    }
    return(class)
} 
```   
Ниже представлены результаты работы алгоритма с разными ядрами, также посчитано LOO:  
**1**.  
![pw pryamoyg](https://user-images.githubusercontent.com/43229815/49181737-31f42680-f369-11e8-819f-c2457385d396.png)  
**2**.  
![pw treyg](https://user-images.githubusercontent.com/43229815/49181026-5949f400-f367-11e8-9ea7-a1e174a8edb1.png)  
**3**.  
![pw kvar](https://user-images.githubusercontent.com/43229815/49182335-11c56700-f36b-11e8-8120-cc4e62c8b664.png)  
**4**.  
![pw epanch](https://user-images.githubusercontent.com/43229815/49182767-340bb480-f36c-11e8-87ed-a45b74fa17a8.png)  
**5**.  
![pw gayss](https://user-images.githubusercontent.com/43229815/49183543-3707a480-f36e-11e8-9f13-531ebbcda207.png)  










Байесовские классификаторы.
=====================================  
Байесовский подход основан на следующей теореме: *если плотности распределения классов известны, то алгоритм классификации, имеющий минимальную вероятность ошибок, можно выписать в явном виде*.  
Чтобы классифицировать точку, для начала, нужно вычислить функции правдоподобия каждого из классов, затем вычислить апостериорные вероятности классов. Классифицируемый объект относится к тому классу, у которого апостериорная вероятность максимальна.  
**Байесовское решающее правило**:  
![](https://camo.githubusercontent.com/cfb0e23e2816ceaed4e85bec306e0b71d1f16ceb/68747470733a2f2f6c617465782e636f6465636f67732e636f6d2f6769662e6c617465783f61253238782532392532302533442532306172672532302535436d61785f25374279253230253543657073696c6f6e253230592537442535436c616d6264612532305f25374279253744502532387925323925354372686f2532387825374379253239)

"Наивный" байесовский классификатор.
----------------------------------------------------  
Все объекты выборки X описываются n числовыми признаками fj, где j=1,..,n. Эти признаки являются независимыми случайными величинами.
Функции правдоподобия классов выглядят так:  
py(x) = py1(ξ1)⋅⋅⋅pyn(ξn), где pyj(ξj) плотность распределения значений j-го признака для класса y.  
Эмпирическая оценка n-мерной плотности:  
![](https://camo.githubusercontent.com/fee3006512d8bad465e8973b1e6c6d9bf3ed020b/68747470733a2f2f6c617465782e636f6465636f67732e636f6d2f6769662e6c617465783f253543686174253742702537445f682532387825323925323025334425323025354366726163253742312537442537426d25374425323025354373756d5f25374269253230253344253230312537442535452537426d25374425323025354370726f645f2537426a253230253344253230312537442535452537426e2537442532302535436672616325374231253744253742685f6a2537442532304b2532302535436c65667425323825323025354366726163253742665f6a253238782532392532302d253230665f6a253238785f69253239253239253239253744253742685f6a2537442532302535437269676874253230253239), где x -- классифицируемая точка, x_i -- точки обучающей выборки, h -- ширина окна, m -- кол-во точек выборки, n -- кол-во признаков, K -- функция ядра, f_j -- признаки.    
Подставив в байесовское решающее правило эмпирические оценки одномерных плотностей признаков получим алгоритм, который называется   **"наивным" байесовким классификатором**.  
![](https://github.com/PavlyukovVladimir/SMPR/blob/master/img/naivnyy_bayes.jpg)
















  
  
 

