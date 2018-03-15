# RoadGraph

Построение графа дорог Нижнего Тагила на основе данных проекта [OpenStreetMap][0]

## Результаты
+ [Список смежности][1]
+ [Список рёбер][2]
+ [Визуализация графа][3]
+ Матрица смежности (7.5 GiB)

## Инструкция по запуску (только Mac OS)
1. git clone https://github.com/magauran/RoadGraph
2. cd RoadGraph/
3. pod install
4. open RoadGraph.xcworkspace
5. ⌘R

## Алгоритм
1. [Получение][4] карты города в формате .osm (OpenStreetMap XML)
2. Парсинг xml-файла при помощи библиотеки [SWXMLHash][5]

   + Оставляем только пути с тегами ` "motorway"`, `"motorway_link"`, `"trunk"`, `"trunk_link"`, `"primary"`, `"primary_link"`, `"secondary"`, `"secondary_link"`, `"tertiary"`, `"tertiary_link"`, `"unclassified"`, `"road"` и `"residential"`.
3. Подготовка графа:

   + Все вершины сохраняем в Dictionary<String, OSMNode>.
   + Все рёбра сохраняем в Set\<OSMNode\>.
   + Для каждой вершины находим и сохраняем "соседние" вершины.
   + Удаляем все изолированные вершины.
4. Сохранение списка смежности и списка рёбер в формате .csv
5. Визуализация графа
  
   + Преобразовываем координаты из географической системы координат в прямоугольную.
   + Преобразовываем координаты в систему координат рисунка.
   + Генерируем svg-файла (либо svg + html).
   + Отображаем html-файла в WKWebView.

## Скриншот
![alt-текст][6]

[0]: https://www.openstreetmap.org/
[1]: https://raw.githubusercontent.com/magauran/RoadGraph/master/RoadGraph/Application/Resources/adjacencyList.csv
[2]: https://raw.githubusercontent.com/magauran/RoadGraph/master/RoadGraph/Application/Resources/edgeList.csv
[3]: http://htmlpreview.github.io/?https://github.com/magauran/RoadGraph/blob/master/RoadGraph/Application/Resources/graph.html
[4]: https://github.com/bruce-willis/City-Roads/blob/develop/docs/download.md#%D0%A1%D0%BF%D0%BE%D1%81%D0%BE%D0%B1-2-%D0%B0%D0%BA%D0%BA%D1%83%D1%80%D0%B0%D1%82%D0%BD%D1%8B%D0%B9-%D0%B8-%D1%82%D0%BE%D1%87%D0%BD%D1%8B%D0%B9-%D0%BD%D0%BE-%D1%82%D1%80%D0%B5%D0%B1%D1%83%D0%B5%D1%82-%D0%B2%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%B8-%D0%B8-%D0%BD%D0%B5-%D1%82%D0%B0%D0%BA%D0%BE%D0%B9-%D0%BF%D1%80%D0%BE%D1%81%D1%82%D0%BE%D0%B9---%D1%81%D0%BA%D0%B0%D1%87%D0%B0%D1%82%D1%8C-%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D0%B5-%D1%82%D0%BE%D0%BB%D1%8C%D0%BA%D0%BE-%D0%B4%D0%BB%D1%8F-%D0%B3%D0%BE%D1%80%D0%BE%D0%B4%D0%B0 "Инструкция от Юры"
[5]: https://github.com/drmohundro/SWXMLHash
[6]: https://github.com/magauran/RoadGraph/blob/master/RoadGraph/Application/Resources/screenshot.png
