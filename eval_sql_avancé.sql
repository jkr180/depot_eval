
                                         ---(Développer des composants d'accès aux donnéees)---
                                                            --EVALUATION--


                                                       --PROGRAMATION DES VUES--
 




--1.Créez une vue qui affiche le catalogue produits. L'id, la référence et le nom des produits, ainsi que l'id et le nom de la catégorie doivent apparaître.

CREATE VIEW v_catalogue_produits   --création de la vue
AS
SELECT pro_id,pro_ref,pro_name,pro_cat_id,cat_id,cat_name --info nécessaire a la vue
FROM products,catégorie
WHERE products.pro_cat_id = catégorie.cat_id


SELECT * FROM `v_catalogue_produits`  --appel de la vue.




                                           --PROCEDURE STOCKEES--




--2.Créez la procédure stockée facture qui permet d'afficher les informations nécessaires à une facture en fonction d'un numéro de commande. Cette procédure doit sortir le montant total de la commande.
delimiter |

drop procedure if exists facture |

CREATE PROCEDURE Facture(   -- création de la procédure stockées.
    IN p_order_id INT(10),   -- entrée de l'ID.
    OUT info_client VARCHAR(255), --|
    OUT date_de_vente DATE,       --|
    OUT id INT(10),               --|
    OUT quantité INT(10),         --| tout les (OUT) sont les informations a avoir en sortie.
    OUT prix DECIMAL(8,2),        --|
    OUT remise INT(10),           --|
    OUT date_de_réglement DATE,   --|
    OUT p_total DECIMAL(8,2)      --|
)

BEGIN
  SELECT
  CONCAT(cus_id,cus_lastname,cus_firstname,cus_city,cus_address,cus_zipcode,cus_countries_id,cus_phone,cus_mail), --regroupement des info_client grace aux (CONCAT).
  ord_order_date,   --|
  ode_id,           --|
  ode_quantity,     --| info de la facture
  ode_unit_price,   --|
  ode_discount,     --|
  ord_payment_date, --|  
    SUM((ode_unit_price*ode_quantity)*(100-ode_discount)/100) -- calcul de pour le p_total (SUM).
    into info_client, date_de_vente, id, quantité, prix, remise, date_de_réglement, p_total
    FROM orders_details
    JOIN orders ON ord_id = ode_ord_id
    JOIN customers ON cus_id = ord_cus_id
    WHERE ord_id = p_order_id;
END |
delimiter ;


--procédure d'appel de la facture 15.

CALL Facture(15, @info_client,@date_de_vente,@id,@quantité,@prix,@remise,@date_de_reglement,@p_total);
SELECT @info_client,@date_de_vente,@id,@quantité,@prix,@remise,@date_de_reglement,@p_total





--L'article L441-9 du code de commerce précise les mentions obligatoires des factures, dont les principales sont les suivantes :

-- nom et adresse des parties
-- date de la vente ou de la prestation de services
-- quantité et dénomination précise des produits ou services
-- prix unitaire hors taxe et réductions éventuellement consenties
-- date d'échéance du règlement et pénalités en cas de retard





                                      --PROGRAMATION DES TRIGGERS--



--3.Présentez le déclencheur after_products_update demandé dans la phase 2 de la séance sur les déclencheurs.




  
--Créer une table commander_articles constituées de colonnes :
    --codart : id du produit
    --qte : quantité à commander
    --date : date du jour


CREATE TABLE commander_articles (
        codart  int(10) UNSIGNED NOT NULL,
        qte int(5) UNSIGNED,
        date    date NOT NULL,
    CONSTRAINT commander_articles_codart_FK FOREIGN KEY (codart) REFERENCES products(pro_id),
    CONSTRAINT commander_article_PK PRIMARY KEY (codart)
);



--2.Créer un déclencheur after_products_update sur la table products : lorsque le stock physique devient inférieur au stock d'alerte, une nouvelle ligne est insérée dans la table commander_articles.



DELIMITER |

DROP TRIGGER IF EXISTS after_products_update|
CREATE TRIGGER after_products_update  --création du déclencheur.
AFTER UPDATE ON products -- après modification sur la table produit.
FOR EACH ROW  -- pour chaque ligne.
BEGIN
    DECLARE stock_p int;         --|
    DECLARE alert_p int;         --|
    DECLARE id_p    int;         --| contenu du trigger.
    DECLARE new_qte int;         --|
    DECLARE verif   varchar(50); --|
    SET stock_p = NEW.pro_stock;       --|
    SET alert_p = NEW.pro_stock_alert; --| colonne a mettre a jour (SET) et traitement des colonne modifiés (NEW).
    SET id_p = NEW.pro_id;             --|  
    IF (stock_p < alert_p) -- si le stock physique est inférieur au stock d'alerte.
    THEN --alors
        SET new_qte = alert_p - stock_p;    --|
        SET verif = (                       --|
            SELECT codart                   --|nouvelle vérification.
            FROM commander_articles         --|
            WHERE codart = id_p             --|
        );
        IF ISNULL(verif) --si (verification) null         
        THEN --alors
            INSERT INTO commander_articles    --|
            (codart, qte, date)               --| nouvelle ligne ajoutée avec valeur attendu (VALUE).
            VALUES                            --|
            (id_p, new_qte, CURRENT_DATE());  --|
        ELSE
            UPDATE commander_articles         --|
            SET qte = new_qte,                --| mise a jour effectuer avec les valeur demandée.
            date = CURRENT_DATE()             --|
            WHERE codart = id_p;              --|
        END IF;
    ELSE
        DELETE                                --|
        FROM commander_articles               --| suppréssion ancienne ligne.
        WHERE codart = id_p;                  --|   
    END IF;
END|

DELIMITER ;




--Testez le bon fonctionnement de votre déclencheur avec les cas suivants :

--Cas	Stock physique	Résultat.
--Cas 1	On passe le stock physique à 6.	Le stock physique reste supérieur au stock d'alerte, donc le trigger n'est pas exécuté.
--Cas 2	On passe le stock physique à 4.	Le stock physique est inférieur au stock d'alerte, nous devons recommander des produits. Le trigger va s'exécuter et insérer une ligne dans la table commander_articles avec qte = (stock alerte - stock physique) = 5 - 4 = 1.
--Cas 3	On passe le stock physique à 3.	Le stock physique est inférieur au stock d'alerte, nous devons recommander des produits. Le trigger va s'exécuter et mettre à jour dans la table commander_articles la quantité à recommander pour la ligne déjà créée pour le produit 'B001' avec une valeur de 2 (5 - 3)..



--cas_1

SELECT *
FROM commander_articles;

UPDATE products
SET pro_stock = 6
WHERE pro_id = 8;


--cas_2

SELECT *
FROM commander_articles;

UPDATE products
SET pro_stock = 4
WHERE pro_id = 8;


--cas_3

SELECT *
FROM commander_articles;

UPDATE products
SET pro_stock = 3
WHERE pro_id = 8;



                                                              --PROGRAMTION DES TRANSACTION--


--4.Transactions

--Amity HANNAH, Manageuse au sein du magasin d'Arras, vient de prendre sa retraite. 




--1.Il a été décidé, après de nombreuses tractations, de confier son poste au pépiniériste le plus ancien en poste dans ce magasin. Ce dernier voit alors son salaire augmenter de 5% et ses anciens collègues pépiniéristes passent sous sa direction.

--2.Ecrire la transaction permettant d'acter tous ces changements en base des données.

--3.La base de données ne contient actuellement que des employés en postes. Il a été choisi de garder en base une liste des anciens collaborateurs de l'entreprise parti en retraite. Il va donc vous falloir ajouter une ligne dans la table posts pour référencer les employés à la retraite.

--4.Décrire les opérations qui seront à réaliser sur la table posts.

--5.Ecrire les requêtes correspondant à ces opéarations.

--6.Ecrire la transaction





INSERT INTO posts --|
(pos_libelle)     --| ajout de la ligne "retraité".
VALUES            --|
('retraité')      --|

START TRANSACTION;                                                                  --|
SET @id_employee =                                                                  --|
(SELECT emp_id                                                                      --|déclaration de la variable id_employee qui reprend les information de Mme Amity HANNAH.
FROM employees                                                                      --| 
JOIN shops ON emp_sho_id = sho_id                                                   --|
WHERE emp_firstname = 'Amity' AND emp_lastname = 'HANNAH' AND sho_city = 'Arras');  --|

  
SET @poste_id =                  --|
(SELECT pos_id                   --| déclarationde de la variable poste_id qui reprend les infos de la ligne "retraité".
FROM posts                       --|
WHERE pos_libelle = 'retraité'); --|

UPDATE employees SET emp_pos_id = @poste_id WHERE emp_id = @id_employee; --Mise a jour sur la table employee Mme HANNAH "id_employee" change de poste donc passe a la retraite "poste_id".


SET @id_employee2 =                                                                                  --|
(SELECT emp_id                                                                                       --|
FROM employees                                                                                       --|
JOIN shops ON emp_sho_id = sho_id                                                                    --| déclaration variable 2 "id_employee2" qui reprend les information du plus ancien pépiniériste de Arras.
WHERE  sho_id = '2' AND emp_pos_id = (SELECT pos_id FROM posts WHERE pos_libelle = 'pépiniériste' )  --|
ORDER BY emp_enter_date ASC                                                                          --|
LIMIT 1                                                                                              --|
);

SET @poste_id2 =                         --|
(SELECT pos_id                           --| déclarationde de la variable "poste_id2" qui reprend les infos de la ligne "retraité".
 FROM posts                              --|  
 WHERE pos_libelle = 'Manager(/geuse)'); --|  

UPDATE employees SET emp_pos_id = @poste_id2, emp_salary = emp_salary*1.05 WHERE emp_id = @id_employee2; --Mise a jour sur la table employee le plus ancien pépiniériste "id_employee2" passe au poste de 'Manager(/geuse)' "poste_id2" et voit son salaire augmenter de 5% soit"1.05".

UPDATE employees SET emp_superior_id = @id_employee2 WHERE emp_pos_id = (SELECT pos_id FROM posts WHERE pos_libelle = 'pépiniériste') AND emp_sho_id = 2; --Mise a jour sur la table le plus ancien pépiniériste "id_employee2" devient le supérieur des pépiniéristes restant.

COMMIT; -- enregitrement final (commit)