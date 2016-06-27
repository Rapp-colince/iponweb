-- Выбрать записи из parent, для которых количество записей в leaf максимально
SELECT name
FROM parent, (
    SELECT parent_id
    FROM leaf
    GROUP BY parent_id
    HAVING COUNT(*) = (SELECT COUNT(*) FROM leaf GROUP BY parent_id LIMIT 1)
    ) as parent_max
WHERE parent_max.parent_id = parent.id




-- Выбрать 10 самых часто встречающихся значений name в parent
SELECT name
FROM parent, (
        SELECT parent_id, COUNT(*) as count
        FROM leaf
        GROUP BY parent_id
        ORDER BY count DESC
        LIMIT 10
    ) as parent_max
WHERE parent_max.parent_id = parent.id




-- Выбрать записи из parent, для которых в leaf не существует alias, длина которого > 5 символов.
-- Какие индексы можно создать, чтобы ускорить этот запрос?
SELECT DISTINCT(name)
FROM parent
    LEFT JOIN leaf
        ON leaf.parent_id = parent.id
        AND LENGTH(leaf.alias) > 5
WHERE leaf.alias IS NULL
CREATE INDEX parent_alias ON leaf(parent_id, alias(6));




-- Предположим, к leaf из предыдущего примера делаются 2 вида запросов:
-- Какие индексы можно создать для ускорения этих запросов? Поясните свой ответ
-- select * from leaf where parent_id = ? and alias = ?
-- select * from leaf where parent_id = ?


-- Для выставления индексов нужно понять селективность полей
SELECT COUNT(*) FROM leaf GROUP BY parent_id
SELECT COUNT(*) FROM leaf GROUP BY alias

-- Вариант 1. Для обоих запросов подойдет один составной индекс начинающийся с поля parent_id
CREATE INDEX parent_alias ON leaf(parent_id, alias);

-- Вариант 2. Если поле alias обладает радикально большей селективностью, чем parent_id, то для этих запросов понадобятся два разных индекса
CREATE INDEX alias_parent ON leaf(alias, parent_id); -- в начале ставим alias, так как селективность больше
CREATE INDEX parent_id ON leaf(parent_id);
