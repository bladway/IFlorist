/*DROP TABLE IF EXISTS PROC_REQUEST;

DROP TABLE IF EXISTS FLORA_SUBSCRIPTION;

DROP TABLE IF EXISTS ADVERTISEMENT_VIEW;

DROP TABLE IF EXISTS U_SESSION;

DROP TABLE IF EXISTS MAF_USER;

DROP TABLE IF EXISTS FLORA;*/

CREATE EXTENSION IF NOT EXISTS postgis;

CREATE EXTENSION IF NOT EXISTS postgis_topology;

CREATE TABLE IF NOT EXISTS MAF_USER (
    USER_ID BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL PRIMARY KEY,
    LOGIN VARCHAR(25) NOT NULL UNIQUE,
    PASSWORD VARCHAR(25) NOT NULL,
    ROLE VARCHAR(25) NOT NULL
);

CREATE TABLE IF NOT EXISTS FLORA (
    FLORA_ID BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL  PRIMARY KEY,
    IMAGE_PATH VARCHAR(260) NOT NULL UNIQUE,
    NAME VARCHAR(256) NOT NULL UNIQUE,
    DESCRIPTION TEXT NOT NULL,
    TYPE VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS FLORA_SUBSCRIPTION (
    FLORA_ID BIGINT REFERENCES FLORA(FLORA_ID) ON DELETE CASCADE NOT NULL ,
    USER_ID BIGINT REFERENCES  MAF_USER(USER_ID) ON DELETE CASCADE NOT NULL,
    PRIMARY KEY (FLORA_ID, USER_ID)
);

CREATE TABLE IF NOT EXISTS U_SESSION (
    SESSION_ID BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL PRIMARY KEY,
    CREATED_TIME TIMESTAMP WITH TIME ZONE NOT NULL,
    JWT_CREATED_TIME TIMESTAMP WITH TIME ZONE NOT NULL,
    JWT VARCHAR(255) NOT NULL UNIQUE,
    JWT_R VARCHAR(255) NOT NULL UNIQUE,
    IP_ADDRESS VARCHAR(16) NOT NULL,
    USER_ID BIGINT REFERENCES MAF_USER(USER_ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ADVERTISEMENT_VIEW (
    VIEW_ID BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL PRIMARY KEY,
    CREATED_TIME TIMESTAMP WITH TIME ZONE NOT NULL,
    SESSION_ID BIGINT REFERENCES U_SESSION(SESSION_ID) ON DELETE CASCADE NOT NULL
);

CREATE TABLE IF NOT EXISTS PROC_REQUEST (
    REQUEST_ID BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL PRIMARY KEY,
    CREATED_TIME TIMESTAMP WITH TIME ZONE NOT NULL,
    POSTED_TIME TIMESTAMP WITH TIME ZONE,
    IMAGE_PATH VARCHAR(30) UNIQUE,
    GEO_POS GEOMETRY,
    STATUS VARCHAR(25) NOT NULL,
    IS_BOTANIST_VERIFIED BOOLEAN NOT NULL,
    SESSION_ID BIGINT REFERENCES U_SESSION(SESSION_ID) ON DELETE SET NULL,
    FLORA_ID BIGINT REFERENCES FLORA(FLORA_ID) ON DELETE SET NULL
);

INSERT INTO MAF_USER (LOGIN, PASSWORD, ROLE) VALUES ('adminuser', 'adminuser', 'admin');
INSERT INTO MAF_USER (LOGIN, PASSWORD, ROLE) VALUES ('botanistuser', 'botanistuser', 'botanist');
INSERT INTO MAF_USER (LOGIN, PASSWORD, ROLE) VALUES ('useruser', 'useruser', 'user');

INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Авокадо.jpg', 'Авокадо', 'Авокадо (лат. Persea americana) - вечнозеленое дерево, родом из Центральной и Южной Америки. Это растение выращивается для получения плодов, которые являются ценным источником питательных веществ и жирных кислот.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Акация.jpg', 'Акация', 'Акация (лат. Acacia) - род древесных растений семейства бобовых, широко распространен в тропических и субтропических регионах. Эти деревья часто используются для производства древесины, а также как источник пищи для различных видов животных.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Ананас.jpg', 'Ананас', 'Ананас (лат. Ananas comosus) - тропическое травянистое растение, произрастающее в Южной Америке. Оно культивируется для получения сладких плодов, богатых витаминами и минералами.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Анютины глазки.jpg', 'Анютины глазки', 'Анютины глазки (лат. Viola tricolor) - многолетнее травянистое растение, распространено в Европе и Азии. Это красивое растение выращивается как декоративное и используется в ландшафтном дизайне.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Апельсин.jpg', 'Апельсин', 'Апельсин (лат. Citrus sinensis) - плодовое дерево, родом из Юго-Восточной Азии. Апельсины культивируются для получения цитрусовых плодов, богатых витамином C и другими питательными веществами.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Арахис.jpg', 'Арахис', 'Арахис (лат. Arachis hypogaea) - травянистое растение, родом из Южной Америки. Это растение выращивается для получения съедобных семян, которые являются важным источником белка и жира.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Арбуз.jpg', 'Арбуз', 'Арбуз (лат. Citrullus lanatus) - однолетнее растение, родом из Африки. Оно культивируется для получения крупных сладких плодов, которые часто употребляются в пищу в свежем виде.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Астра.jpg', 'Астра', 'Астра (лат. Aster) - род многолетних цветущих растений, распространен в Северной Америке и Евразии. Эти красочные цветы часто используются в декоративном садоводстве и букетах.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Баклажан.jpg', 'Баклажан', 'Баклажан (лат. Solanum melongena) - травянистое растение, родом из Индии и Бирмы. Этот вид выращивается для получения съедобных плодов, которые часто используются в кулинарии.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Банан.jpg', 'Банан', 'Банан (лат. Musa) - многолетнее травянистое растение, родом из Юго-Восточной Азии. Бананы культивируются для получения плодов, которые являются важным источником углеводов и питательных веществ.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Барбарис.jpg', 'Барбарис', 'Барбарис (лат. Berberis) - род кустарников семейства барбарисовых, распространен в умеренных регионах. Эти растения выращиваются как декоративные и для получения плодов, которые используются в кулинарии и в медицине.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Бергамот.jpg', 'Бергамот', 'Бергамот (лат. Citrus bergamia) - плодовое дерево, родом из Южной Италии. Это растение выращивается для получения эфирных масел и плодов, которые используются в парфюмерии и кулинарии.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Болгарский перец.jpg', 'Болгарский перец', 'Болгарский перец (лат. Capsicum annuum) - однолетнее растение, родом из Америки. Этот вид растений выращивается для получения съедобных плодов, которые используются в кулинарии.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Боярышник.jpg', 'Боярышник', 'Боярышник (лат. Crataegus) - род кустарников или небольших деревьев, распространен в умеренных регионах Северного полушария. Эти растения используются в медицине и как декоративные.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Брусника.jpg', 'Брусника', 'Брусника (лат. Vaccinium vitis-idaea) - вечнозеленый кустарник, родом из северных регионов Евразии и Северной Америки. Это растение выращивается для получения ягод, которые часто используются в кулинарии и как источник питательных веществ.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Василек.jpg', 'Василек', 'Василек (лат. Centaurea) - род травянистых растений семейства сложноцветных, распространен в Евразии. Эти красивые цветы выращиваются как декоративные растения в садах и парках.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Виноград.jpg', 'Виноград', 'Виноград (лат. Vitis) - род древесных растений, распространен в умеренных и субтропических регионах. Виноград культивируется для получения плодов и для производства вина, а также как декоративное растение.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Вишня.jpg', 'Вишня', 'Вишня (лат. Prunus cerasus) - плодовое дерево, родом из Европы и Западной Азии. Эти растения выращиваются для получения плодов, которые используются в кулинарии и кондитерском производстве.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Гвоздика.jpg', 'Гвоздика', 'Гвоздика (лат. Dianthus) - род цветковых растений семейства гвоздичных, распространен в Евразии и Африке. Эти растения выращиваются как декоративные и используются в букетах и для украшения садов.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Георгин.jpg', 'Георгин', 'Георгин (лат. Dahlia) - род многолетних цветущих растений, родом из Центральной Америки. Георгины культивируются как декоративные растения в садах и парках.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Герань.jpg', 'Герань', 'Герань (лат. Geranium) - род многолетних травянистых растений, распространен в умеренных регионах. Эти растения выращиваются как декоративные и используются для украшения садов, балконов и клумб.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Гладиолусы.jpg', 'Гладиолусы', 'Гладиолус (лат. Gladiolus) - род многолетних цветущих растений, распространен в Африке и Средиземноморье. Эти красивые цветы выращиваются как декоративные растения.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Горох.jpg', 'Горох', 'Горох (лат. Pisum sativum) - однолетнее травянистое растение, родом из Средиземноморья. Это растение выращивается для получения съедобных семян. Горох также ценится за свои питательные свойства и богатое содержание белка.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Гранат.jpg', 'Гранат', 'Гранат (лат. Punica granatum) - плодовое дерево, родом из Ирана и северной Индии. Гранаты выращиваются для получения плодов, которые имеют множество полезных свойств и широко используются в кулинарии и медицине.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Грейпфрут.jpg', 'Грейпфрут', 'Грейпфрут (лат. Citrus paradisi) - плодовое дерево, родом из Барбадоса. Грейпфруты культивируются для получения цитрусовых плодов, которые богаты витаминами и антиоксидантами.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Груша.jpg', 'Груша', 'Груша (лат. Pyrus) - плодовое дерево, родом из Европы и Азии. Груши выращиваются для получения сочных и ароматных плодов, которые часто употребляются в пищу как в свежем, так и в переработанном виде.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Ежевика.jpg', 'Ежевика', 'Ежевика (лат. Rubus) - род кустарников семейства розовых, распространен в умеренных регионах. Ежевика выращивается для получения сочных и вкусных ягод, которые используются в кулинарии и для приготовления джемов и компотов.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Жасмин.jpg', 'Жасмин', 'Жасмин (лат. Jasminum) - род кустарников и лиан семейства маслиновых, распространен в тропиках и субтропиках. Этот ароматный цветок выращивается как декоративное растение и используется в парфюмерии.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Инжир.jpg', 'Инжир', 'Инжир (лат. Ficus carica) - плодовое дерево, родом из Средиземноморья и Юго-Западной Азии. Инжиры выращиваются для получения сладких и ароматных плодов, которые широко используются в кулинарии и как деликатес.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Ирис.jpg', 'Ирис', 'Ирис (лат. Iris) - род многолетних травянистых растений, распространен в северном полушарии. Эти красочные цветы выращиваются как декоративные растения в садах и парках.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Кабачок.jpg', 'Кабачок', 'Кабачок (лат. Cucurbita pepo) - однолетнее травянистое растение, родом из Америки. Кабачки выращиваются для получения съедобных плодов, которые используются в кулинарии.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Какао-бобы.jpg', 'Какао-бобы', 'Какао-бобы (лат. Theobroma cacao) - вечнозеленое дерево, родом из тропических регионов Америки. Какао-бобы выращиваются для получения семян какао, которые используются для производства шоколада и других кондитерских изделий.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Киви.jpg', 'Киви', 'Киви (лат. Actinidia deliciosa) - плодовая лиана, родом из Китая. Киви выращивается для получения сочных и ароматных плодов, которые богаты витаминами и микроэлементами.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Клевер.jpg', 'Клевер', 'Клевер (лат. Trifolium) - род травянистых растений семейства бобовых, распространен в умеренных регионах. Клевер часто используется в сельском хозяйстве для улучшения почвы и как корм для скота.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Клубника.jpg', 'Клубника', 'Клубника (лат. Fragaria × ananassa) - многолетнее травянистое растение, родом из Европы. Клубника выращивается для получения вкусных и ароматных ягод, которые популярны в кулинарии и используются для изготовления десертов и варенья.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Клюква.jpg', 'Клюква', 'Клюква (лат. Vaccinium oxycoccos) - вечнозеленый кустарник, распространен в болотистых регионах Северного полушария. Клюква выращивается для получения кисло-сладких ягод, которые часто используются в кулинарии и для приготовления напитков.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Кокос.jpg', 'Кокос', 'Кокос (лат. Cocos nucifera) - пальма, родом из тропических регионов. Кокосы выращиваются для получения плодов, которые используются в кулинарии и в промышленности для производства кокосового масла и других продуктов.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Колокольчик.jpg', 'Колокольчик', 'Колокольчик (лат. Campanula) - род многолетних травянистых растений, распространен в умеренных регионах. Колокольчики выращиваются как декоративные цветы для украшения садов и балконов.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Космея.jpg', 'Космея', 'Космея (лат. Cosmos) - род травянистых растений семейства сложноцветных, распространен в Америке. Космеи выращиваются как декоративные растения в садах и на клумбах.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Кофе.jpg', 'Кофе', 'Кофе (лат. Coffea) - род вечнозеленых кустарников, родом из Африки. Кофе выращивается для получения кофейных зерен, которые используются для приготовления напитков и других продуктов.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Крыжовник.jpg', 'Крыжовник', 'Крыжовник (лат. Ribes uva-crispa) - кустарник, родом из Европы и Западной Азии. Крыжовник выращивается для получения ягод, которые используются в кулинарии и для приготовления компотов и варенья.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Лаванда.jpg', 'Лаванда', 'Лаванда (лат. Lavandula) - род полукустарников, распространен в Средиземноморье. Лаванда выращивается как декоративное и ароматическое растение. Ее цветы используются для создания ароматических букетов, а также в парфюмерии и косметике.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Лайм.jpg', 'Лайм', 'Лайм (лат. Citrus aurantiifolia) - плодовое дерево, родом из Юго-Восточной Азии. Лаймы выращиваются для получения цитрусовых плодов, которые используются в кулинарии, напитках и косметике.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Лилия.jpg', 'Лилия', 'Лилия (лат. Lilium) - род многолетних цветущих растений, распространен в северном полушарии. Лилии выращиваются как декоративные цветы, их красивые и изящные цветки используются для украшения садов, букетов и интерьеров.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Лимон.jpg', 'Лимон', 'Лимон (лат. Citrus limon) - плодовое дерево, родом из Азии. Лимоны выращиваются для получения цитрусовых плодов, которые используются в кулинарии, напитках и в косметической индустрии.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Личи.jpg', 'Личи', 'Личи (лат. Litchi chinensis) - плодовое дерево, родом из Южного Китая. Личи выращиваются для получения плодов, которые широко используются в кулинарии и имеют высокую популярность благодаря своему сладкому вкусу и аромату.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Лотос.jpg', 'Лотос', 'Лотос (лат. Nelumbo) - род водных многолетних растений, распространен в Азии и Австралии. Лотосы выращиваются как декоративные растения в водоемах и прудах, их крупные и красивые цветы используются в ландшафтном дизайне и для создания экзотических садов.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Лютик.jpg', 'Лютик', 'Лютик (лат. Ranunculus) - род травянистых растений, распространен в умеренных регионах. Лютики выращиваются как декоративные цветы в садах и парках, их красочные и изящные цветы украшают газоны и клумбы.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Магнолия.jpg', 'Магнолия', 'Магнолия (лат. Magnolia) - род цветковых деревьев и кустарников, распространен в Северной Америке и Восточной Азии. Магнолии выращиваются как декоративные растения в парках и садах, их крупные и ароматные цветы являются объектом восхищения садоводов и любителей растений.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Мак.jpg', 'Мак', 'Мак (лат. Papaver) - род травянистых растений, распространен в умеренных регионах. Мак выращивается как декоративное и масличное растение. Его яркие цветы используются для украшения садов и получения масла.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Малина.jpg', 'Малина', 'Малина (лат. Rubus idaeus) - кустарник, родом из Европы и Северной Азии. Малина выращивается для получения ягод, которые используются в кулинарии, приготовлении десертов и варенья.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Манго.jpg', 'Манго', 'Манго (лат. Mangifera indica) - плодовое дерево, родом из Южной Азии. Манго культивируется для получения сочных и сладких плодов, которые широко используются в кулинарии и приготовлении напитков.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Маракуйя.jpg', 'Маракуйя', 'Маракуйя (лат. Passiflora edulis) - многолетняя лиана, родом из Южной Америки. Маракуйя выращивается для получения плодов, которые используются в кулинарии и в производстве соков и десертов.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Маргаритка.jpg', 'Маргаритка', 'Маргаритка (лат. Bellis perennis) - многолетнее травянистое растение, родом из Европы. Маргаритка выращивается как декоративное растение для украшения газонов, клумб и рабаток.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Мимоза.jpg', 'Мимоза', 'Мимоза (лат. Mimosa) - род древесных растений и кустарников, распространен в тропических и субтропических регионах. Мимоза выращивается как декоративное растение, благодаря своим ярким и ароматным цветкам.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Нарцисс.jpg', 'Нарцисс', 'Нарцисс (лат. Narcissus) - род многолетних цветущих растений, распространен в Европе и Средиземноморье. Нарциссы выращиваются как декоративные цветы, их яркие и ароматные цветы радуют глаз и нюх.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Нектарин.jpg', 'Нектарин', 'Нектарин (лат. Prunus persica var. nucipersica) - плодовое дерево, родом из Китая. Нектарины выращиваются для получения сочных и сладких плодов, которые широко используются в кулинарии.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Облепиха обыкновенная.jpg', 'Облепиха обыкновенная', 'Облепиха обыкновенная (лат. Hippophae rhamnoides) - кустарник, родом из Европы и Азии. Облепиха выращивается для получения ягод, которые используются в медицине, кулинарии и косметологии.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Одуванчик.jpg', 'Одуванчик', 'Одуванчик (лат. Taraxacum) - род многолетних травянистых растений, распространен в умеренных регионах. Одуванчик используется в народной медицине в качестве лекарственного растения и в кулинарии для приготовления салатов и чаев.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Орхидея.jpg', 'Орхидея', 'Орхидея (лат. Orchidaceae) - семейство многолетних цветущих растений, распространено по всему миру. Орхидеи являются одними из самых красивых и экзотических цветов и часто выращиваются как декоративные растения.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Пион.jpg', 'Пион', 'Пион (лат. Paeonia) - род многолетних травянистых растений и кустарников, распространен в Евразии и Северной Америке. Пионы выращиваются как декоративные растения благодаря своим крупным и ароматным цветкам.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Подснежник.jpg', 'Подснежник', 'Подснежник (лат. Galanthus) - род многолетних травянистых растений, распространен в Европе и Ближнем Востоке. Подснежники являются символом прихода весны и выращиваются как декоративные растения.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Подсолнечник.jpg', 'Подсолнечник', 'Подсолнечник (лат. Helianthus) - род однолетних и многолетних растений, родом из Северной Америки. Подсолнечники выращиваются для получения семян и масла, а также как декоративные растения.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Помидор.jpg', 'Помидор', 'Помидор (лат. Solanum lycopersicum) - однолетнее растение, родом из Южной Америки. Помидоры выращиваются для получения съедобных плодов, которые широко используются в кулинарии.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Роза.jpg', 'Роза', 'Роза (лат. Rosa) - род многолетних кустарников, распространен в Северном полушарии. Розы являются одними из самых популярных и красивых цветов, выращиваются как декоративные растения в садах, парках и на клумбах.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Сирень.jpg', 'Сирень', 'Сирень (лат. Syringa) - род кустарников, родом из Восточной Европы и Азии. Сирень выращивается как декоративное растение благодаря своим ароматным цветкам, которые используются для украшения садов и озеленения участков.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Слива.jpg', 'Слива', 'Слива (лат. Prunus domestica) - плодовое дерево, родом из Кавказа и Западной Азии. Сливы выращиваются для получения сочных и вкусных плодов, которые используются в кулинарии для приготовления компотов, варенья и десертов.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Тыква.jpg', 'Тыква', 'Тыква (лат. Cucurbita) - род однолетних травянистых растений, родом из Америки. Выращивается для получения съедобных плодов. Используется в кулинарии для приготовления супов, пюре, запеканок и других блюд.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Тысячелистник.jpg', 'Тысячелистник', 'Тысячелистник (лат. Achillea) - род многолетних травянистых растений, распространен в Северном полушарии. Используется в народной медицине в качестве противовоспалительного и обезболивающего средства.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Тюльпан.jpg', 'Тюльпан', 'Тюльпан (лат. Tulipa) - род многолетних цветущих растений, распространен в Европе, Азии и Северной Африке. Является одним из самых популярных цветов. Выращивается как декоративное растение.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Укроп.jpg', 'Укроп', 'Укроп (лат. Anethum graveolens) - однолетнее травянистое растение, родом из Средиземноморья. Используется в кулинарии как пряность для придания аромата и вкуса блюдам.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Финик.jpg', 'Финик', 'Финик (лат. Phoenix dactylifera) - пальма, родом из Ближнего Востока. Культивируется для получения плодов, которые широко используются в кулинарии и приготовлении сладостей.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Флокс.jpg', 'Флокс', 'Флокс (лат. Phlox) - род многолетних цветущих растений, распространен в Северной Америке. Используется в декоративном садоводстве для украшения клумб и рабаток.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Халапеньо.jpg', 'Халапеньо', 'Халапеньо (лат. Capsicum annuum) - однолетнее травянистое растение, родом из Мексики. Выращивается для получения острых плодов, которые используются в мексиканской кухне.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Хризантема.jpg', 'Хризантема', 'Хризантема (лат. Chrysanthemum) - род многолетних цветущих растений, распространен в Европе и Азии. Используется в декоративном садоводстве для украшения клумб, балконов и веранд.', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Хурма.jpg', 'Хурма', 'Хурма (лат. Diospyros) - плодовое дерево, родом из Восточной Азии. Культивируется для получения плодов, которые широко используются в пищевой промышленности и кулинарии.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Цикорий.jpg', 'Цикорий', 'Цикорий (лат. Cichorium intybus) - многолетнее травянистое растение, родом из Европы. Используется в кулинарии для приготовления ароматного и полезного напитка из корней.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Чёрная смородина.jpg', 'Чёрная смородина', 'Чёрная смородина (лат. Ribes nigrum) - кустарник, родом из Европы и Азии. Выращивается для получения ягод, которые используются в приготовлении десертов, компотов и варенья.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Черника.jpg', 'Черника', 'Черника (лат. Vaccinium myrtillus) - кустарник, распространен в северных регионах Евразии и Северной Америки. Выращивается для получения ягод, которые являются ценным источником витаминов и антиоксидантов.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Шалфей.jpg', 'Шалфей', 'Шалфей (лат. Salvia) - род многолетних травянистых растений и кустарников, распространен в умеренных и тропических регионах. Используется в медицине и кулинарии. Имеет антисептические и противовоспалительные свойства.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Шиповник.jpg', 'Шиповник', 'Шиповник (лат. Rosa) - род кустарников семейства розовых, распространен в умеренных регионах. Выращивается для получения плодов, которые используются в кулинарии и медицине.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Яблоко.jpg', 'Яблоко', 'Яблоко (лат. Malus domestica) - плодовое дерево, родом из Центральной Азии. Культивируется для получения плодов, которые являются основным источником витаминов и питательных веществ.', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Блефаростома волосолистная.jpg', 'Блефаростома волосолистная', 'Блефаростома волосолистная (лат. Blepharostoma trichophyllum) - вид печеночников, распространен в умеренных и тропических регионах, встречается в лесах и на болотах.', 'Мох');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Гипнум кипарисовый.jpg', 'Гипнум кипарисовый', 'Гипнум кипарисовый (лат. Hypnum cupressiforme) - мох, широко распространенный в умеренных и тропических регионах, растет на почве, камнях и коре деревьев.', 'Мох');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Кукушкин лен.jpg', 'Кукушкин лен', 'Кукушкин лен (лат. Polytrichum commune) - крупный мох, распространен в северном полушарии, встречается на болотах, в лесах и на влажных лугах.', 'Мох');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Тортула стенная.jpg', 'Тортула стенная', 'Тортула стенная (лат. Tortula muralis) - мох, распространенный в умеренных регионах, растет на стенах, камнях и сухих почвах.', 'Мох');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Политрихум можжевельникоподобный.jpg', 'Политрихум можжевельникоподобный', 'Политрихум можжевельникоподобный (лат. Polytrichum juniperinum) - мох, распространен в северном полушарии, встречается на кислых почвах и в лесах.', 'Мох');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Циррифиллум волосконосный.jpg', 'Циррифиллум волосконосный', 'Циррифиллум волосконосный (лат. Cirriphyllum piliferum) - мох, распространен в умеренных регионах, растет на почве, камнях и коре деревьев.', 'Мох');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Хилокомиум блестящий.jpg', 'Хилокомиум блестящий', 'Хилокомиум блестящий (лат. Hylocomium splendens) - мох, распространен в северных регионах, встречается в лесах, на болотах и на каменистых участках.', 'Мох');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Сфагнум волосистый.jpg', 'Сфагнум волосистый', 'Сфагнум волосистый (лат. Sphagnum capillifolium) - мох, распространен в северном полушарии, встречается на болотах и влажных местах.', 'Мох');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Антоцерос гладкий.jpg', 'Антоцерос гладкий', 'Антоцерос гладкий (лат. Anthoceros laevis) - вид антоцеротов, распространен в тропических и умеренных регионах, растет на влажных почвах и глинистых участках.', 'Мох');
