DROP TABLE IF EXISTS PROC_REQUEST;

DROP TABLE IF EXISTS FLORA_SUBSCRIPTION;

DROP TABLE IF EXISTS U_SESSION;

DROP TABLE IF EXISTS MAF_USER;

DROP TABLE IF EXISTS FLORA;

CREATE EXTENSION IF NOT EXISTS postgis;

CREATE EXTENSION IF NOT EXISTS postgis_topology;

CREATE TABLE IF NOT EXISTS MAF_USER (
    USER_ID BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL PRIMARY KEY,
    LOGIN VARCHAR(25) NOT NULL UNIQUE,
    PASSWORD VARCHAR(25) NOT NULL,
    ROLE VARCHAR(25) NOT NULL
);

CREATE TABLE IF NOT EXISTS U_SESSION (
    SESSION_ID BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL PRIMARY KEY,
    IP_ADDRESS VARCHAR(16) NOT NULL,
    CREATED_TIME TIMESTAMP WITH TIME ZONE NOT NULL,
    JWT VARCHAR(255) NOT NULL UNIQUE,
    JWT_R VARCHAR(255) NOT NULL UNIQUE,
    USER_ID BIGINT REFERENCES MAF_USER(USER_ID)
);

CREATE TABLE IF NOT EXISTS FLORA (
    FLORA_ID BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL  PRIMARY KEY,
    IMAGE_PATH VARCHAR(30) NOT NULL,
    NAME VARCHAR(50) NOT NULL UNIQUE,
    DESCRIPTION TEXT NOT NULL,
    TYPE VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS FLORA_SUBSCRIPTION (
    FLORA_ID BIGINT REFERENCES FLORA(FLORA_ID) NOT NULL ,
    USER_ID BIGINT REFERENCES  MAF_USER(USER_ID) NOT NULL,
    PRIMARY KEY (FLORA_ID, USER_ID)
);

CREATE TABLE IF NOT EXISTS PROC_REQUEST (
    REQUEST_ID BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL PRIMARY KEY,
    IMAGE_PATH VARCHAR(30),
    CREATED_TIME TIMESTAMP WITH TIME ZONE NOT NULL,
    POSTED_TIME TIMESTAMP WITH TIME ZONE,
    GEO_POS GEOMETRY,
    STATUS VARCHAR(25) NOT NULL,
    SESSION_ID BIGINT REFERENCES U_SESSION(SESSION_ID) NOT NULL,
    FLORA_ID BIGINT REFERENCES FLORA(FLORA_ID)
);

INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Одуванчик.jpg', 'Одуванчик', 'Научное название рода Taraxaсum, i [тараксакум], n. — одуванчик; возможно латинизация от арабского tharakhchakon или персидского thalkhchakok, принадлежащего названию одного из видов растения похожего на цикорий; другой — от греческого taraxcis — вид болезни глаз и akceomai — лечу или исцеляю, дано по лекарственным свойствам растения при лечении болезней глаз. Этимология латинского названия рода не совсем ясна. Существует несколько вариантов его объяснения. По одной из версий, оно происходит от греч. «taraxis» (воспаление, воспламенение) и «akeomai» (я излечиваю) или от греч. «tarassein» (успокаивать) — по медицинским свойствам растения. Существует точка зрения, что научное название рода — латинизация араб. «tar(a)khshaqoq» или персидск. «talkh chakok» названия другого сложноцветного, предположительно, одного из видов Цикория (Cichorium L.), или Осота (Sonchus L.). На арабский «след» в происхождении лат. названия рода указывает полиноминальное описание одуванчика в травнике долиннеевской эпохи Леонарта Фукса (Das Krauterbuch,1543) : «Das Pfaffenrorling...oder Pippaw, ist das Hieracium minus, und heyszt den officinis Dens leonis, und taraxacon. altaraxacon, Caput monachi». Арабский артикль «al-» однозначно указывает на это, что не исключает, в свою очередь, заимствование этого названия в арабский из персидского, как это нередко можно видеть с наименованиями многих растений. Но в любом случае, в средневековую Европу «al-taraxacon» попало через арабские источники.\n\nРусское родовое название «одуванчик» произошло от славянского глагола одуть + суффикса -чик, отражающее особенность растений —- семянки с волосистом хохолком от общего цветоложа сносятся ветром. Оставшееся голым цветоложе напоминает плешивую голову. Поэтому в средние века в Западной Европе одуванчик называли также «Caput monachi» (монашеская голова), а в России с этим связаны названия «пустодуй», «пушник», «плешивец», «еврейская шапка», «попово гумёнце», «пухлянка». Другая группа народных названий обусловлена млечным соком, содержащимся во всех частях растения — «молокоёд»,«молочник», «подойничек».', 'Цветок');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Укроп.jpg', 'Укроп', 'Укро́п паху́чий, или огоро́дный (лат. Anéthum graveólens)[1] — вид однолетних травянистых растений семейства Зонтичные, популярное огородное растение, выращиваемое как пряность, наиболее распространённый вид рода Укроп (лат. Anethum).\n\nВ диком виде встречается в юго-западной и центральной Азии.', 'Трава');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) VALUES ('get/Авокадо.jpg', 'Авокадо', 'Ботаническое описание\nВечнозелёное дерево до 20 м высотой с широкой кроной и очерёдным листорасположением. Ветви ломкие, покрыты гладкой корой; побеги часто жёлтые, красноватые и бронзовые. Кора серая, толстая, слабо трещиноватая. Листья продлговато- или эллиптически-ланцетные до яйцевидных и обратнояйцевидных, 10 – 25 см длиной и 5 – 15 см шириной, с острой или коротко заострённой, иногда почти тупой верхушкой и с заострённым или срезанным, но обычно округлым основанием, цельнокрайние; пластинка сверху голая, тёмно-зелёная, блестящая, снизу более светлая, сизоватая с выступающими жилками; черешки 4 – 10 мм длиной, сверху желобчатые. Цветки на коротких цветоножках, обоеполые, 9 – 10 мм шириной, желтовато-зеленоватые, собранные в широкие компактные метёлки на концах побегов; околоцветник чашечковидный, 6-раздельный, доли продолговато-ланцетные, заострённые, слегка вогнутые, с тонким опушением, тычинок 12 (фертильных 9), собранных в 4 круга, самый внутренний круг представлен стаминодиями, выделяющими нектар; у основания каждой тычинки третьего круга расположены попарно яйцевидные оранжевые желёзки, нити тычинок тонкие, покрытые мелким пушком; пыльники 4-гнёздные, раскрывающиеся при помощи клапанов, отверстия которых у тычинок двух наружных кругов обращены к центру цветка, а у тычинок третьего круга – наружу, пыльца сферическая, с неровной поверхностью; завязь яйцевидно-эллиптическая, одногнёздная, с одной семяпочкой; столбик тонкий, покрыт мелкими волосками, рыльце простое. Пыльники и рыльца развиваются в разное время, чем обеспечивается перекрёстное опыление и исключается самоопыление; у некоторых авокадо наблюдается разивтие партенокарпических плодов. Плод большая мясистая грушевидная, яйцевидная или сферическая костянка, 5 – 20 см длиной, зелёная, каштановая, коричневая или пурпурная; кожица плода от тонко плёнковидной до толстой и деревянистой, мякоть плода разной толщины, мягкая, маслянистая, кремовая или жёлтая; плодоножка от 10 до 30 мм длиной, реже больше. Семя одно, большое, круглое, яйцевидное, коническое или яйцевидно приплюснутое, без эндосперма, покрыто 2 тонкими, часто отличными семенными оболочками сетчатого строения. Урожайность 8 – 10-летнего дерева, в зависимости от сорта, колеблется от 300 до 1000 плодов.\n\nПилипенко Ф.С. Семейство Лавровые – Lauraceae Lindl. // Деревья и кустарники СССР. В 6 т. / Под ред. С. Я. Соколова. М. – Л.: Изд-во АН СССР, 1954. – Т. 3. – С. 124 – 126 (как Persea gratissima).\n\nПрочая информация\nОбласть распространения: Мексика, Центральная и Южная Америка – от Рио-Гранде на севере Мексики, Перу, Бразилия и на юго до среднего Чили. На плоскогорьях Мексики растёт до высоты 1800 – 2000 м н.у.м. В центральной Гватемале на склонах гор на высоте 2400 – 2700 м н.у.м. среди сосен, дубов и мексиканского кипариса (Cupressus lusitanica Benth.). В Гондурасе растёт в девственных лесах до высоты 600 м и более, в Коста-Рике – на высоте 1350 – 1500 м. Растёт авокадо также в Вест-Индии, но некоторые авторы считают, что сюда оно было завезено из других областей. По крайней мере, авокадо, произрастающее в отдельных местах Панамы и Гондураса и имеющее сходство с вест-индским авокадо, относят к одичавшим культурным формам. На Черноморском побережье Кавказа встречается в коллекционных и в небольших производственных посадках от Сочи до Батуми.\n\nПилипенко Ф.С. Семейство Лавровые – Lauraceae Lindl. // Деревья и кустарники СССР. В 6 т. / Под ред. С. Я. Соколова. М. – Л.: Изд-во АН СССР, 1954. – Т. 3. – С. 124 – 126 (как Persea gratissima).', 'Дерево');
INSERT INTO FLORA (IMAGE_PATH, NAME, DESCRIPTION, TYPE) values ('get/Акация.jpg', 'Акация', 'Ака́ция (лат. Acacia) — крупный род цветковых растений семейства Бобовые (Fabaceae).\n\nПроизрастает преимущественно в Австралии, Африке, Мексике и Азии. На Черноморском побережье России используется в озеленении акация чёрная и акация серебристая.[2] Часто украшает среднеевропейские оранжереи и теплицы [3].', 'Дерево');
