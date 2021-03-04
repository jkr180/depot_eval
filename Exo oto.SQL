CREATE TABLE IF NOT EXISTS client (
id_cli int,
cli_nom varchar(30),
cli_prénom varchar(30),
cli_num int UNIQUE,
cli_part varchar(50),
cli_pro varchar(50)
,CONSTRAINT client_PK PRIMARY KEY (id_cli)
);

CREATE TABLE IF NOT EXISTS véhicule (
id_véhi int, 
véhi_part varchar(50),
véhi_utilitaire varchar(50),
véhi_neuf varchar(50),
véhi_occas varchar(50)
,CONSTRAINT véhicule_PK PRIMARY KEY (id_véhi)
);

CREATE TABLE IF NOT EXISTS employée (
id_emp int,
emp_poste varchar(50) NOT NULL,
emp_nom varchar(30) NOT NULL,
emp_prénom varchar(30) NOT NULL 
,CONSTRAINT employée_PK PRIMARY KEY (id_emp)
);

CREATE TABLE IF NOT EXISTS activité (
id_acti int,
acti_vente varchar(255),
acti_répar varchar(255),
acti_entretien varchar(255)
,CONSTRAINT activité_PK PRIMARY KEY (id_acti)    
);

CREATE TABLE IF NOT EXISTS paiement (
id_paie int,
paie_crédit DECIMAL(2,2)  NOT NULL,
paie_comptant DECIMAL(2,2) NOT NULL
,CONSTRAINT paiement_PK PRIMARY KEY (id_paie)   
);

CREATE TABLE contrat (
id_emp Int NOT NULL,
id_cli Int NOT NULL
,CONSTRAINT contrat PRIMARY KEY (id_emp,id_cli)
,CONSTRAINT contrat_employée_FK FOREIGN KEY (id_emp) REFERENCES employée (id_emp)
,CONSTRAINT contrat_client_FK FOREIGN KEY (id_cli) REFERENCES client (id_cli)
);