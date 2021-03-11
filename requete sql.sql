--Q1. Afficher dans l'ordre alphabétique et sur une seule colonne les noms et prénoms des employés qui ont des enfants, présenter d'abord ceux qui en ont le plus.

SELECT emp_lastname,'',emp_firstname,emp_children
FROM employees
WHERE emp_children >=1
ORDER BY emp_children DESC
--Q2. Y-a-t-il des clients étrangers ? Afficher leur nom, prénom et pays de résidence.

SELECT cus_lastname,cus_firstname
FROM customers
WHERE cus_countries_id NOT IN -- sous-requete ici : 
(SELECT cus_countries_id FROM countries WHERE  cus_countries_id = 'FR')

--Q3. Afficher par ordre alphabétique les villes de résidence des clients ainsi que le code (ou le nom) du pays.

SELECT  cus_city,cus_countries_id 
FROM customers 
GROUP BY cus_city,cus_countries_id 
LIMIT 5

--Q4. Afficher le nom des clients dont les fiches ont été modifiées
SELECT cus_lastname,cus_update_date 
FROM customers 
WHERE cus_update_date >=1 
GROUP BY cus_lastname,cus_update_date 
ORDER BY cus_update_date ASC

--Q5. La commerciale Coco Merce veut consulter la fiche d'un client, mais la seule chose dont elle se souvienne est qu'il habite une ville genre 'divos'. Pouvez-vous l'aider ?
SELECT cus_countries_id,cus_city
FROM customers
WHERE cus_city like '%divos%'



--Q6. Quel est le produit vendu le moins cher ? Afficher le prix, l'id et le nom du produit.
SELECT pro_id,pro_name,pro_price
FROM products
WHERE pro_price <'2'
order by pro_price asc



--Q7. Lister les produits qui n'ont jamais été vendus.
SELECT pro_id,pro_ref,pro_name
FROM products
WHERE pro_id NOT IN (SELECT ode_pro_id FROM orders_details)




--Q8. Afficher les produits commandés par Madame Pikatchien.
SELECT pro_id,pro_ref,pro_name,cus_id,ord_id,ode_id,ode_pro_id
FROM customers
JOIN orders on cus_id = ord_cus_id
JOIN orders_details on ode_pro_id = pro_id
WHERE pro_name = 'Pikatchien'


--Q9. Afficher le catalogue des produits par catégorie, le nom des produits et de la catégorie doivent être affichés.
SELECT cat_id,cat_name,pro_name
FROM products
JOIN categories ON pro_id = cat_id
ORDER BY cat_name ASC


--Q10. Afficher l'organigramme hiérarchique (nom et prénom et poste des employés) du magasin de Compiègne, classer par ordre alphabétique. Afficher le nom et prénom des employés, éventuellement le poste (si vous y parvenez).
SELECT employees1.emp_lastname,employees1.emp_firstname,pos_libelle,employeessup.emp_lastname,employeessup.emp_firstname
FROM employees AS employees1
INNER JOIN employees AS employeessup on employeessup.emp_id = employees1.emp_superior_id
INNER JOIN posts ON employees1.emp_pos_id = pos_id
WHERE employees1.emp_city = 'Compiègne'
ORDER BY employees1.emp_lastname ASC


--Q11. Quel produit a été vendu avec la remise la plus élevée ? Afficher le montant de la remise, le numéro et le nom du produit, le numéro de commande et de ligne de commande.
SELECT ord_id,ode_discount,ode_pro_id,ode_ord_id,pro_name,pro_ref,ode_id
FROM orders_details
JOIN orders on ode_ord_id = ord_id
JOIN products on ode_pro_id = pro_id 
order by ode_discount  DESC
LIMIT 1


--Q13. Combien y-a-t-il de clients canadiens ? Afficher dans une colonne intitulée 'Nb clients Canada'
SELECT COUNT(cus_countries_id),cou_name,cou_id
FROM customers
JOIN countries ON cus_countries_id = cou_id
WHERE cou_name = 'Canada'



