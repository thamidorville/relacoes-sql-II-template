-- Active: 1680783547034@@127.0.0.1@3306

-- Práticas
--PRÁTICA 1 - seguidores(follow) seguir outros usuários

CREATE TABLE users (
    id PRIMARY KEY UNIQUE NOT NULL,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL, 
    created_at TEXT DEFAULT (DATETIME()) NOT NULL --significa que, 
    --quando um novo registro é inserido na tabela users sem fornecer um valor para a coluna created_at, 
    --o valor padrão será definido como a data e hora atuais. Essa linha de código é útil para registrar 
    -- a data e hora em que um registro foi adicionado à tabela users.
);

-- SELECT DATETIME("now", "localtime");
--PRÁTICA 1.1 - POPULE-A COM PELO MENOS 3 PESSOAS
INSERT INTO users (id, name, email, password)
VALUES
    ("u001", "Thamiris", "thamiris@email.com", "thamiris123"),
    ("u002", "Thami", "miris@email.com", "thami321"),
    ("u003", "miris", "thatha@email.com", "miris456");

    SELECT * FROM users;

    -- PRÁTICA 2 - CRIANDO TABELA DE RELAÇÕES
    --nesta tabela teremos dois tipos de users
    -- TABLE FOLLOWS
    -- FOLLOWERS que são as pessoas que seguem outras pessoas
    -- FOLLOWED que são as pessoas que estão sendo seguidas
    -- lembre-se que essas colunas não podem ser únicas para que seja m:n

    CREATE TABLE follows(
        follower_id TEXT NOT NULL,
        followed_id TEXT NOT NULL,
        FOREIGN KEY (follower_id) REFERENCES users(id),
        FOREIGN KEY (followed_id) REFERENCES users(id)
    );

-- PRÁTICA 2.1 
-- Sabendo que a tabela users possui 3 pessoas (A, B, C) popule a 
-- tabela follows respeitando os seguintes requisitos:
-- Pessoa A segue B e C;
-- Pessoa B segue A;
-- Pessoa C não segue ninguém.

    INSERT INTO follows(follower_id, followed_id)
    VALUES
        ("u001", "u002"),
        ("u001", "u003"),
        ("u002", "u001");

        SELECT * FROM follows;

    -- PRÁTICA 2.2
    -- Faça uma consulta com junção INNER JOIN entre as duas tabelas (follows.follower_id = users.id)

        SELECT * FROM users
        INNER JOIN follows
        ON follows.follower_id = users.id;


        -- PRÁTICA 3
        -- Na query de junção feita na prática anterior, o usuário C não aparece no resultado
        -- Crie uma junção que possibilite a visualização das pessoas que não seguem ninguém.
        -- O resultado também deve continuar incluindo as pessoas que seguem outras pessoas, ou 
        --seja, a interseção.

        SELECT * FROM users
        LEFT JOIN follows
        ON follows.follower_id = users.id;

-- retorna dados de duas tabelas: users e follows

-- PRÁTICA 3.1 
-- Analise o resultado da query: 
-- só vemos a id da pessoa seguida (followed_id)
-- Crie uma nova consulta que mantém o mesmo resultado anterior,
-- mas também retorna o nome da pessoa seguida.
    SELECT 
        users.id AS userId,
        users.name AS userName,
        users.email,
        users.created_at,
        follows.follower_id AS followerId,
        follows.followed_id AS followedId,
        usersFollowed.name AS followedName
        FROM users
        LEFT JOIN follows
        ON follows.follower_id = users.id
        INNER JOIN users AS usersFollowed
        ON follows.followed_id = usersFollowed.id;

    -- última coluna, followedName, é obtida a partir da tabela users novamente, 
    --porém com uma junção (JOIN) com a tabela follows.
    --     LEFT JOIN é usada para combinar as linhas das duas tabelas, selecionando todas 
    --     as linhas da tabela à esquerda (no caso, users) e as correspondentes da tabela 
    --     à direita (no caso, follows) que satisfaçam a condição especificada na cláusula ON.

    -- A cláusula ON especifica a condição de junção, que é follows.follower_id = users.id, 
    -- ou seja, junta as linhas das duas tabelas onde o id do usuário em users é igual 
    -- ao follower_id em follows.
    --INNER JOIN é usada para unir as linhas resultantes do LEFT JOIN 
    --anterior com a tabela users novamente, renomeada como usersFollowed
    -- A condição de junção é follows.followed_id = usersFollowed.id, ou seja, 
    -- junta as linhas onde o followed_id em follows é igual ao id em usersFollowed


    --exercício de fixação
    -- implemente uma relação m:n

    CREATE TABLE usersnetflix (
        id TEXT PRIMARY KEY UNIQUE NOT NULL,
        name TEXT NOT NULL,
        email TEXT NOT NULL
    );


    CREATE TABLE series (
        id TEXT PRIMARY KEY UNIQUE NOT NULL,
        titulo TEXT NOT NULL,
        codigo INTEGER NOT NULL
    );

    -- tabela de relação m:n entre usersnetflix e series que deve possuir duas (FK)

    CREATE TABLE usersnetflix_series (
        user_id TEXT NOT NULL,
        serie_id TEXT NOT NULL,
        PRIMARY KEY (user_id, serie_id),
        FOREIGN KEY (user_id) REFERENCES usersnetflix(id),
        FOREIGN KEY (serie_id) REFERENCES series(id)
    );

    -- popular as tabelas

    INSERT INTO usersnetflix(
        id, name, email
    ) VALUES
    (
        "usernet1",
        "Maria Joana",
        "joaninha@email.com"
    ),
    (
        "usernet2",
        "João Alberto",
        "betinho@email.com"
        
    ),
    (
        "usernet3",
        "Ana Paula",
        "paulinha@email.com"
    );

SELECT * FROM usersnetflix;

INSERT INTO series(id, titulo, codigo) 
VALUES
    (
        'serie1',
        'Stranger Things',
        123456
    ),
    (
        'serie2',
        "Big Mouth",
        345678
    ),
    (
        'serie3',
        'Dark',
        987654
    );

    SELECT * FROM series;

    -- popular a tabela de relação (usersnetflix_series)

    INSERT INTO usersnetflix_series (user_id, serie_id)
    VALUES
    (
        'usernet1', 'serie3' -- Maria Joana gosta de assistir à série Dark
    ),
    (
        'usernet3', 'serie2' -- a ana paula gosta da série big mouth
    ),
    (
        'usernet2', 'serie1' --e o joao gosta da serie stranger things
    );

    SELECT * FROM usersnetflix_series;

    -- visualizar os resultados juntando as três tabelas;
    -- SELECT + INNER JOIN

    SELECT 

    usersnetflix.id AS IDdeUsuarioNetflix,
    usersnetflix.name AS nomeDoUsuario,
    usersnetflix.email,
    series.id AS IDdaSerie,
    series.titulo AS tituloDaSerie,
    series.codigo AS codigoDaSerie

    FROM usersnetflix_series

    INNER JOIN usersnetflix
    ON usersnetflix_series.user_id = usersnetflix.id
    INNER JOIN series
    ON usersnetflix_series.serie_id = series.id;


