 Задачи классификации
 =======================
 Метрические алгоритмы классификации 
------------------------------------------------------------------------
Во многих прикладных задачах намного легче измерять степень сходства объектов, чем составлять признаковые описания.
Например, такие сложные объекты, как ***фотографии лиц, подписи, временные ряды или первичные структуры белков*** естественнее сравнивать непосредственно с друг с другом путём некоторого «наложения с выравниванием», чем изобретать какие-то признаки и сравнивать признаковые описания. Если мера сходства объектов введена достаточно удачно, то, как правило, оказывается, что ***схожим объектам чаще соответствуют схожие ответы***. В задачах классификации это означает, что классы образуют компактно локализованные подмножества. Это предположение принято называть **гипотезой компактности**. Поэтому для решения таких задач необходимо ознакомиться с ***метрическими алгоритмами***.

**Метрические методы обучения** - методы, основанные на анализе сходства объектов.
Мерой близости называют функцию расстояния . Чем меньше расстояние между объектами, тем больше объекты похожи друг на друга.

**Опр 1.1.** Метрические алгоритмы классификации с обучающей выборкой X_l относят объект u к тому классу y, для которого суммарный вес ближайших обучающих объектов  максимален(здесь формулу вставить).

Функция  называется оценкой близости объекта u к классу y. Выбирая различную весовую функцию w(i, u) можно получать различные метрические классификаторы.


 Алгоритм k ближайших соседей (kNN)
-------------------------------------
Имеется некоторая выборка Xl, состоящая из объектов x(i), i = 1, ..., l (допустим, выборка ирисов Фишера, в нашем случае).   
Данный алгоритм классификации относит классифицируемый объект u к тому классу y, к которому относится большинство из k его ближайших соседей x(u_i).

Для оценки близости классифицируемого объекта u к классу y алгоритм kNN использует следующую функцию:(формулу)

 , где i -- порядок соседа по расстоянию к классифицируемому объекту u.



Реализация алгоритма: kNN

(вставить скрины)

### Преимущества:

1. Простота реализации и возможность введения различных модификаций весовой функции w(i,u).
2. При k, подобранном около оптимального, алгоритм "неплохо" классифицирует.
3. "Прецедентная" логика работы алгоритма, хорошо понятна экспертам в таких предметных областях, как медицина, биометрия, юриспруденция и др.

### Недостатки:
------------
1. Приходится хранить всю обучающую выборку целиком.
2. При k = 1 неустойчивость к погрешностям (выбросам -- объектам, которые окружены объектами чужого класса), 
вследствие чего этот выброс классифицировался неверно и окружающие его объекты, для которого он окажется ближайшим, тоже.
3. При k = l алгоритм наоборот чрезмерно устойчив и вырождается в константу.
4. Максимальная сумма объектов в counts может достигаться в нескольких классах одновременно.
5. "Скудный" набор параметров.
6. Точки, расстояние между которыми одинаково, не все будут учитываться.

Алгоритм 1NN
-----------------------------------
  
Данный алгоритм классификации относит классифицируемый объект u к тому классу y, к которому относится его ближайший сосед.
Единственное достоинство этого алгоритма - простота реализации.

### Недостатков больше:
-----------
1. Данный алгорритм неустойчив к погрешностям. Если среди обучающих объеков есть выброс - объект, находящийся в окружении объектов чужого класса, 
то не только он сам будет классифицирован неверно, но те окружающие его объекты, для которых он окажется ближайшим, также будут класифицированы неверно.
2. Отсутсвие параметров, которые можно было бы настраивать по выборке.
Алгоритм полностью зависит от того, насколько удачно выбрана метрика p(расстояния).
3. В результате - низкое качество классификации.

Описание кода:
Имеется некоторая выборка Xl, состоящая из объектов x(i), i = 1, ..., l (снова выборка ирисов Фишера). 
Далее необходимо задать функцию эвклидова расстояния, которая выглядит следующим образом(формула с объяснением).
Затем сортируем объекты выборки согласно заданной функции расстояния. 
Создаем матрицу расстояний, где находим
расстояния от классифицируемой точки до остальных точек.

После проделанного пишем саму функцию 1NN.  
Здесь найти ближайший объект выборки и в конечном итоге вернуть класс, к которому принадлежит наш объект.  