--Q14. Afficher le détail des commandes de 2020.
SELECT ode_id,ode_unit_price,ode_discount,ode_ord_id,ode_pro_id,ord_order_date
FROM orders_details
JOIN orders on ode_pro_id = ord_id
WHERE ord_order_date between '2020/1/1' and '2020/12/31'
order by ord_order_date DESC



--Q15. Afficher les coordonnées des fournisseurs pour lesquels des commandes ont été passées.
SELECT distinct sup_name,sup_contact,sup_phone,sup_mail
FROM orders_details
JOIN products on ode_pro_id = pro_id 
JOIN suppliers on pro_sup_id = sup_id



--Q16. Quel est le chiffre d'affaires de 2020 ?
SELECT sum((ode_unit_price - (ode_unit_price * ode_discount/100)) * ode_quantity) AS sous_total
FROM orders_details
WHERE ord_order_date = 2020




--Q17. Quel est le panier moyen ?
SELECT avg(panier)
FROM (
    SELECT sum((ode_unit_price - (ode_unit_price * ode_discount/100)) * ode_quantity) AS panier
    FROM orders_details
    GROUP by ode_ord_id
    ) AS total



--Q18. Lister le total de chaque commande par total décroissant (Afficher numéro de commande, date, total et nom du client).
SELECT ord_id AS 'Commande n°', CONCAT(DAY(ord_order_date), MONTHNAME(ord_order_date),  YEAR(ord_order_date)) AS 'Commandé le', CONCAT(cus_firstname, ' ', cus_lastname) AS 'Par', CONCAT(ROUND(SUM((ode_quantity*ode_unit_price)*((100-ode_discount)/100)), 2), '€') AS 'Total du panier',
FROM orders
INNER JOIN orders_details ON ord_id = ode_ord_id
INNER JOIN customers ON ord_cus_id = cus_id
GROUP BY ord_id
ORDER BY SUM((ode_quantity*ode_unit_price)*((100-ode_discount)/100)) DESC, ord_order_date;



--Q19. La version 2020 du produit barb004 s'appelle désormais Camper et, bonne nouvelle, son prix subit une baisse de 10%.
UPDATE  products 
SET  pro_price =pro_price - pro_price/100 * 10, pro_name='Camper'
where pro_ref='barb004'



--Q20. L'inflation en France en 2019 a été de 1,1%, appliquer cette augmentation à la gamme de parasols.
UPDATE products
SET pro_price = pro_price*1.1/100 + pro_price 
WHERE products.pro_cat_id IN (SELECT cat_id FROM categories WHERE cat_name = 'parasols')



--Q21. Supprimer les produits non vendus de la catégorie "Tondeuses électriques". Vous devez utiliser une sous-requête sans indiquer de valeurs de clés.
DELETE p
FROM products p
INNER JOIN categories c ON c.cat_id = p.pro_cat_id
WHERE NOT EXISTS(
        SELECT od.ode_pro_id
        FROM orders_details od
        WHERE od.ode_pro_id = p.pro_id
    )
  AND c.cat_name LIKE "Tondeuses électriques";



--------------------------------------------------------------------------------------


--(5_ROLE)  Créer la base de données : utilisateurs, privilèges et rôles
--A partir de la base Gescom :
--Créez un groupe marketing qui peut ajouter, modifier et supprimer des produits et des catégories, consulter des commandes, leur détails et les clients. Ce groupe ne peut rien faire sur les autres tables.

CREATE USER 'mister1'@'%' IDENTIFIED BY 'mot_de_passe1';
CREATE USER 'mister2'@'%' IDENTIFIED BY 'mot_de_passe2';
CREATE USER 'mister3'@'%' IDENTIFIED BY 'mot_de_passe3';



CREATE ROLE 'marketing';

GRANT select,Insert,update,delete 
ON afpa_gescom.products
TO marketing;

GRANT select,Insert,update,delete 
ON afpa_gescom.categories
TO marketing;

GRANT select
ON afpa_gescom.orders
TO marketing;

GRANT select
ON afpa_gescom.orders_details
TO marketing;