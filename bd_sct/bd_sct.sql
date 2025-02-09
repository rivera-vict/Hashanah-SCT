
-- ==================================================  ==========

CREATE DATABASE IF NOT EXISTS bd_hashanahsct;
USE bd_hashanahsct;



-- ================================================== tbl_estados ==========

CREATE TABLE IF NOT EXISTS tbl_estados (
    id_estado INT PRIMARY KEY AUTO_INCREMENT,
    nombre_estado VARCHAR(9) NOT NULL,

    -- Validación para campos de texto
    CONSTRAINT chk_estados_nombre_estado CHECK (nombre_estado REGEXP '^[A-Za-zÁÉÍÓÚáéíóúñÑ]{6,9}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO tbl_estados (nombre_estado)
VALUES ('Activo'),	                    -- 1
    ('Pendiente'),	                    -- 2
    ('Inactivo');                       -- 3



-- ================================================== tbl_generos ==========

CREATE TABLE IF NOT EXISTS bd_sct.tbl_generos (
    id_genero INT PRIMARY KEY AUTO_INCREMENT,
    nombre_genero VARCHAR(9) NOT NULL,

    -- Validación para campos de texto
    CONSTRAINT chk_generos_nombre_genero CHECK (nombre_genero REGEXP '^[A-Za-zÁÉÍÓÚáéíóúñÑ]{4,9}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO bd_sct.tbl_generos (nombre_genero)
VALUES ('Masculino'),					-- id_genero 1
	('Femenino'),						-- id_genero 2
	('Otro');		        			-- id_genero 3



-- ================================================== tbl_paises ==========

CREATE TABLE IF NOT EXISTS bd_sct.tbl_paises (
    id_pais INT PRIMARY KEY AUTO_INCREMENT,
    codigo_pais VARCHAR(4),
    nombre_pais VARCHAR(15) NOT NULL,

    -- Claves únicas combinadas
    CONSTRAINT uk_paises_codigo_pais UNIQUE (codigo_pais),

    -- Validación para campos de texto
    CONSTRAINT chk_paises_nombre_pais CHECK (nombre_pais REGEXP '^[A-Za-zÁÉÍÓÚáéíóúñÑ ]{4,15}$'),
    -- Validación para campos de texto-números-caracteres
	CONSTRAINT chk_paises_codigo_pais CHECK (codigo_pais REGEXP '^\\+[0-9]{1,3}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO bd_sct.tbl_paises (codigo_pais, nombre_pais)
VALUES ('+593', 'Ecuador'),	            -- 1
    ('+57', 'Colombia'),			    -- 2
    ('+51', 'Perú');		            -- 3



-- ================================================== tbl_regiones ==========

CREATE TABLE IF NOT EXISTS bd_sct.tbl_regiones (
    id_region INT PRIMARY KEY AUTO_INCREMENT,
    nombre_region VARCHAR(30) NOT NULL,

    -- Claves únicas combinadas
    CONSTRAINT uk_regiones_nombre_region UNIQUE (nombre_region),

    -- Validación para campos de texto
    CONSTRAINT chk_regiones_nombre_region CHECK (nombre_region REGEXP '^[A-Za-zÁÉÍÓÚáéíóúñÑ() ]{5,30}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO bd_sct.tbl_regiones (nombre_region)
VALUES ('Costa'),                       -- 1
    ('Sierra'),			                -- 2
    ('Amazonía (Oriente)'),		        -- 3
    ('Insular (Galápagos)'),		    -- 4
    ('Andina'),                         -- 5
    ('Caribe'),                         -- 6
    ('Pacífica'),                       -- 7
    ('Orinoquía (Llanos Orientales)'),  -- 8
    ('Amazónica'),                      -- 9
    ('Insular'),                        -- 10
    ('Selva (Amazonía)');               -- 11



-- ================================================== tbl_paises_regiones ==========

CREATE TABLE IF NOT EXISTS bd_sct.tbl_paises_regiones (
    id_pais INT NOT NULL,
    id_region INT NOT NULL,

    -- Clave primaria compuesta con nombre específico
    CONSTRAINT pk_paises_regiones PRIMARY KEY (id_pais, id_region),

    -- Claves foráneas
    CONSTRAINT fk_paises_regiones_id_pais FOREIGN KEY (id_pais) REFERENCES tbl_paises(id_pais) ON DELETE RESTRICT,
    CONSTRAINT fk_paises_regiones_id_region FOREIGN KEY (id_region) REFERENCES tbl_regiones(id_region) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO bd_sct.tbl_paises_regiones (id_pais, id_region) VALUES
    (1, 1),                     -- Ecuador - Costa
    (1, 2),                     -- Ecuador - Sierra
    (1, 3),                     -- Ecuador - Amazonía (Oriente)
    (1, 4),                     -- Ecuador - Insular (Galápagos)
    (2, 5),                     -- Colombia - Andina
    (2, 6),                     -- Colombia - Caribe
    (2, 7),                     -- Colombia - Pacífica
    (2, 8),                     -- Colombia - Orinoquía (Llanos Orientales)
    (2, 9),                     -- Colombia - Amazónica
    (2, 10),                    -- Colombia - Insular
    (3, 1),                     -- Perú - Costa
    (3, 2),                     -- Perú - Sierra
    (3, 11),                    -- Perú - Selva (Amazonía)
    (3, 10);                    -- Perú - Insular



-- ================================================== tbl_provincias ==========

CREATE TABLE IF NOT EXISTS tbl_provincias (
    id_provincia INT PRIMARY KEY AUTO_INCREMENT,
    id_region INT NOT NULL,
    codigo_provincia VARCHAR(2) NOT NULL,
    nombre_provincia VARCHAR(30) NOT NULL,

    -- Claves foráneas
    CONSTRAINT fk_provincias_id_region FOREIGN KEY (id_region) REFERENCES tbl_regiones(id_region) ON DELETE RESTRICT,

    -- Validación para campos de texto
    CONSTRAINT chk_provincias_nombre_provincia CHECK (nombre_provincia REGEXP '^[A-Za-zÁÉÍÓÚáéíóúñÑ ]+$'),
    -- Validación para campos de números
    CONSTRAINT chk_provincias_codigo_provincias CHECK (codigo_provincia REGEXP '^[0-9]{2}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO tbl_provincias (id_region, codigo_provincia, nombre_provincia)
VALUES
(2, '01', 'Azuay'),                             -- 1 id_region = Sierra
(2, '02', 'Bolívar'),                           -- 2 id_region = Sierra
(2, '03', 'Cañar'),                             -- 3 id_region = Sierra
(2, '04', 'Carchi'),                            -- 4 id_region = Sierra
(2, '05', 'Cotopaxi'),                          -- 5 id_region = Sierra
(2, '06', 'Chimborazo'),                        -- 6 id_region = Sierra
(1, '07', 'El Oro'),                            -- 7 id_region = Costa
(1, '08', 'Esmeraldas'),                        -- 8 id_region = Costa
(1, '09', 'Guayas'),                            -- 9 id_region = Costa
(2, '10', 'Imbabura'),                          -- 10 id_region = Sierra
(2, '11', 'Loja'),                              -- 11 id_region = Sierra
(1, '12', 'Los Ríos'),                          -- 12 id_region = Costa
(1, '13', 'Manabí'),                            -- 13 id_region = Costa
(3, '14', 'Morona Santiago'),                   -- 14 id_region = Oriente
(3, '15', 'Napo'),                              -- 15 id_region = Oriente
(3, '16', 'Pastaza'),                           -- 16 id_region = Oriente
(2, '17', 'Pichincha'),                         -- 17 id_region = Sierra
(2, '18', 'Tungurahua'),                        -- 18 id_region = Sierra
(3, '19', 'Zamora Chinchipe'),                  -- 19 id_region = Oriente
(4, '20', 'Galápagos'),                         -- 20 id_region = Insular
(3, '21', 'Sucumbíos'),                         -- 21 id_region = Oriente
(3, '22', 'Orellana'),                          -- 22 id_region = Oriente
(1, '23', 'Santo Domingo de los Tsáchilas'),    -- 23 id_region = Costa
(1, '24', 'Santa Elena');                       -- 24 id_region = Costa



-- ================================================== tbl_ciudades ==========

CREATE TABLE IF NOT EXISTS tbl_ciudades (
    id_ciudad INT PRIMARY KEY AUTO_INCREMENT,
    id_provincia INT NOT NULL,
    nombre_ciudad VARCHAR(30) NOT NULL,

    -- Clave foránea
    CONSTRAINT fk_ciudades_id_provincia FOREIGN KEY (id_provincia) REFERENCES tbl_provincias(id_provincia) ON DELETE RESTRICT,

    -- Validación para campos de texto-números-caracteres
    CONSTRAINT chk_ciudades_nombre_ciudad CHECK (nombre_ciudad REGEXP '^[A-Za-zÁÉÍÓÚáéíóúñÑ0-9 ]+$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO tbl_ciudades (id_provincia, nombre_ciudad)
VALUES (1, 'Cuenca'),                       -- id_provincia = Azuay
(1, 'Girón'),                               -- id_provincia = Azuay
(1, 'Gualaceo'),                            -- id_provincia = Azuay
(1, 'Nabón'),                               -- id_provincia = Azuay
(1, 'Paute'),                               -- id_provincia = Azuay
(1, 'Pucara'),                              -- id_provincia = Azuay
(1, 'San Fernando'),                        -- id_provincia = Azuay
(1, 'Santa Isabel'),                        -- id_provincia = Azuay
(1, 'Sigsig'),                              -- id_provincia = Azuay
(1, 'Oña'),                                 -- id_provincia = Azuay
(1, 'Chordeleg'),                           -- id_provincia = Azuay
(1, 'El Pan'),                              -- id_provincia = Azuay
(1, 'Sevilla De Oro'),                      -- id_provincia = Azuay
(1, 'Guachapala'),                          -- id_provincia = Azuay
(1, 'Camilo Ponce Enríquez'),               -- id_provincia = Azuay
(2, 'Guaranda'),                            -- id_provincia = Bolívar
(2, 'Chillanes'),                           -- id_provincia = Bolívar
(2, 'Chimbo'),                              -- id_provincia = Bolívar
(2, 'Echeandía'),                           -- id_provincia = Bolívar
(2, 'San Miguel'),                          -- id_provincia = Bolívar
(2, 'Caluma'),                              -- id_provincia = Bolívar
(2, 'Las Naves'),                           -- id_provincia = Bolívar
(3, 'Azogues'),                             -- id_provincia = Cañar
(3, 'Biblián'),                             -- id_provincia = Cañar
(3, 'Cañar'),                               -- id_provincia = Cañar
(3, 'La Troncal'),                          -- id_provincia = Cañar
(3, 'El Tambo'),                            -- id_provincia = Cañar
(3, 'Déleg'),                               -- id_provincia = Cañar
(3, 'Suscal'),                              -- id_provincia = Cañar
(4, 'Tulcán'),                              -- id_provincia = Carchi
(4, 'Bolívar'),                             -- id_provincia = Carchi
(4, 'Espejo'),                              -- id_provincia = Carchi
(4, 'Mira'),                                -- id_provincia = Carchi
(4, 'Montúfar'),                            -- id_provincia = Carchi
(4, 'San Pedro De Huaca'),                  -- id_provincia = Carchi
(5, 'Latacunga'),                           -- id_provincia = Cotopaxi
(5, 'La Maná'),                             -- id_provincia = Cotopaxi
(5, 'Pangua'),                              -- id_provincia = Cotopaxi
(5, 'Pujili'),                              -- id_provincia = Cotopaxi
(5, 'Salcedo'),                             -- id_provincia = Cotopaxi
(5, 'Saquisilí'),                           -- id_provincia = Cotopaxi
(5, 'Sigchos'),                             -- id_provincia = Cotopaxi
(6, 'Riobamba'),                            -- id_provincia = Chimborazo
(6, 'Alausi'),                              -- id_provincia = Chimborazo
(6, 'Colta'),                               -- id_provincia = Chimborazo
(6, 'Chambo'),                              -- id_provincia = Chimborazo
(6, 'Chunchi'),                             -- id_provincia = Chimborazo
(6, 'Guamote'),                             -- id_provincia = Chimborazo
(6, 'Guano'),                               -- id_provincia = Chimborazo
(6, 'Pallatanga'),                          -- id_provincia = Chimborazo
(6, 'Penipe'),                              -- id_provincia = Chimborazo
(6, 'Cumandá'),                             -- id_provincia = Chimborazo
(7, 'Machala'),                             -- id_provincia = El Oro
(7, 'Arenillas'),                           -- id_provincia = El Oro
(7, 'Atahualpa'),                           -- id_provincia = El Oro
(7, 'Balsas'),                              -- id_provincia = El Oro
(7, 'Chilla'),                              -- id_provincia = El Oro
(7, 'El Guabo'),                            -- id_provincia = El Oro
(7, 'Huaquillas'),                          -- id_provincia = El Oro
(7, 'Marcabelí'),                           -- id_provincia = El Oro
(7, 'Pasaje'),                              -- id_provincia = El Oro
(7, 'Piñas'),                               -- id_provincia = El Oro
(7, 'Portovelo'),                           -- id_provincia = El Oro
(7, 'Santa Rosa'),                          -- id_provincia = El Oro
(7, 'Zaruma'),                              -- id_provincia = El Oro
(7, 'Las Lajas'),                           -- id_provincia = El Oro
(8, 'Esmeraldas'),                          -- id_provincia = Esmeraldas
(8, 'Eloy Alfaro'),                         -- id_provincia = Esmeraldas
(8, 'Muisne'),                              -- id_provincia = Esmeraldas
(8, 'Quinindé'),                            -- id_provincia = Esmeraldas
(8, 'San Lorenzo'),                         -- id_provincia = Esmeraldas
(8, 'Atacames'),                            -- id_provincia = Esmeraldas
(8, 'Rioverde'),                            -- id_provincia = Esmeraldas
(8, 'La Concordia'),                        -- id_provincia = Esmeraldas
(9, 'Guayaquil'),                           -- id_provincia = Guayas
(9, 'Alfredo Baquerizo Moreno'),            -- id_provincia = Guayas
(9, 'Balao'),                               -- id_provincia = Guayas
(9, 'Balzar'),                              -- id_provincia = Guayas
(9, 'Colimes'),                             -- id_provincia = Guayas
(9, 'Daule'),                               -- id_provincia = Guayas
(9, 'Durán'),                               -- id_provincia = Guayas
(9, 'El Empalme'),                          -- id_provincia = Guayas
(9, 'El Triunfo'),                          -- id_provincia = Guayas
(9, 'Milagro'),                             -- id_provincia = Guayas
(9, 'Naranjal'),                            -- id_provincia = Guayas
(9, 'Naranjito'),                           -- id_provincia = Guayas
(9, 'Palestina'),                           -- id_provincia = Guayas
(9, 'Pedro Carbo'),                         -- id_provincia = Guayas
(9, 'Samborondón'),                         -- id_provincia = Guayas
(9, 'Santa Lucía'),                         -- id_provincia = Guayas
(9, 'Salitre'),                             -- id_provincia = Guayas
(9, 'San Jacinto De Yaguachi'),             -- id_provincia = Guayas
(9, 'Playas'),                              -- id_provincia = Guayas
(9, 'Simón Bolívar'),                       -- id_provincia = Guayas
(9, 'Coronel Marcelino Maridueña'),         -- id_provincia = Guayas
(9, 'Lomas De Sargentillo'),                -- id_provincia = Guayas
(9, 'Nobol'),                               -- id_provincia = Guayas
(9, 'General Antonio Elizalde'),            -- id_provincia = Guayas
(9, 'Isidro Ayora'),                        -- id_provincia = Guayas
(9, 'El Piedrero'),                         -- id_provincia = Guayas
(10, 'Ibarra'),                             -- id_provincia = Imbabura
(10, 'Antonio Ante'),                       -- id_provincia = Imbabura
(10, 'Cotacachi'),                          -- id_provincia = Imbabura
(10, 'Otavalo'),                            -- id_provincia = Imbabura
(10, 'Pimampiro'),                          -- id_provincia = Imbabura
(10, 'San Miguel De Urcuquí'),              -- id_provincia = Imbabura
(10, 'Las Golondrinas'),                    -- id_provincia = Imbabura
(11, 'Loja'),                               -- id_provincia = Loja
(11, 'Calvas'),                             -- id_provincia = Loja
(11, 'Catamayo'),                           -- id_provincia = Loja
(11, 'Celica'),                             -- id_provincia = Loja
(11, 'Chaguarpamba'),                       -- id_provincia = Loja
(11, 'Espíndola'),                          -- id_provincia = Loja
(11, 'Gonzanamá'),                          -- id_provincia = Loja
(11, 'Macará'),                             -- id_provincia = Loja
(11, 'Paltas'),                             -- id_provincia = Loja
(11, 'Puyango'),                            -- id_provincia = Loja
(11, 'Saraguro'),                           -- id_provincia = Loja
(11, 'Sozoranga'),                          -- id_provincia = Loja
(11, 'Zapotillo'),                          -- id_provincia = Loja
(11, 'Pindal'),                             -- id_provincia = Loja
(11, 'Quilanga'),                           -- id_provincia = Loja
(11, 'Olmedo'),                             -- id_provincia = Loja
(12, 'Babahoyo'),                           -- id_provincia = Los Rios
(12, 'Baba'),                               -- id_provincia = Los Rios
(12, 'Montalvo'),                           -- id_provincia = Los Rios
(12, 'Puebloviejo'),                        -- id_provincia = Los Rios
(12, 'Quevedo'),                            -- id_provincia = Los Rios
(12, 'Urdaneta'),                           -- id_provincia = Los Rios
(12, 'Ventanas'),                           -- id_provincia = Los Rios
(12, 'Vínces'),                             -- id_provincia = Los Rios
(12, 'Palenque'),                           -- id_provincia = Los Rios
(12, 'Buena Fé'),                           -- id_provincia = Los Rios
(12, 'Valencia'),                           -- id_provincia = Los Rios
(12, 'Mocache'),                            -- id_provincia = Los Rios
(12, 'Quinsaloma'),                         -- id_provincia = Los Rios
(13, 'Portoviejo'),                         -- id_provincia = Manabi
(13, 'Bolívar'),                             -- id_provincia = Manabi
(13, 'Chone'),                              -- id_provincia = Manabi
(13, 'El Carmen'),                          -- id_provincia = Manabi
(13, 'Flavio Alfaro'),                      -- id_provincia = Manabi
(13, 'Jipijapa'),                           -- id_provincia = Manabi
(13, 'Junín'),                              -- id_provincia = Manabi
(13, 'Manta'),                              -- id_provincia = Manabi
(13, 'Montecristi'),                        -- id_provincia = Manabi
(13, 'Paján'),                              -- id_provincia = Manabi
(13, 'Pichincha'),                          -- id_provincia = Manabi
(13, 'Rocafuerte'),                         -- id_provincia = Manabi
(13, 'Santa Ana'),                          -- id_provincia = Manabi
(13, 'Sucre'),                              -- id_provincia = Manabi
(13, 'Tosagua'),                            -- id_provincia = Manabi
(13, '24 De Mayo'),                         -- id_provincia = Manabi
(13, 'Pedernales'),                         -- id_provincia = Manabi
(13, 'Olmedo'),                             -- id_provincia = Manabi
(13, 'Puerto López'),                       -- id_provincia = Manabi
(13, 'Jama'),                               -- id_provincia = Manabi
(13, 'Jaramijó'),                           -- id_provincia = Manabi
(13, 'San Vicente'),                        -- id_provincia = Manabi
(13, 'Manga Del Cura'),                     -- id_provincia = Manabi
(14, 'Morona'),                             -- id_provincia = Morona Santiago
(14, 'Gualaquiza'),                         -- id_provincia = Morona Santiago
(14, 'Limón Indanza'),                      -- id_provincia = Morona Santiago
(14, 'Palora'),                             -- id_provincia = Morona Santiago
(14, 'Santiago'),                           -- id_provincia = Morona Santiago
(14, 'Sucúa'),                              -- id_provincia = Morona Santiago
(14, 'Huamboya'),                           -- id_provincia = Morona Santiago
(14, 'San Juan Bosco'),                     -- id_provincia = Morona Santiago
(14, 'Taisha'),                             -- id_provincia = Morona Santiago
(14, 'Logroño'),                            -- id_provincia = Morona Santiago
(14, 'Pablo Sexto'),                        -- id_provincia = Morona Santiago
(14, 'Tiwintza'),                           -- id_provincia = Morona Santiago
(15, 'Tena'),                               -- id_provincia = Napo
(15, 'Archidona'),                          -- id_provincia = Napo
(15, 'El Chaco'),                           -- id_provincia = Napo
(15, 'Quijos'),                             -- id_provincia = Napo
(15, 'Carlos Julio Arosemena Tola'),        -- id_provincia = Napo
(16, 'Pastaza'),                            -- id_provincia = Pastaza
(16, 'Mera'),                               -- id_provincia = Pastaza
(16, 'Santa Clara'),                        -- id_provincia = Pastaza
(16, 'Arajuno'),                            -- id_provincia = Pastaza
(17, 'Quito'),                              -- id_provincia = Pichincha
(17, 'Cayambe'),                            -- id_provincia = Pichincha
(17, 'Mejia'),                              -- id_provincia = Pichincha
(17, 'Pedro Moncayo'),                      -- id_provincia = Pichincha
(17, 'Rumiñahui'),                          -- id_provincia = Pichincha
(17, 'San Miguel De Los Bancos'),           -- id_provincia = Pichincha
(17, 'Pedro Vicente Maldonado'),            -- id_provincia = Pichincha
(17, 'Puerto Quito'),                       -- id_provincia = Pichincha
(18, 'Ambato'),                             -- id_provincia = Tungurahua
(18, 'Baños De Agua Santa'),                -- id_provincia = Tungurahua
(18, 'Cevallos'),                           -- id_provincia = Tungurahua
(18, 'Mocha'),                              -- id_provincia = Tungurahua
(18, 'Patate'),                             -- id_provincia = Tungurahua
(18, 'Quero'),                              -- id_provincia = Tungurahua
(18, 'San Pedro De Pelileo'),               -- id_provincia = Tungurahua
(18, 'Santiago De Píllaro'),                -- id_provincia = Tungurahua
(18, 'Tisaleo'),                            -- id_provincia = Tungurahua
(19, 'Zamora'),                             -- id_provincia = Zamora Chinchipe
(19, 'Chinchipe'),                          -- id_provincia = Zamora Chinchipe
(19, 'Nangaritza'),                         -- id_provincia = Zamora Chinchipe
(19, 'Yacuambi'),                           -- id_provincia = Zamora Chinchipe
(19, 'Yantzaza'),                           -- id_provincia = Zamora Chinchipe
(19, 'El Pangui'),                          -- id_provincia = Zamora Chinchipe
(19, 'Centinela Del Cóndor'),               -- id_provincia = Zamora Chinchipe
(19, 'Palanda'),                            -- id_provincia = Zamora Chinchipe
(19, 'Paquisha'),                           -- id_provincia = Zamora Chinchipe
(20, 'San Cristóbal'),                      -- id_provincia = Galapagos
(20, 'Isabela'),                            -- id_provincia = Galapagos
(20, 'Santa Cruz'),                         -- id_provincia = Galapagos
(21, 'Lago Agrio'),                         -- id_provincia = Sucumbios
(21, 'Gonzalo Pizarro'),                    -- id_provincia = Sucumbios
(21, 'Putumayo'),                           -- id_provincia = Sucumbios
(21, 'Shushufindi'),                        -- id_provincia = Sucumbios
(21, 'Sucumbíos'),                          -- id_provincia = Sucumbios
(21, 'Cascales'),                           -- id_provincia = Sucumbios
(21, 'Cuyabeno'),                           -- id_provincia = Sucumbios
(22, 'Orellana'),                           -- id_provincia = Orellana
(22, 'Aguarico'),                           -- id_provincia = Orellana
(22, 'La Joya De Los Sachas'),              -- id_provincia = Orellana
(22, 'Loreto'),                             -- id_provincia = Orellana
(23, 'Santo Domingo De Los Colorados'),     -- id_provincia = Santo Domingo De Los Tsachilas
(24, 'Santa Elena'),                        -- id_provincia = Santa Elena
(24, 'La Libertad'),                        -- id_provincia = Santa Elena
(24, 'Salinas');                            -- id_provincia = Santa Elena



-- ================================================== tbl_empresas ==========

CREATE TABLE IF NOT EXISTS tbl_empresas (
    id_empresa INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_estado INT NOT NULL,
    ruc VARCHAR(13) NOT NULL,
    razon_social VARCHAR(35) NOT NULL,
    e_mail VARCHAR(35) NOT NULL,
    telefono VARCHAR(10) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Claves foráneas
    CONSTRAINT fk_empresas_id_estado FOREIGN KEY (id_estado) REFERENCES tbl_estados(id_estado) ON DELETE RESTRICT,

    -- Claves únicas combinadas
    CONSTRAINT uk_empresas_ruc UNIQUE (ruc),
    CONSTRAINT uk_empresas_e_mail UNIQUE (e_mail),
    CONSTRAINT uk_empresas_telefono UNIQUE (telefono),

    -- Validación para campos de texto
    CONSTRAINT chk_empresas_razon_social CHECK (razon_social REGEXP '^[A-Za-zÁÉÍÓÚáéíóúñÑ ]+$'),
    -- Validación para campos de números
    CONSTRAINT chk_empresas_ruc CHECK (ruc REGEXP '^[0-9]{13}$'),
    CONSTRAINT chk_empresas_telefono CHECK (telefono REGEXP '^[0-9]{10}$'),
    -- Validación para campos de texto-números-caracteres
	CONSTRAINT chk_empresas_e_mail CHECK (e_mail REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO tbl_empresas (id_estado, ruc, razon_social, e_mail, telefono)
VALUES (1, '1234567890001', 'Empresa de Prueba Uno', 'empresa1@prueba.com', '0912345671'),
    (1, '9876543210001', 'Empresa de Prueba Dos', 'empresa2@prueba.com', '0987654322'),
    (1, '5744578532001', 'Empresa de Prueba Tres', 'empresa3@prueba.com', '0974457531');



-- Crear tabla de roles
CREATE TABLE IF NOT EXISTS bd_sct.tbl_roles (
  id_rol INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nombre_rol VARCHAR(15) UNIQUE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insertar bd_sct.tbl_roles
INSERT INTO tbl_roles (nombre_rol)
VALUES ('Administrador'),                       -- id_rol = 1
    ('Editor'),                                 -- id_rol = 2
    ('Visualizador'),                           -- id_rol = 3
    ('Asistente RRHH'),                         -- id_rol = 4
	('Auditoria')								-- id_rol = 5
	('Sistema');								-- id_rol = 6



-- Crear tabla de permisos
CREATE TABLE IF NOT EXISTS bd_sct.tbl_permisos (
  id_permiso INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(40) UNIQUE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insertar permisos
INSERT INTO bd_sct.tbl_permisos (nombre)
VALUES
    ('acceder_modulo_archivo'),                 -- id_permiso = 1
    ('acceder_modulo_contabilidad'),            -- id_permiso = 2
    ('acceder_modulo_ventas'),                  -- id_permiso = 3 (Cuentas por cobrar)
    ('acceder_modulo_compras'),                 -- id_permiso = 4 (Cuentas por pagar)
    ('acceder_modulo_inventario'),              -- id_permiso = 5
    ('acceder_modulo_nomina'),                  -- id_permiso = 6
    ('acceder_modulo_bancos'),                  -- id_permiso = 7
    ('acceder_modulo_instituciones_publicas'),  -- id_permiso = 8
    ('acceder_modulo_ayuda');                   -- id_permiso = 9



-- Crear tabla intermedia para asociar tbl_roles y tbl_permisos (relación muchos a muchos)
CREATE TABLE IF NOT EXISTS bd_sct.tbl_roles_permisos (
	id_rol INT NOT NULL,
	id_permiso INT NOT NULL,
	PRIMARY KEY (id_rol, id_permiso),
	FOREIGN KEY (id_rol) REFERENCES tbl_roles(id_rol) ON DELETE CASCADE,
	FOREIGN KEY (id_permiso) REFERENCES tbl_permisos(id_permiso) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Asignar permisos a los roles
INSERT INTO bd_sct.tbl_roles_permisos (id_rol, id_permiso)
VALUES 
    (1, 1),       					-- Administrador,     acceder_modulo_archivo
    (1, 2),       					-- Administrador,     acceder_modulo_contabilidad
    (1, 3),       					-- Administrador,     acceder_modulo_ventas
    (1, 4),       					-- Administrador,     acceder_modulo_compras
    (1, 5),       					-- Administrador,     acceder_modulo_inventario
    (1, 6),       					-- Administrador,     acceder_modulo_nomina
    (1, 7),       					-- Administrador,     acceder_modulo_bancos
    (1, 8),       					-- Administrador,     acceder_modulo_instituciones_publicas
    (1, 9),       					-- Administrador,     acceder_modulo_ayuda
    (2, 1),       					-- Editor,            acceder_modulo_archivo
    (2, 7),       					-- Editor,            acceder_modulo_bancos
    (3, 1),       					-- Visualizador,      acceder_modulo_archivo
    (3, 9),       					-- Visualizador,      acceder_modulo_ayuda
    (4, 1),       					-- Asistente RRHH,    acceder_modulo_archivo
    (4, 6);       					-- Asistente RRHH,    acceder_modulo_nomina



-- ================================================== tbl_usuarios ==========

CREATE TABLE IF NOT EXISTS bd_sct.tbl_usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    id_empresa INT NOT NULL,
    cedula VARCHAR(10) NOT NULL,
    nombre_uno VARCHAR(15) NOT NULL,
    nombre_dos VARCHAR(15),
    apellido_uno VARCHAR(15) NOT NULL,
    apellido_dos VARCHAR(15),
    id_genero INT NOT NULL,
    e_mail VARCHAR(30) NOT NULL,
    telefono VARCHAR(10) NOT NULL,
    usuario VARCHAR(10) NOT NULL,
    password_hash VARCHAR(64) NOT NULL,

	-- Claves únicas combinadas
    CONSTRAINT uk_usuarios_cedula UNIQUE (cedula),
    CONSTRAINT uk_usuarios_usuario UNIQUE (usuario),
    CONSTRAINT uk_usuarios_e_mail UNIQUE (e_mail),
    CONSTRAINT uk_usuarios_telefono UNIQUE (telefono),

    -- Claves foráneas
    CONSTRAINT fk_usuarios_id_genero FOREIGN KEY (id_genero) REFERENCES tbl_generos(id_genero) ON DELETE RESTRICT,
	CONSTRAINT fk_usuarios_id_empresa FOREIGN KEY (id_empresa) REFERENCES tbl_empresas(id_empresa) ON DELETE RESTRICT,

    -- Validación para campos de texto
    CONSTRAINT chk_usuarios_nombre_uno CHECK (nombre_uno REGEXP '^[A-Za-zÁÉÍÓÚáéíóúñÑ]+$'),
    CONSTRAINT chk_usuarios_nombre_dos CHECK (nombre_dos IS NULL OR nombre_dos REGEXP '^[A-Za-zÁÉÍÓÚáéíóúñÑ]+$'),
    CONSTRAINT chk_usuarios_apellido_uno CHECK (apellido_uno REGEXP '^[A-Za-zÁÉÍÓÚáéíóúñÑ]+$'),
    CONSTRAINT chk_usuarios_apellido_dos CHECK (apellido_dos IS NULL OR apellido_dos REGEXP '^[A-Za-zÁÉÍÓÚáéíóúñÑ]+$'),
    -- Validación para campos de números
    CONSTRAINT chk_usuarios_cedula CHECK (cedula REGEXP '^[0-9]{10}$'),
    CONSTRAINT chk_usuarios_telefono CHECK (telefono REGEXP '^[0-9]{10}$'),
    -- Validación para campos de alfanuméricos
    CONSTRAINT chk_usuarios_usuario CHECK (usuario REGEXP '^[A-Za-z0-9]{8,10}$'),
    -- Validación para campos de texto-números-caracteres
	CONSTRAINT chk_usuarios_e_mail CHECK (e_mail REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO bd_sct.tbl_usuarios (id_empresa, cedula, nombre_uno, nombre_dos, apellido_uno, apellido_dos, id_genero, e_mail, telefono, usuario, password_hash)
VALUES 
    (1, '1234567880', 'Martha', 'Cruz', 'Mora', 'Dominguez', 2, 'marthamora@correo.com', '0939023210', 'admintra', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918'), -- Clave: admin
    (1, '1234567881', 'Carlos', 'Humberto', 'Rivera', 'Mora', 1, 'carlosrivera@correo.com', '0939023211', 'editor12', '1553cc62ff246044c683a61e203e65541990e7fcd4af9443d22b9557ecc9ac54'), -- Clave: editor
    (1, '1234567882', 'Alvaro', 'Manfredo', 'Samaniego', 'Jumbo', 1, 'alvarosamaniego@correo.com', '0939023212', 'viewer12', 'd35ca5051b82ffc326a3b0b6574a9a3161dee16b9478a199ee39cd803ce5b799'), -- Clave: viewer
    (1, '1234567883', 'Rebeca', 'Elizabeth', 'Peralta', 'Huayamave', 2, 'rebecaperalta@correo.com', '0939023213', 'rebeca12', 'e54eb3e2224a469b5b026e9bedd340b90f7d11d37245df6535dc30b73c6a3d8b'), -- Clave: rebeca
    (1, '1234567889', 'Zulema', 'Abigail', 'Cardenas', 'Montoya', 2, 'zulemacardenas@correo.com', '0939023219', 'asistent', '99bde068af2d49ed7fc8b8fa79abe13a6059e0db320bb73459fd96624bb4b33f'); -- Clave: asistente



-- Crear tabla intermedia para asociar tbl_usuarios y tbl_roles (relación muchos a muchos)
CREATE TABLE IF NOT EXISTS tbl_usuarios_roles (
	id_usuario INT NOT NULL,
	id_rol INT NOT NULL,
	PRIMARY KEY (id_usuario, id_rol),
	FOREIGN KEY (id_usuario) REFERENCES tbl_usuarios(id_usuario) ON DELETE CASCADE,
	FOREIGN KEY (id_rol) REFERENCES tbl_roles(id_rol) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Asignar roles a los usuarios
INSERT INTO tbl_usuarios_roles (id_usuario, id_rol)
VALUES
    (1, 1),       					-- admin,         Administrador
    (2, 2),       					-- editor,        Editor
    (3, 3),       					-- viewer,        Visualizador
    (4, 1),       					-- rebeca,        Administrator
    (5, 4);       					-- asistente,     Asistente


