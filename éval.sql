--EXERCICE 1
--Téléchargez et installez la structure (tables vides) de la base de données gescom.

CREATE TABLE`customers` (
`cus_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT
);
 
CREATE TABLE`employees` (
`emp_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT
);

CREATE TABLE`orders` (
`ord_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT
);

CREATE TABLE`orders_details` (
`ode_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT
);

CREATE TABLE `posts` (
`pos_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT
); 

CREATE TABLE`products` (
`pro_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT
); 

CREATE TABLE`suppliers` (
`sup_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT
); 

--EXERCICE 2

--Un temps de réflexion s'impose : la structure de la base de données vous impose de remplir les tables dans un ordre défini, afin de respecter les contraintes de clés étrangères : Quel est l'ordre à adopter ? Argumenter.
--COLLATE : Vous avez certainement déjà entendu parler de la collation en SQL Server. C’est traduit en français, par « classement ». Ce n’est pas une très bonne traduction, on va vraiment garder le terme américain de « collation ».
--En SQL Server en français, la collation par défaut est French_CI_AS, c’est une collation Windows. Cette collation s’applique aux VARCHAR ou NVARCHAR, pour les recherches et les tris. Le CI de French_CI_AS veut dire Case Insensitive, donc insensible à la casse. AS, ça veut dire Accent Sensitive, donc sensible aux accents. La sensibilité, c’est comment on compare ces chaînes de caractères dans une clause WHERE par exemple, mais aussi lorsqu’on va faire un tri, avec un ORDER BY.
--On peut changer la collation d’une colonne, et même, on peut changer à la volée dans l’instruction SQL, avec une instruction COLLATE, pour forcer pendant la comparaison une autre collation.
--CHARACTER SET

--Le type "unsigned int" s'utilise quand on a besoin de nombres positifs. Le nombre de joueurs dans une partie par exemple. Il est toujours égal à 0 ou à un nombre plus grand que 0.
--En choisissant "unsigned int" plutôt que "int", tu es sûr que ton nombre de joueurs ne sera jamais négatif dans tes calculs.

--La clause, AUTO_INCREMENT, permet à MySQL de générer un entier unique pour tout nouvel enregistrement d'une table. Cette clause ne peut se mettre que sur les champs de type entier, indexé et non nul. Elle est donc souvent utilisée comme clé primaire.
--Il s'agit d'une syntaxe MySQL non standard. Après les crochets qui entourent la liste des colonnes et des index, MySQL autorise les options de table.
--ENGINE spécifie le moteur de stockage à associer à la table. Un moteur de stockage est un plugin spécial qui implémente toutes les fonctionnalités liées à une table: écriture de lignes et d'index, lecture de lignes et d'index, caches, réparation, etc. InnoDB est le moteur de stockage par défaut (sauf si vous changez la variable default_storage_engine ) et c'est celui qui fonctionne le mieux dans la plupart des situations. En outre, c'est le seul moteur de stockage transactionnel fourni avec MySQL (non distribué par des tiers). Ici vous pouvez voir les autres moteurs. MariaDB et Percona Server ont des moteurs supplémentaires.
--DEFAULT CHARSETspécifie le jeu de caractères de la table , dans ce cas UTF8. Notez que, techniquement parlant, il n'existe pas de jeu de caractères de table. Chaque colonne de texte a un jeu de caractères associé, et il peut être différent pour chaque colonne. Le jeu de caractères du tableau est un jeu par défaut: chaque fois que vous ne spécifiez pas de jeu de caractères pour une colonne, le jeu de caractères du tableau s'applique.
--ENGINE peut être utilisé pour obtenir de meilleures performances dans certains cas extrêmes. DEFAULT CHARSET peut être utilisé pour stocker des chaînes dans un jeu de caractères plus petit que UTF8, là encore pour des raisons de performances. mysqldump ajoute cette syntaxe juste pour être sûr que les tables sont recréées toujours sous le même nom, même sur des serveurs avec une configuration étrange.
--utf8_general_ci = CHARACTER SET
--Ce type d'encodage a un interclassement très simple :
-- Il supprime tous les accents.
-- Il convertit toutes les lettres en majuscule.
--Il va ensuite réaliser le tri.
--Par exemple si on a les lettres ÀÁÅåāă, pour lui toutes ces lettres sont égales à A.

--L'UTF-8 est le moyen le plus largement utilisé pour représenter le texte Unicode dans les pages Web et vous devriez toujours utiliser l'UTF-8 pour créer vos pages Web et vos bases de données. Mais en principe, l'UTF-8 n'est qu'une façon parmi d'autres d'encoder les caractères Unicode.
--countries


DROP TABLE IF EXISTS `posts`;
CREATE TABLE IF NOT EXISTS `posts` (
  `pos_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pos_libelle` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`pos_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS `countries`;
CREATE TABLE IF NOT EXISTS `countries` (
  `cou_id` char(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `cou_name` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  UNIQUE KEY `alpha2` (`cou_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
  `cus_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cus_lastname` varchar(50) NOT NULL,
  `cus_firstname` varchar(50) NOT NULL,
  `cus_address` varchar(150) NOT NULL,
  `cus_zipcode` varchar(5) NOT NULL,
  `cus_city` varchar(50) NOT NULL,
  `cus_countries_id` char(2) NOT NULL,
  `cus_mail` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `cus_phone` int(10) UNSIGNED NOT NULL,
  `cus_password` varchar(60) NOT NULL,
  `cus_add_date` datetime NOT NULL,
  `cus_update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`cus_id`),
  KEY `ibfk_customers_countries` (`cus_countries_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `pro_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pro_cat_id` int(10) UNSIGNED NOT NULL,
  `pro_price` decimal(7,2) NOT NULL,
  `pro_ref` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `pro_ean` varchar(13) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `pro_stock` int(5) UNSIGNED NOT NULL,
  `pro_stock_alert` int(5) UNSIGNED NOT NULL,
  `pro_color` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `pro_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `pro_desc` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `pro_publish` tinyint(1) NOT NULL,
  `pro_sup_id` int(10) UNSIGNED NOT NULL,
  `pro_add_date` datetime NOT NULL,
  `pro_update_date` datetime DEFAULT NULL,
  `pro_picture` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`pro_id`),
  KEY `pro_sup_id` (`pro_sup_id`) USING BTREE,
  KEY `pro_cat_id` (`pro_cat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `cat_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cat_name` varchar(50) NOT NULL,
  `cat_parent_id` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`cat_id`),
  KEY `cat_parent_id` (`cat_parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `orders_details`;
CREATE TABLE IF NOT EXISTS `orders_details` (
  `ode_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ode_unit_price` decimal(7,2) NOT NULL,
  `ode_discount` decimal(4,2) DEFAULT NULL,
  `ode_quantity` int(5) NOT NULL,
  `ode_ord_id` int(10) UNSIGNED NOT NULL,
  `ode_pro_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`ode_id`),
  KEY `ode_ord_id` (`ode_ord_id`) USING BTREE,
  KEY `ode_pro_id` (`ode_pro_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `ord_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ord_order_date` date NOT NULL,
  `ord_payment_date` date DEFAULT NULL,
  `ord_ship_date` date DEFAULT NULL,
  `ord_reception_date` date DEFAULT NULL,
  `ord_status` varchar(25) NOT NULL,
  `ord_cus_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`ord_id`),
  KEY `ord_cus_id` (`ord_cus_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `employees`;
CREATE TABLE IF NOT EXISTS `employees` (
  `emp_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `emp_superior_id` int(10) UNSIGNED DEFAULT NULL,
  `emp_pos_id` int(10) UNSIGNED NOT NULL,
  `emp_lastname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `emp_firstname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `emp_address` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `emp_zipcode` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `emp_city` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `emp_mail` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `emp_phone` int(10) UNSIGNED NOT NULL,
  `emp_salary` int(10) UNSIGNED DEFAULT NULL,
  `emp_enter_date` date NOT NULL,
  `emp_gender` char(1) NOT NULL,
  `emp_children` tinyint(2) NOT NULL,
  PRIMARY KEY (`emp_id`),
  KEY `emp_superior_id` (`emp_superior_id`),
  KEY `emp_pos_id` (`emp_pos_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE IF NOT EXISTS `suppliers` (
  `sup_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sup_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sup_city` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sup_countries_id` char(2) NOT NULL,
  `sup_address` varchar(150) NOT NULL,
  `sup_zipcode` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sup_contact` varchar(100) NOT NULL,
  `sup_phone` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sup_mail` varchar(75) NOT NULL,
  PRIMARY KEY (`sup_id`),
  KEY `sup_countries_id` (`sup_countries_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




-------------- script MCD cas_gescom----------------------


CREATE TABLE employee(
   Id_employee COUNTER,
   emp_libelle VARCHAR(50),
   emp_name VARCHAR(50),
   PRIMARY KEY(Id_employee)
);

CREATE TABLE customers(
   Id_customers COUNTER,
   custom_libelle VARCHAR(50),
   custom_name VARCHAR(50),
   PRIMARY KEY(Id_customers)
);

CREATE TABLE ordered(
   Id_ordered COUNTER,
   ord_payment VARCHAR(50),
   ord_delivery VARCHAR(50),
   PRIMARY KEY(Id_ordered)
);

CREATE TABLE category(
   Id_category COUNTER,
   cat_name VARCHAR(50),
   cat_sub VARCHAR(50),
   PRIMARY KEY(Id_category)
);

CREATE TABLE discount(
   Id_discount COUNTER,
   disc_percentage VARCHAR(50),
   PRIMARY KEY(Id_discount)
);

CREATE TABLE product(
   Id_product COUNTER,
   prod_name VARCHAR(50),
   prod_dated_A VARCHAR(50),
   prod_dated_M VARCHAR(50),
   prod_media VARCHAR(50),
   prod_stock_A VARCHAR(50),
   prod_stock_P LOGICAL,
   prod_code VARCHAR(50),
   prod_color VARCHAR(50),
   prod_reference VARCHAR(50),
   prod_libelle VARCHAR(50),
   Id_category INT NOT NULL,
   PRIMARY KEY(Id_product),
   UNIQUE(Id_category),
   FOREIGN KEY(Id_category) REFERENCES category(Id_category)
);

CREATE TABLE provider(
   Id_provider COUNTER,
   prov_name VARCHAR(50),
   Id_product INT NOT NULL,
   PRIMARY KEY(Id_provider),
   UNIQUE(Id_product),
   FOREIGN KEY(Id_product) REFERENCES product(Id_product)
);

CREATE TABLE commercial(
   Id_commercial COUNTER,
   com_name VARCHAR(50),
   Id_provider INT NOT NULL,
   PRIMARY KEY(Id_commercial),
   UNIQUE(Id_provider),
   FOREIGN KEY(Id_provider) REFERENCES provider(Id_provider)
);

CREATE TABLE recevoir(
   Id_product INT,
   Id_discount INT,
   PRIMARY KEY(Id_product, Id_discount),
   FOREIGN KEY(Id_product) REFERENCES product(Id_product),
   FOREIGN KEY(Id_discount) REFERENCES discount(Id_discount)
);

CREATE TABLE enregistrer(
   Id_customers INT,
   Id_ordered INT,
   PRIMARY KEY(Id_customers, Id_ordered),
   FOREIGN KEY(Id_customers) REFERENCES customers(Id_customers),
   FOREIGN KEY(Id_ordered) REFERENCES ordered(Id_ordered)
);

CREATE TABLE suivre(
   Id_product INT,
   Id_ordered INT,
   PRIMARY KEY(Id_product, Id_ordered),
   FOREIGN KEY(Id_product) REFERENCES product(Id_product),
   FOREIGN KEY(Id_ordered) REFERENCES ordered(Id_ordered)
);

CREATE TABLE acheter(
   Id_product INT,
   Id_customers INT,
   PRIMARY KEY(Id_product, Id_customers),
   FOREIGN KEY(Id_product) REFERENCES product(Id_product),
   FOREIGN KEY(Id_customers) REFERENCES customers(Id_customers)
);

CREATE TABLE être(
   Id_employee INT,
   Id_commercial INT,
   PRIMARY KEY(Id_employee, Id_commercial),
   FOREIGN KEY(Id_employee) REFERENCES employee(Id_employee),
   FOREIGN KEY(Id_commercial) REFERENCES commercial(Id_commercial)
);


