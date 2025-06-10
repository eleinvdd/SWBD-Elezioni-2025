-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Giu 10, 2025 alle 23:10
-- Versione del server: 10.4.28-MariaDB
-- Versione PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `elezioni_2025`
--

DELIMITER $$
--
-- Procedure
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `associaUtente` (IN `user_ID` INT, IN `user_type` VARCHAR(20), IN `codice_fiscale` VARCHAR(16))   BEGIN
    DECLARE rows_updated INT DEFAULT 0;

    IF user_type = 'Cittadino' THEN
        UPDATE Cittadini
        SET ID_utente = user_ID
        WHERE CF = codice_fiscale;
        SET rows_updated = ROW_COUNT();

    ELSEIF user_type = 'Addetto' THEN
        UPDATE Addetti
        SET ID_utente = user_ID
        WHERE CF = codice_fiscale;
        SET rows_updated = ROW_COUNT();

    ELSEIF user_type = 'Candidato' THEN
        UPDATE Candidati
        SET ID_utente = user_ID
        WHERE CF = codice_fiscale;
        SET rows_updated = ROW_COUNT();

    ELSEIF user_type = 'Sindaco' THEN
        UPDATE Sindaci
        SET ID_utente = user_ID
        WHERE CF = codice_fiscale;
        SET rows_updated = ROW_COUNT();

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'userType non valido';
    END IF;

    IF rows_updated = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nessun record aggiornato: CF non trovato';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findListaFromCandidato` (IN `candidato_id` INT, OUT `lista_id` INT)   BEGIN
    SELECT liste.ID
    INTO lista_id
    FROM 
      Candidati 
      INNER JOIN Liste
        ON Candidati.ID_lista = Liste.ID
    WHERE Candidati.ID = candidato_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findSindacoFromCandidato` (IN `candidato_id` INT, OUT `sindaco_id` INT)   BEGIN
    SELECT Sindaci.ID
    INTO sindaco_id
    FROM 
      Candidati 
      INNER JOIN Liste
        ON Candidati.ID_lista = Liste.ID
      INNER JOIN Sindaci
        ON Liste.ID_sindaco = Sindaci.ID
    WHERE Candidati.ID = candidato_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findSindacoFromLista` (IN `lista_id` INT, OUT `sindaco_id` INT)   BEGIN
    SELECT Sindaci.ID
    INTO sindaco_id
    FROM Sindaci
    INNER JOIN Liste ON Liste.ID_sindaco = Sindaci.ID
    WHERE Liste.ID = lista_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IncrementaPreferenzeCandidato` (IN `candidato_id` INT)   BEGIN
    UPDATE Candidati
    SET numPreferenze = numPreferenze + 1
    WHERE ID = candidato_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IncrementaPreferenzeLista` (IN `lista_id` INT)   BEGIN
    UPDATE Liste
    SET numPreferenze = numPreferenze + 1
    WHERE ID = lista_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IncrementaPreferenzeSindaco` (IN `sindaco_id` INT)   BEGIN
    UPDATE Sindaci
    SET numPreferenze = numPreferenze + 1
    WHERE ID = sindaco_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `addetti`
--

CREATE TABLE `addetti` (
  `ID` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cognome` varchar(50) NOT NULL,
  `data_nascita` date NOT NULL,
  `CF` varchar(16) NOT NULL,
  `ruolo` varchar(50) NOT NULL DEFAULT 'Assistente',
  `ID_seggio` int(11) NOT NULL,
  `ID_utente` int(11) DEFAULT NULL
) ;

--
-- Dump dei dati per la tabella `addetti`
--

INSERT INTO `addetti` (`ID`, `nome`, `cognome`, `data_nascita`, `CF`, `ruolo`, `ID_seggio`, `ID_utente`) VALUES
(465, 'Mario', 'Rossi', '1985-03-15', 'CODADD00A00A000A', 'Assistente', 1, 13),
(466, 'Giulia', 'Verdi', '1988-11-05', 'VRDGLL88S45A001C', 'Segretario', 3, NULL),
(467, 'Sara', 'Gentile', '1995-09-30', 'GNTSAR95P30A001F', 'Segretario', 6, NULL),
(468, 'Marco', 'Ricci', '1984-06-18', 'RCCMRC84H18A001G', 'Assistente', 7, NULL),
(469, 'Davide', 'Ferri', '1993-10-03', 'FRRDVD93R03A001I', 'Segretario', 9, NULL),
(470, 'Luca', 'Costa', '1989-02-25', 'CSTLCU89B25A001J', 'Assistente', 10, NULL),
(471, 'Andrea', 'Romano', '1986-08-09', 'RMNAND86M09A001L', 'Segretario', 2, NULL),
(472, 'Francesca', 'Marini', '1992-03-11', 'MRNFNC92C11A001M', 'Assistente', 3, NULL),
(473, 'Alessia', 'Conti', '1994-07-22', 'CNTLSS94L22A001O', 'Segretario', 5, NULL),
(474, 'Stefano', 'Galli', '1987-09-14', 'GLLSTF87P14A001P', 'Assistente', 6, NULL),
(475, 'Fabio', 'Mancini', '1989-11-10', 'MNCFBA89S10A001R', 'Segretario', 8, NULL),
(476, 'Roberta', 'Sanna', '1993-01-19', 'SNNRRT93A19A001S', 'Assistente', 9, NULL),
(477, 'Nicola', 'Moretti', '1988-04-05', 'MRTNCL88D05A001T', 'Supervisore', 10, NULL),
(478, 'Claudia', 'Testa', '1990-06-08', 'TSTCLD90H08A001U', 'Segretario', 1, NULL),
(479, 'Simone', 'Martini', '1986-10-21', 'MRTSMN86R21A001V', 'Assistente', 2, NULL),
(480, 'Laura', 'Ferretti', '1995-03-02', 'FRRLRA95C02A001W', 'Supervisore', 3, NULL),
(481, 'Federico', 'Greco', '1991-08-30', 'GRCFDR91M30A001X', 'Segretario', 4, NULL),
(482, 'Elisa', 'Riva', '1984-02-13', 'RVELSA84B13A001Y', 'Assistente', 5, NULL),
(483, 'Matteo', 'Gatti', '1989-05-29', 'GTTMTT89E29A001Z', 'Supervisore', 6, NULL),
(484, 'Valeria', 'Russo', '1992-07-07', 'RSSVLR92L07A001A', 'Segretario', 7, NULL),
(485, 'Emanuele', 'Villa', '1990-09-16', 'VLLMNL90P16A001B', 'Assistente', 8, NULL),
(486, 'Silvia', 'Monti', '1987-12-03', 'MNTSLV87T03A001C', 'Supervisore', 9, NULL),
(487, 'Cristina', 'Serra', '1988-06-11', 'SRRCST88H11A001E', 'Assistente', 1, NULL),
(488, 'Daniele', 'Grimaldi', '1994-01-23', 'GRMDNL94A23A001F', 'Supervisore', 2, NULL),
(489, 'Teresa', 'Pagano', '1991-04-04', 'PGNTRS91D04A001G', 'Segretario', 3, NULL),
(490, 'Gabriele', 'De Rosa', '1985-07-30', 'DRSGRL85L30A001H', 'Assistente', 4, NULL),
(491, 'Lucia', 'Marchetti', '1989-10-19', 'MRCLCA89R19A001I', 'Supervisore', 5, NULL),
(492, 'Pietro', 'Caruso', '1990-11-27', 'CRSPTR90S27A001J', 'Segretario', 6, NULL),
(493, 'Alberto', 'Bianco', '1992-02-14', 'BNCALB92B14A001K', 'Assistente', 7, NULL),
(494, 'Beatrice', 'Sorrentino', '1993-06-06', 'SRRBTR93H06A001L', 'Supervisore', 8, NULL),
(495, 'Leonardo', 'Mazza', '1987-08-01', 'MZZLNR87M01A001M', 'Segretario', 9, NULL),
(496, 'Chiara', 'Colombo', '1995-12-12', 'CLMCHR95T12A001N', 'Assistente', 10, NULL),
(497, 'Tommaso', 'Ferrari', '1986-01-09', 'FRTTMS86A09A001O', 'Supervisore', 1, NULL),
(498, 'Ilaria', 'Palmieri', '1991-03-15', 'PLMLRA91C15A001P', 'Segretario', 2, NULL),
(499, 'Lorenzo', 'D’Amico', '1988-05-04', 'DMLLRZ88E04A001Q', 'Assistente', 3, NULL),
(500, 'Serena', 'Valenti', '1994-09-13', 'VLTSRN94P13A001R', 'Supervisore', 4, NULL),
(501, 'Giorgio', 'Caputo', '1985-11-25', 'CPTGRG85S25A001S', 'Segretario', 5, NULL),
(502, 'Camilla', 'Negri', '1990-07-01', 'NGRCML90L01A001T', 'Assistente', 6, NULL),
(503, 'Antonio', 'Milani', '1992-10-10', 'MLNNTN92R10A001U', 'Supervisore', 7, NULL),
(504, 'Veronica', 'Sala', '1989-04-17', 'SLAVRN89D17A001V', 'Segretario', 8, NULL),
(505, 'Alessandro', 'Pellegrini', '1987-06-26', 'PLGLSN87H26A001W', 'Assistente', 9, NULL);

--
-- Trigger `addetti`
--
DELIMITER $$
CREATE TRIGGER `checkSupervisoreUnico_INSERT` BEFORE INSERT ON `addetti` FOR EACH ROW BEGIN
    DECLARE error_message VARCHAR(255);
    
    IF NEW.ruolo = 'Supervisore' THEN
        IF EXISTS (
            SELECT 1 FROM Addetti
            WHERE ID_seggio = NEW.ID_seggio
              AND ruolo = 'Supervisore'
        ) THEN
            SET error_message = CONCAT('Il seggio ', NEW.ID_seggio, ' può avere al massimo un supervisore.');
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `checkSupervisoreUnico_UPDATE` BEFORE UPDATE ON `addetti` FOR EACH ROW BEGIN
		DECLARE error_message VARCHAR(255);
    
    IF NEW.ruolo = 'Supervisore' THEN
        IF EXISTS (
            SELECT 1 FROM Addetti
            WHERE ID_seggio = NEW.ID_seggio
              AND ruolo = 'Supervisore'
          		-- escludo sè stesso
          		AND ID <> NEW.ID
        ) THEN
            SET error_message = CONCAT('Il seggio ', NEW.ID_seggio, ' può avere al massimo un supervisore.');
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `candidati`
--

CREATE TABLE `candidati` (
  `ID` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cognome` varchar(50) NOT NULL,
  `data_nascita` date NOT NULL,
  `CF` varchar(16) NOT NULL,
  `ruoloCandidato` varchar(50) NOT NULL DEFAULT 'Candidato Semplice',
  `ID_lista` int(11) NOT NULL,
  `numCandidato` int(11) NOT NULL,
  `numPreferenze` int(11) NOT NULL DEFAULT 0,
  `ID_utente` int(11) DEFAULT NULL
) ;

--
-- Dump dei dati per la tabella `candidati`
--

INSERT INTO `candidati` (`ID`, `nome`, `cognome`, `data_nascita`, `CF`, `ruoloCandidato`, `ID_lista`, `numCandidato`, `numPreferenze`, `ID_utente`) VALUES
(1, 'Elisa', 'Pellegrini', '1975-05-25', 'CANCOD00A00A000A', 'Consigliere', 1, 1, 1, 10),
(2, 'Elisa', 'Gatti', '1984-07-08', 'CANCOD00A00A000B', 'Consigliere', 1, 2, 3, NULL),
(3, 'Chiara', 'Parisi', '1975-02-15', '363DBD6946C345', 'Candidato Semplice', 1, 3, 2, NULL),
(4, 'Alice', 'Neri', '1993-07-09', '234CA4B0B3E244', 'Candidato Semplice', 2, 1, 1, NULL),
(5, 'Andrea', 'Russo', '1977-01-22', '4CEC2E40662348', 'Assessore', 2, 2, 3, NULL),
(6, 'Marta', 'Martini', '1983-12-19', '48A7F49EF4DD48', 'Assessore', 2, 3, 3, NULL),
(7, 'Elisa', 'Gatti', '1996-05-17', 'BA2827474A2B48', 'Assessore', 2, 4, 3, NULL),
(8, 'Davide', 'Rossi', '1995-06-24', 'A326AECB050145', 'Candidato Semplice', 2, 5, 0, NULL),
(9, 'Luca', 'Fabbri', '1988-08-26', 'A9A345DCDEB94E', 'Candidato Semplice', 3, 1, 1, NULL),
(10, 'Matteo', 'Parisi', '1997-06-25', 'EE98D2BC20954E', 'Consigliere', 3, 2, 1, NULL),
(11, 'Valentina', 'Conti', '1983-07-31', '6FDDD8215F4344', 'Candidato Semplice', 3, 3, 0, NULL),
(12, 'Giulia', 'Fontana', '1987-07-01', '098407B57FAA45', 'Assessore', 3, 4, 0, NULL),
(13, 'Matteo', 'Martini', '2000-03-13', '561CA08196884A', 'Consigliere', 4, 1, 0, NULL),
(14, 'Davide', 'Pellegrini', '1986-08-24', 'CD35BAB0B57D48', 'Assessore', 4, 2, 1, NULL),
(15, 'Chiara', 'Piras', '1996-09-04', '4CFF07E75A584D', 'Assessore', 4, 3, 0, NULL),
(16, 'Francesco', 'Bianchi', '1976-03-07', '95FCB49248644D', 'Candidato Semplice', 4, 4, 1, NULL),
(17, 'Paolo', 'Negri', '1991-10-17', '549E16BCDF564F', 'Consigliere', 5, 1, 0, NULL),
(18, 'Luca', 'Gallo', '1987-01-15', '7353EF7794FD45', 'Candidato Semplice', 5, 2, 0, NULL),
(19, 'Giulia', 'Romano', '1978-07-19', '0E06092A64554E', 'Candidato Semplice', 5, 3, 0, NULL),
(20, 'Francesco', 'Romano', '1994-01-30', '1023BAAE4A0B4B', 'Consigliere', 5, 4, 0, NULL),
(21, 'Davide', 'Serra', '1975-01-09', '2776E826B2FA44', 'Consigliere', 5, 5, 0, NULL),
(22, 'Giorgio', 'Conti', '1979-05-28', 'F5A558D8FAED4D', 'Consigliere', 6, 1, 0, NULL),
(23, 'Simone', 'Negri', '2000-10-09', '956418D3F00B43', 'Assessore', 6, 2, 0, NULL),
(24, 'Anna', 'Fontana', '1989-12-13', '9EDE2D6C002E44', 'Assessore', 6, 3, 0, NULL),
(25, 'Alessio', 'Conti', '1996-07-09', '7F3821533C624D', 'Assessore', 6, 4, 0, NULL),
(26, 'Elisa', 'Gatti', '1985-04-05', 'BC82CD467FF84A', 'Candidato Semplice', 6, 5, 0, NULL),
(27, 'Giovanni', 'Gallo', '1982-04-30', '9CA5ACCB999847', 'Assessore', 7, 1, 0, NULL),
(28, 'Marta', 'Conti', '1979-07-20', '6D7670D639E842', 'Candidato Semplice', 7, 2, 0, NULL),
(29, 'Marta', 'Fontana', '1993-03-03', 'C24CAD5185AA4B', 'Assessore', 7, 3, 0, NULL),
(30, 'Mario', 'Pellegrini', '1992-03-20', 'ED697222B6034A', 'Consigliere', 7, 4, 0, NULL),
(31, 'Giulia', 'Corsi', '1991-04-17', '5870E3A947F340', 'Assessore', 7, 5, 0, NULL),
(32, 'Stefano', 'Lombardi', '1990-11-03', '3226DBC0879248', 'Assessore', 8, 1, 0, NULL),
(33, 'Davide', 'Fontana', '1975-04-11', '4FD8068768774F', 'Candidato Semplice', 8, 2, 0, NULL),
(34, 'Stefano', 'Riva', '1984-01-29', 'CE394419758A45', 'Assessore', 8, 3, 0, NULL),
(35, 'Giorgio', 'Marino', '1992-12-06', '1EF0578FF26A48', 'Consigliere', 9, 1, 1, NULL),
(36, 'Nicola', 'Fabbri', '1976-04-23', 'D1565BD6E5C448', 'Consigliere', 9, 2, 1, NULL),
(37, 'Giulia', 'Lombardi', '1982-09-15', 'BEB62C50829041', 'Candidato Semplice', 9, 3, 1, NULL),
(38, 'Stefano', 'Verdi', '1982-06-30', 'A198E2C2936A4B', 'Consigliere', 10, 1, 0, NULL),
(39, 'Serena', 'Pellegrini', '2000-06-15', 'E9C2B5C3C21446', 'Assessore', 10, 2, 0, NULL),
(40, 'Nicola', 'Russo', '1984-11-02', '8D082A5EA1C44D', 'Assessore', 10, 3, 0, NULL),
(41, 'Alessio', 'Bianchi', '1999-09-01', '9923F1AFF4A744', 'Assessore', 10, 4, 0, NULL);

--
-- Trigger `candidati`
--
DELIMITER $$
CREATE TRIGGER `incrementaNumCandidato` BEFORE INSERT ON `candidati` FOR EACH ROW BEGIN
    DECLARE max_num INT;

    -- Trova il massimo numCandidato per la lista specifica
    SELECT IFNULL(MAX(numCandidato), 0)
    INTO max_num
    FROM Candidati
    WHERE ID_lista = NEW.ID_lista;

    -- Assegna il valore successivo
    SET NEW.numCandidato = max_num + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `cittadini`
--

CREATE TABLE `cittadini` (
  `ID` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cognome` varchar(50) NOT NULL,
  `data_nascita` date NOT NULL,
  `CF` varchar(16) NOT NULL,
  `ID_voto` int(11) DEFAULT NULL,
  `ID_utente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `cittadini`
--

INSERT INTO `cittadini` (`ID`, `nome`, `cognome`, `data_nascita`, `CF`, `ID_voto`, `ID_utente`) VALUES
(1, 'Eugenia', 'Caracciolo', '1937-10-22', 'LBCBFN43O32G181E', 27, 3),
(2, 'Chiara', 'Avogadro', '1961-06-19', 'WZKSBV86R37J940U', NULL, 6),
(3, 'Giampiero', 'Morandini', '1948-04-24', 'ZCUDIH16Y15F594U', NULL, 7),
(4, 'Amanda', 'Magnani', '1983-08-15', 'OGYRDO93X10K341V', 25, 8),
(5, 'Napoleone', 'Norbiato', '1962-12-01', 'DYROSJ41O92R832X', 26, 9),
(6, 'Manuel', 'Bertolucci', '1965-07-30', 'TUNPFZ05P64D139C', NULL, 14),
(7, 'Emilio', 'Iannuzzi', '1953-05-29', 'ZXOIGF38F84W969S', NULL, NULL),
(8, 'Antonio', 'Capecchi', '1955-03-16', 'DHQJAR26U91H669C', NULL, NULL),
(9, 'Giuliana', 'Valier', '1970-09-19', 'UUQGWL51G46G270S', NULL, NULL),
(10, 'Susanna', 'Mancini', '2003-07-01', 'AMUFBH93X25Z288G', NULL, NULL),
(11, 'Livio', 'Giradello', '1942-04-15', 'XIIQEJ39K11Q718C', NULL, NULL),
(12, 'Vincenzo', 'Ramazzotti', '1963-03-25', 'CHPOEV83B46L578U', NULL, NULL),
(13, 'Angelica', 'Giammusso', '1964-05-17', 'EGPRQF01N03I105S', NULL, NULL),
(14, 'Donatello', 'Serraglio', '1967-06-23', 'BADUDR76P31P165K', NULL, NULL),
(15, 'Cirillo', 'Bignardi', '1989-03-14', 'IBLRDP51E33C387A', NULL, NULL),
(16, 'Ornella', 'Vigliotti', '1947-09-24', 'FENZDK08Y01A326G', NULL, NULL),
(17, 'Ottavio', 'Impastato', '1996-04-30', 'NDLVID46V87U234B', NULL, NULL),
(18, 'Arturo', 'Benigni', '1999-04-18', 'EMERPZ88H20K812B', NULL, NULL),
(19, 'Gioffre', 'Barsanti', '1945-07-24', 'QTUPQZ69I98Q543Q', NULL, NULL),
(20, 'Fabia', 'Mantegazza', '1996-08-18', 'EINGQI51W07E991O', NULL, NULL),
(21, 'Tiziana', 'Gottardi', '1984-09-11', 'AQJTQG42I78Q498W', NULL, NULL),
(22, 'Daniele', 'Canevascini', '1955-07-24', 'GFQDFO44B93R534X', NULL, NULL),
(23, 'Antonello', 'Agazzi', '1979-10-20', 'AHESJI24C27X868I', NULL, NULL),
(24, 'Berenice', 'Viola', '1954-07-23', 'NRPQGW62X04J505X', NULL, NULL),
(25, 'Valentina', 'Pisano', '1955-06-09', 'YAZQVZ32P26R025E', NULL, NULL),
(26, 'Ermes', 'Cannizzaro', '1986-06-20', 'YOOBQM07Z33V754F', NULL, NULL),
(27, 'Gustavo', 'Bonanno', '1972-05-23', 'QLLQCG58M68B501W', NULL, NULL),
(28, 'Matteo', 'Mazzini', '1993-10-18', 'CTBAHZ98I16R934Y', NULL, NULL),
(29, 'Liana', 'Ferrucci', '1983-12-22', 'GTQAUZ61S59S514U', NULL, NULL),
(30, 'Angelica', 'Cendron', '1960-07-06', 'JATSNB66Y29L946L', NULL, NULL),
(31, 'Clelia', 'Milanesi', '1997-09-08', 'SGQONV77F38W721X', NULL, NULL),
(32, 'Gianpietro', 'Mastroianni', '1964-12-22', 'XEDAOK32M00T379J', NULL, NULL),
(33, 'Ida', 'Pastine', '2001-09-08', 'LZSHDD63J20P163Y', NULL, NULL),
(34, 'Sandra', 'Cassarà', '1996-07-11', 'NUGBJC27K88V957C', NULL, NULL),
(35, 'Sophia', 'Sibilia', '1995-08-29', 'CETSPR43V48U734Z', NULL, NULL),
(36, 'Vincenza', 'Vecoli', '1945-05-15', 'AAVIDA22D36N231B', NULL, NULL),
(37, 'Roberta', 'Pugliese', '1987-05-30', 'TWYAIV90V96I705L', NULL, NULL),
(38, 'Nicoletta', 'Galuppi', '2000-11-07', 'QRZZUK34D67I065K', NULL, NULL),
(39, 'Donna', 'Udinese', '1938-01-27', 'DLDQYU69N90D162X', NULL, NULL),
(40, 'Marcantonio', 'Moresi', '1986-01-01', 'DWOPEX46P41C708R', NULL, NULL),
(41, 'Margherita', 'Bajamonti', '1968-01-22', 'QHKNDS30Q92X327Z', NULL, NULL),
(42, 'Nanni', 'Detti', '1949-12-28', 'RYZTME24L19S049T', NULL, NULL),
(43, 'Rita', 'Golino', '1948-04-09', 'BQXEGP49V19A058U', NULL, NULL),
(44, 'Sandra', 'Pugliese', '2001-02-13', 'UHPRNZ16I57X262S', NULL, NULL),
(45, 'Saverio', 'Scarpetta', '1993-09-07', 'PWDKNQ94Y53V147Z', NULL, NULL),
(46, 'Alphons', 'Tagliafierro', '1978-08-21', 'MSRJAH27M35F454F', NULL, NULL),
(47, 'Gioacchino', 'Pisano', '2000-11-24', 'SOZSPT83Q77L701N', NULL, NULL),
(48, 'Nanni', 'Sforza', '2006-08-30', 'TQOHUM56U85H574M', NULL, NULL),
(49, 'Luciana', 'Valentino', '1959-08-08', 'SGMSOX33L74T989F', NULL, NULL),
(50, 'Alberto', 'Udinese', '1951-08-19', 'GAKSEE40C08V427A', NULL, NULL),
(51, 'Fiorino', 'Bergoglio', '1968-10-06', 'ORDJJZ71K16T719C', NULL, NULL),
(52, 'Calcedonio', 'Grassi', '1950-07-11', 'YCCTLB86T99K938V', NULL, NULL),
(53, 'Donatella', 'Bignami', '1947-11-28', 'JEKAAC33S41M232D', NULL, NULL),
(54, 'Ruggiero', 'Maderno', '1938-11-05', 'YYOLQZ34M47B134I', NULL, NULL),
(55, 'Damiano', 'Verdi', '1964-12-31', 'MVKSCH24D21S024P', NULL, NULL),
(56, 'Leopoldo', 'Pinamonte', '1971-06-16', 'BVUMQB88F77O190O', NULL, NULL),
(57, 'Gianna', 'Argan', '1971-01-31', 'LLBOFF90E27W874X', NULL, NULL),
(58, 'Pierangelo', 'Montecchi', '1978-02-05', 'WJCDFU12Q56U746A', NULL, NULL),
(59, 'Daniele', 'Piovani', '2004-06-09', 'XNWFOC08W76D038B', NULL, NULL),
(60, 'Gastone', 'Interiano', '1952-03-26', 'TKTJAJ47A71F093Z', NULL, NULL),
(61, 'Gianluca', 'Carli', '1997-03-16', 'EEPDJJ12Y74M846L', NULL, NULL),
(62, 'Caterina', 'Tomasetti', '1952-12-24', 'SUTLLQ14F65J840Q', NULL, NULL),
(63, 'Riccardo', 'Vasari', '2000-04-27', 'MSPKYO55X88A675K', NULL, NULL),
(64, 'Antonello', 'Merisi', '1998-10-10', 'LVGCGH66D27A028D', NULL, NULL),
(65, 'Licia', 'Collina', '1990-03-15', 'PFVRIY21U74O596L', NULL, NULL),
(66, 'Letizia', 'Sraffa', '1939-04-16', 'GWOTGC91K34S316F', NULL, NULL),
(67, 'Leonardo', 'Badoer', '1940-08-30', 'PHAKRY50L45K562R', NULL, NULL),
(68, 'Federico', 'Bosurgi', '1986-06-20', 'OQDQQA93Z79D237D', NULL, NULL),
(69, 'Zaira', 'Lupo', '1955-11-27', 'DTMYEG17P59Y464L', NULL, NULL),
(70, 'Antonietta', 'Oliboni', '1974-09-02', 'MVFSXZ40O64M090W', NULL, NULL),
(71, 'Nina', 'Niggli', '1964-03-17', 'YCCLXU39I42F104P', NULL, NULL),
(72, 'Laureano', 'Molesini', '1990-12-14', 'RKQEZS23V28V588N', NULL, NULL),
(73, 'Ninetta', 'Carosone', '1998-02-21', 'YZAQIH12D36X851K', NULL, NULL),
(74, 'Giada', 'Iacobucci', '1986-04-05', 'UNOPEO51D37S098K', NULL, NULL),
(75, 'Leone', 'Pizzetti', '1950-04-13', 'PIIYDX20Q04V711N', NULL, NULL),
(76, 'Ida', 'Vecoli', '1991-06-12', 'RCSXNC92C61P796B', NULL, NULL),
(77, 'Silvia', 'Orlando', '1947-12-04', 'HDFQNP58O50M643E', NULL, NULL),
(78, 'Alessandro', 'Benussi', '1979-10-17', 'LNOVXJ32Y93M183D', NULL, NULL),
(79, 'Adamo', 'Lerner', '1954-02-04', 'AWYYPL28U42B102Z', NULL, NULL),
(80, 'Federico', 'Impastato', '1941-07-14', 'XXGLGC26G81O177H', NULL, NULL),
(81, 'Diana', 'Battaglia', '2005-05-16', 'RGFTCE47F00U766N', NULL, NULL),
(82, 'Concetta', 'Comolli', '1943-05-06', 'MHSDGM24B99G856V', NULL, NULL),
(83, 'Nadia', 'Carocci', '1963-09-01', 'AUGUBU67Q36Q576R', NULL, NULL),
(84, 'Nico', 'Corradi', '1998-12-13', 'ZIJDLJ11J11V615L', NULL, NULL),
(85, 'Germana', 'Castellitto', '1990-04-25', 'GKGNJQ56E04O945X', NULL, NULL),
(86, 'Rossana', 'Cannizzaro', '1982-01-20', 'JXNNRP85J14B936N', NULL, NULL),
(87, 'Concetta', 'Interminei', '1938-05-06', 'JKQZEJ24V45O502S', NULL, NULL),
(88, 'Amadeo', 'Buscetta', '2006-08-08', 'TUUXKM36F67D525L', NULL, NULL),
(89, 'Ermanno', 'Cristoforetti', '1941-03-05', 'ARNWGH14W76B797S', NULL, NULL),
(90, 'Costantino', 'Lopresti', '2000-08-19', 'ANTNXI84W03Q690L', NULL, NULL),
(91, 'Jacopo', 'Mondadori', '1950-09-25', 'TOGJQZ07W62E268C', NULL, NULL),
(92, 'Paride', 'Basso', '1993-10-09', 'ZTOASH07Z15B969K', NULL, NULL),
(93, 'Manuel', 'Donà', '1997-01-08', 'ZHFZTV51V61O369Z', NULL, NULL),
(94, 'Mariano', 'Dibiasi', '1944-10-18', 'UPJPGJ81Q88M355Z', NULL, NULL),
(95, 'Fedele', 'Correr', '1944-08-28', 'PONUOU27J79C979S', NULL, NULL),
(96, 'Baldassare', 'Scotto', '1994-08-03', 'TDCCDX44S90E581K', NULL, NULL),
(97, 'Fabia', 'Bulzoni', '2003-06-01', 'PMUMEG67J98D079F', NULL, NULL),
(98, 'Roberto', 'Camiscione', '1981-02-22', 'HHNKXX18S20Y377Y', NULL, NULL),
(99, 'Pierangelo', 'Moretti', '1941-07-13', 'QUQMJV51F51L864H', NULL, NULL),
(100, 'Francesca', 'Cipolla', '1982-01-05', 'YPYVIQ46S29V148F', NULL, NULL),
(101, 'Giulietta', 'Troisi', '1947-02-14', 'NVXFMO68I50J542A', NULL, NULL),
(102, 'Beppe', 'Malaparte', '1948-03-02', 'MYJKLS88X80N592O', NULL, NULL),
(103, 'Paloma', 'Delle', '1993-12-20', 'WVYCOI06P53T794I', NULL, NULL),
(104, 'Paloma', 'Scotto', '1960-10-22', 'HAKMZM59I77Q468Z', NULL, NULL),
(105, 'Arnaldo', 'Solimena', '1984-12-04', 'RCGJBF81O81C412R', NULL, NULL),
(106, 'Valentina', 'Necci', '1938-01-12', 'FXOBUG60T68P536O', NULL, NULL),
(107, 'Mario', 'Comboni', '1953-02-17', 'AFBQNJ04J72U779Y', NULL, NULL),
(108, 'Concetta', 'Tron', '1992-01-04', 'AOYNDE14H34F103E', NULL, NULL),
(109, 'Cassandra', 'Valentino', '1936-08-22', 'NWPKAL89Q32Q460L', NULL, NULL),
(110, 'Calcedonio', 'Trevisan', '1983-06-25', 'YECOYX18Q88V880C', NULL, NULL),
(111, 'Alderano', 'Novaro', '1943-08-07', 'WIVPLX53R19D520R', NULL, NULL),
(112, 'Ida', 'Soderini', '1959-03-19', 'YMCUTG21Z70I430J', NULL, NULL),
(113, 'Salvatore', 'Grisoni', '1939-05-22', 'ZXBZVC34Y50V541G', NULL, NULL),
(114, 'Flavio', 'Tamburello', '2002-02-12', 'MLISUG58F41U616V', NULL, NULL),
(115, 'Fortunata', 'Malaparte', '1976-02-12', 'CUWNBR79O62Y757G', NULL, NULL),
(116, 'Arturo', 'Borromeo', '1989-09-08', 'CIEPXP58X20X297Y', NULL, NULL),
(117, 'Oreste', 'Zola', '1938-10-23', 'KIHXZU92P75R571U', NULL, NULL),
(118, 'Gionata', 'Carli', '1937-12-06', 'XQTCNN27S86S814C', NULL, NULL),
(119, 'Silvestro', 'Filippini', '1951-02-04', 'QWTEJI21S72T715Z', NULL, NULL),
(120, 'Serafina', 'Cristoforetti', '1958-02-05', 'YFBXJK58X31D323V', NULL, NULL),
(121, 'Ninetta', 'Villadicani', '1952-01-24', 'AXAKEI91U14P678A', NULL, NULL),
(122, 'Benito', 'Salgari', '1997-10-20', 'BGDHHJ85T28K922N', NULL, NULL),
(123, 'Ernesto', 'Mimun', '1965-02-02', 'RIOTNI58F41G438T', NULL, NULL),
(124, 'Eva', 'Disdero', '1955-05-23', 'FCPXKQ29P95N900D', NULL, NULL),
(125, 'Marisa', 'Prati', '1938-07-11', 'TDESDK78C44A736J', NULL, NULL),
(126, 'Saverio', 'Scarpa', '1962-03-04', 'IWXGJG59U25P556S', NULL, NULL),
(127, 'Rosario', 'Castellitto', '1970-10-22', 'NAPKUK73U21U046H', NULL, NULL),
(128, 'Franco', 'Cuomo', '2002-03-20', 'ZGDPNL87W74D701K', NULL, NULL),
(129, 'Armando', 'Lombardi', '2001-10-04', 'IQUXWZ97X48C016I', NULL, NULL),
(130, 'Pasquale', 'Berengario', '1960-11-23', 'WJRNRN58H41I687H', NULL, NULL),
(131, 'Cipriano', 'Pertile', '1985-03-12', 'ZGCCCI58T52V398U', NULL, NULL),
(132, 'Ninetta', 'Sgalambro', '2005-01-31', 'UKZNVT72L98V259M', NULL, NULL),
(133, 'Tonino', 'Tommaseo', '2006-11-08', 'RHALTY79U47S055J', NULL, NULL),
(134, 'Elisa', 'Avogadro', '1998-12-30', 'KHOUNX49Y93J097V', NULL, NULL),
(135, 'Pina', 'Golgi', '1938-09-13', 'JASNAG91X30N756Y', NULL, NULL),
(136, 'Sabatino', 'Blasi', '1953-03-13', 'ULDIVI83W85R786A', NULL, NULL),
(137, 'Martina', 'Iannucci', '2000-04-19', 'XSTNST33F48U434G', NULL, NULL),
(138, 'Sante', 'Navone', '1971-08-15', 'XZJSCS41T98F665V', NULL, NULL),
(139, 'Mattia', 'Roth', '1969-04-21', 'IGNVLP73P38D484D', NULL, NULL),
(140, 'Gemma', 'Turchi', '1965-02-12', 'RXIAJK30A16P571K', NULL, NULL),
(141, 'Tiziana', 'Silvestri', '1999-05-21', 'OIVUCL34A54L019V', NULL, NULL),
(142, 'Amleto', 'Petrucelli', '2001-10-28', 'GVSDPI24H00F499D', NULL, NULL),
(143, 'Veronica', 'Chigi', '2003-01-10', 'PQTLAV74V31Y527A', NULL, NULL),
(144, 'Laureano', 'Zoppetti', '1960-09-10', 'ZQGLIE29U66P851W', NULL, NULL),
(145, 'Adriano', 'Gulotta', '1986-08-10', 'AQPXSP37D45Q499H', NULL, NULL),
(146, 'Danilo', 'Scarponi', '1976-02-28', 'NOOIEJ26D84V145O', NULL, NULL),
(147, 'Clelia', 'Paltrinieri', '1990-12-31', 'HCHTXE87K83H391U', NULL, NULL),
(148, 'Augusto', 'Versace', '2003-03-14', 'CHRNTL39F82F258E', NULL, NULL),
(149, 'Vittoria', 'Tonisto', '1995-01-13', 'DJDRZT07U28B679P', NULL, NULL),
(150, 'Paolo', 'Gualandi', '1934-10-24', 'IDEECS39A10L651E', NULL, NULL),
(151, 'Marissa', 'Chittolini', '1991-08-13', 'IPWHLI56Z76H618Z', NULL, NULL),
(152, 'Dionigi', 'Garobbio', '1934-11-16', 'OPDWJR04M78U686S', NULL, NULL),
(153, 'Marina', 'Carfagna', '1938-10-15', 'MCCMRT69D03P311V', NULL, NULL),
(154, 'Lucia', 'Battisti', '1989-02-24', 'SOUKUK73M83X028U', NULL, NULL),
(155, 'Giada', 'Michelangeli', '1966-08-24', 'DJLVLO42R83B644S', NULL, NULL),
(156, 'Angelina', 'Tamborini', '1940-10-13', 'TYLWIE56P85O662O', NULL, NULL),
(157, 'Leonardo', 'Collina', '1997-06-03', 'YPQNVP08F66C882E', NULL, NULL),
(158, 'Rossana', 'Pagliaro', '1946-12-27', 'CEMZWL83U04Q699L', NULL, NULL),
(159, 'Annalisa', 'Gagliardi', '1999-08-25', 'VWEPSM35T40N331E', NULL, NULL),
(160, 'Paride', 'Giradello', '1978-03-05', 'XGFDGZ46U78E544S', NULL, NULL),
(161, 'Maria', 'Micca', '1962-01-18', 'BQJLLU55A60S932P', NULL, NULL),
(162, 'Eraldo', 'Ferrazzi', '1979-04-19', 'QWFUPV36F93D785M', NULL, NULL),
(163, 'Fabrizio', 'Niggli', '1957-06-10', 'CEQDWA28A72I808I', NULL, NULL),
(164, 'Rosaria', 'Gianinazzi', '1943-08-27', 'NOQNEQ20F38B750M', NULL, NULL),
(165, 'Adriano', 'Turrini', '1990-05-21', 'GSRBZL00G84G840J', NULL, NULL),
(166, 'Venancio', 'Condoleo', '1967-03-14', 'FXZDKP39S84O546O', NULL, NULL),
(167, 'Leonardo', 'Bottigliero', '1938-09-19', 'OASKFF16B66P870Q', NULL, NULL),
(168, 'Mercedes', 'Montanari', '1947-05-20', 'CERRIK80Q33C974H', NULL, NULL),
(169, 'Ferdinando', 'Medici', '1936-07-14', 'KPKYRI39V26Y142F', NULL, NULL),
(170, 'Margherita', 'Cilibrasi', '1945-01-28', 'VMXNMZ85X01U631I', NULL, NULL),
(171, 'Amadeo', 'Leblanc', '1995-09-21', 'RLQYFX73N58S662L', NULL, NULL),
(172, 'Nedda', 'Gozzi', '1944-05-29', 'XGFATC14X26W265W', NULL, NULL),
(173, 'Greco', 'Camicione', '1952-06-08', 'AGBFWJ12F67M888J', NULL, NULL),
(174, 'Caterina', 'Mocenigo', '1986-11-01', 'KHKRYK04I66R183J', NULL, NULL),
(175, 'Leone', 'Inzaghi', '2001-07-08', 'EYEXQP21U26O464H', NULL, NULL),
(176, 'Simone', 'Ferrata', '1996-09-19', 'YZVCVB12P40M659F', NULL, NULL),
(177, 'Durante', 'Mantegna', '1978-01-17', 'SVSOFK93Y75P265H', NULL, NULL),
(178, 'Manuel', 'Paoletti', '1972-07-20', 'LRXJBU65D19T398W', NULL, NULL),
(179, 'Giacobbe', 'Roncalli', '1974-01-20', 'QJTBYY16E72C434Y', NULL, NULL),
(180, 'Caterina', 'Soffici', '1988-12-14', 'MOFGXP88Q68Q058I', NULL, NULL),
(181, 'Michelangelo', 'Dellucci', '1940-06-07', 'QOGVHJ96L56S101V', NULL, NULL),
(182, 'Aria', 'Galvani', '1995-01-27', 'BEGSAF56H79U825F', NULL, NULL),
(183, 'Elmo', 'Navarria', '1976-11-07', 'GCUSCU57E38T757D', NULL, NULL),
(184, 'Antonello', 'Carosone', '1937-06-23', 'KVJBDO51Z23Z828V', NULL, NULL),
(185, 'Elisa', 'Fallaci', '1959-10-09', 'BYATNN66R09W379C', NULL, NULL),
(186, 'Irma', 'Boaga', '1948-04-02', 'QQFHOU82M55Y371M', NULL, NULL),
(187, 'Cristina', 'Perini', '1949-12-13', 'LFRIUH55P79T249Q', NULL, NULL),
(188, 'Daniele', 'Fagotto', '1985-03-18', 'YBLFOI28S66P929C', NULL, NULL),
(189, 'Fedele', 'Vittadello', '1957-02-10', 'DWAFIM74Y22J579M', NULL, NULL),
(190, 'Toni', 'Taliani', '1990-02-01', 'BYWOSC76R77O219O', NULL, NULL),
(191, 'Adele', 'Lussu', '1957-04-18', 'HRXIXI79W78C819J', NULL, NULL),
(192, 'Maria', 'Rossi', '1964-02-23', 'WFCHXZ61P34N074U', NULL, NULL),
(193, 'Paola', 'Nicolini', '1992-09-04', 'WIRMIK29U23T309J', NULL, NULL),
(194, 'Lamberto', 'Luxardo', '1970-10-15', 'SIPJTU81P26W042I', NULL, NULL),
(195, 'Rosaria', 'Perozzo', '2001-01-07', 'OYXFZG29V46R671U', NULL, NULL),
(196, 'Griselda', 'Pacillo', '1996-04-15', 'EYIZNB75N90F175T', NULL, NULL),
(197, 'Graziano', 'Miniati', '1972-12-31', 'RWDCGO58Y92D975P', NULL, NULL),
(198, 'Alderano', 'Catenazzi', '1955-11-27', 'KRFPXQ77F06X324Z', NULL, NULL),
(199, 'Gabriella', 'Deledda', '1941-06-14', 'NEEILO64H36R110C', NULL, NULL),
(200, 'Renzo', 'Aloisio', '1935-07-02', 'YFUZGG51U62X713Y', NULL, NULL),
(201, 'Daniele', 'Diana', '2001-07-19', 'DNIDNL01L19F592D', NULL, 4);

-- --------------------------------------------------------

--
-- Struttura della tabella `liste`
--

CREATE TABLE `liste` (
  `ID` int(11) NOT NULL,
  `titolo` varchar(50) NOT NULL,
  `numPreferenze` int(11) NOT NULL DEFAULT 0,
  `ID_sindaco` int(11) NOT NULL,
  `descrizione` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `liste`
--

INSERT INTO `liste` (`ID`, `titolo`, `numPreferenze`, `ID_sindaco`, `descrizione`) VALUES
(1, 'Diana per la Città', 4, 1, '\"Diana per la Città\" è una lista civica che rappresenta l’impegno diretto e personale del candidato Diana, già noto per la sua attività sul territorio in ambito sociale e amministrativo. Il programma è costruito attorno all’idea di una città più vicina ai cittadini, dove le scelte vengano prese in base alle reali esigenze della comunità. Tra le priorità figurano la riqualificazione dei quartieri periferici, il rilancio delle piccole attività commerciali locali, l’ottimizzazione dei trasporti pubblici e l’introduzione di strumenti di partecipazione attiva, come bilanci partecipativi e assemblee di quartiere. Particolare attenzione è riservata alle politiche per le famiglie, agli anziani e alla trasparenza nell’amministrazione pubblica.'),
(2, 'Alleanza Democratica', 3, 1, '\"Alleanza Democratica\" è un progetto politico che nasce dall’unione di diverse anime progressiste, socialdemocratiche e ambientaliste, unite dal desiderio comune di costruire una città più equa, giusta e moderna. Il programma prevede un piano ambizioso di investimenti nella scuola, nella sanità territoriale, nella cultura e nell’inclusione sociale. Tra i temi centrali vi sono l’equità fiscale, l’accesso alla casa, il contrasto alla povertà educativa e il sostegno alle imprese sociali. Il progetto si fonda su un’idea di città sostenibile e accogliente, dove la crescita economica vada di pari passo con i diritti civili e la tutela dell’ambiente.'),
(3, 'Futuro Verde', 1, 1, '\"Futuro Verde\" è una lista interamente dedicata alla sostenibilità e alla difesa dell’ambiente urbano e naturale. Si propone di trasformare la città in un esempio concreto di transizione ecologica, attraverso misure come la riduzione drastica del traffico privato, il potenziamento del trasporto pubblico elettrico, la creazione di nuove aree verdi, orti urbani e piste ciclabili. Propone anche incentivi per l\'efficienza energetica negli edifici, una gestione più trasparente dei rifiuti e il contrasto al consumo di suolo. L’obiettivo è rendere la città un luogo sano, resiliente e vivibile per le generazioni future, in linea con gli obiettivi dell’Agenda 2030.'),
(4, 'Rossi Sindaco', 1, 2, 'Questa lista personale sostiene il candidato Rossi, figura di esperienza e concretezza, con un passato da amministratore locale. Il programma mette al centro la sicurezza, la legalità e il decoro urbano come condizioni essenziali per una città funzionante. Rossi propone la riorganizzazione dei servizi comunali per aumentare efficienza e tempi di risposta, il potenziamento della videosorveglianza e una presenza più visibile della polizia municipale. Promette anche un piano straordinario per il rilancio economico e l’attrazione di nuovi investimenti, accompagnato da una forte digitalizzazione della macchina comunale.'),
(5, 'Patto per il Cambiamento', 0, 2, 'Il \"Patto per il Cambiamento\" è una lista trasversale, nata per costruire un\'alternativa concreta alla politica tradizionale, spesso percepita come distante e autoreferenziale. Il patto prevede riforme strutturali nella gestione del Comune: semplificazione burocratica, riorganizzazione del personale, innovazione nei servizi pubblici e apertura dei dati (open data). Sostiene l’utilizzo delle nuove tecnologie per avvicinare il Comune ai cittadini e favorire la partecipazione. Al centro del programma ci sono anche la sostenibilità economica del bilancio comunale e una politica urbanistica che metta fine alle speculazioni e favorisca una città a misura d’uomo.'),
(6, 'Città Viva', 0, 2, '\"Città Viva\" è una lista civica che si propone di restituire vitalità e qualità alla vita urbana. Il suo programma punta su politiche culturali e sociali capaci di rigenerare i quartieri e rafforzare il senso di appartenenza della comunità. Tra le proposte: la riqualificazione di spazi pubblici abbandonati da trasformare in centri di aggregazione culturale, eventi gratuiti per tutte le età, più attenzione all’arredo urbano e una rete di servizi diffusi per il tempo libero. Si promuovono anche sport e benessere come strumenti di inclusione e coesione sociale.'),
(7, 'Giovani in Comune', 0, 2, 'Questa lista è composta da una nuova generazione di cittadini, studenti, precari, giovani imprenditori e attivisti che chiedono di essere protagonisti della politica locale. Il programma prevede la creazione di spazi pubblici per il co-working, l’ampliamento delle residenze universitarie, fondi per start-up giovanili e laboratori culturali e digitali. \"Giovani in Comune\" vuole una città più inclusiva, più digitale e più accessibile, con particolare attenzione ai diritti civili, alla parità e all’innovazione tecnologica come motore di sviluppo.'),
(8, 'Bianchi 2025', 0, 3, 'Lista nata attorno alla visione strategica del candidato Bianchi, che propone un piano di governo strutturato fino al 2025. Si punta su quattro assi principali: innovazione urbana, sostenibilità, coesione sociale e competitività economica. Il programma prevede un forte impulso alla digitalizzazione dei servizi comunali, incentivi all’occupazione giovanile, un piano edilizio basato su edilizia sociale e rigenerazione urbana e un grande piano culturale per attrarre turismo e investimenti. Il tutto con una visione trasparente e di lungo periodo, fondata su competenza e pianificazione.'),
(9, 'Unione Popolare', 1, 3, '\"Unione Popolare\" è una lista di sinistra che mette al centro i diritti delle persone, la giustizia sociale e la difesa del bene comune. Si oppone alle privatizzazioni e sostiene il rafforzamento dei servizi pubblici, in particolare in ambito sanitario, educativo e abitativo. Il programma prevede anche un piano straordinario per l’edilizia popolare, politiche per il lavoro equo e una fiscalità progressiva per combattere le disuguaglianze. L’obiettivo è una città solidale, dove nessuno resti indietro e dove le istituzioni siano davvero al servizio dei cittadini.'),
(10, 'Sicurezza e Lavoro', 0, 3, 'Lista civica pragmatica che basa il proprio programma su due priorità imprescindibili: sicurezza urbana e opportunità lavorative. Propone un aumento degli organici della polizia locale, una migliore illuminazione pubblica, una manutenzione costante degli spazi cittadini e campagne di sensibilizzazione contro il degrado. Sul fronte economico, sostiene politiche attive per l’occupazione, incentivi per l’artigianato e il commercio, sostegno alle aziende in difficoltà e una formazione continua legata alle reali richieste del mercato.');

-- --------------------------------------------------------

--
-- Struttura della tabella `seggi`
--

CREATE TABLE `seggi` (
  `ID` int(11) NOT NULL,
  `comune` varchar(50) NOT NULL,
  `via` varchar(100) NOT NULL,
  `civico` smallint(6) NOT NULL,
  `numAbitanti` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `seggi`
--

INSERT INTO `seggi` (`ID`, `comune`, `via`, `civico`, `numAbitanti`) VALUES
(1, 'Milano', 'Via Roma', 1, 1200),
(2, 'Milano', 'Via Milano', 2, 1100),
(3, 'Milano', 'Via Torino', 3, 1300),
(4, 'Milano', 'Via Venezia', 4, 900),
(5, 'Milano', 'Via Firenze', 5, 1000),
(6, 'Milano', 'Via Bologna', 6, 950),
(7, 'Milano', 'Via Napoli', 7, 1250),
(8, 'Milano', 'Via Genova', 8, 1400),
(9, 'Milano', 'Via Verona', 9, 1050),
(10, 'Milano', 'Via Catania', 10, 1150);

-- --------------------------------------------------------

--
-- Struttura della tabella `sindaci`
--

CREATE TABLE `sindaci` (
  `ID` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cognome` varchar(50) NOT NULL,
  `data_nascita` date NOT NULL,
  `CF` varchar(16) NOT NULL,
  `numPreferenze` int(11) NOT NULL DEFAULT 0,
  `ID_utente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `sindaci`
--

INSERT INTO `sindaci` (`ID`, `nome`, `cognome`, `data_nascita`, `CF`, `numPreferenze`, `ID_utente`) VALUES
(1, 'Daniele', 'Diana', '2001-07-19', 'DNIDNL01L19F592D', 24, NULL),
(2, 'Mario', 'Rossi', '1975-03-15', 'RSSMRA75C15H501A', 2, NULL),
(3, 'Laura', 'Bianchi', '1980-07-22', 'BNCLRA80L22H501B', 1, NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `utenti`
--

CREATE TABLE `utenti` (
  `ID` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `CF` varchar(16) NOT NULL,
  `userType` enum('Cittadino','Addetto','Candidato','Sindaco','Admin') NOT NULL DEFAULT 'Cittadino'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `utenti`
--

INSERT INTO `utenti` (`ID`, `email`, `pass`, `CF`, `userType`) VALUES
(3, 'prova02@email.com', '$2y$12$qWa7P.LnzoZ3fNn2zneiC.z0atSTgd4mzSlsxJ3CNPt6vl1vtdgXu', 'LBCBFN43O32G181E', 'Cittadino'),
(4, 'admin01@email.com', '$2y$12$WWAO5OMWIb9IuEUoyHSFrejBjKfsz1MPOfzKgiE8fzPrW2H/vsWcG', 'DNIDNL01L19F592D', 'Admin'),
(6, 'prova03@email.com', '$2y$12$FTNQzM9UWA/VuwhpSoI8TO/MSuhNTVZvRejQrbpGL.XcJhc.ZNm6i', 'WZKSBV86R37J940U', 'Cittadino'),
(7, 'prova04@email.com', '$2y$12$9azKRKjfxNzumKielhZoz.2134Kjl8yzweKqPD0ee0ndhdXts0vY.', 'ZCUDIH16Y15F594U', 'Cittadino'),
(8, 'prova05@email.com', '$2y$12$FGfWEQf0dbp93taDuanT7./GTGvLAMBiwoZa0gBhYPxFqkKprsUAy', 'OGYRDO93X10K341V', 'Cittadino'),
(9, 'prova06@email.com', '$2y$12$A84udKPRJ.kQebXc4P2pv.LJBf3iwiciaPFvZqEVcly85iRG1m6OK', 'DYROSJ41O92R832X', 'Cittadino'),
(10, 'prova07@email.com', '$2y$12$aLYc/qyIe3oEXXfzTA21WOyBujQykTq/vOk.dL2LzlIWrITWmfc/u', 'CANCOD00A00A000A', 'Candidato'),
(12, 'sindaco01@email.com', '$2y$12$wETHNS055wttMrviGwaMzu7mLcF0IFIzeePofCfkeKHLSPCRfL3H.', 'RSSMRA75C15H501A', 'Sindaco'),
(13, 'addetto01@email.com', '$2y$12$MdaAH4oV3Ct6Kotzfy/vl.Fmsrn780Q0WNOEtE4j8hL5vsj4oPPZS', 'CODADD00A00A000A', 'Addetto'),
(14, 'candidato01@email.com', '$2y$12$IAX/7lYIFt9g5RyutYniDOktEwIPAcXE39ko8fsAOas03C4vpiMMi', 'CANCOD00A00A000B', 'Candidato');

--
-- Trigger `utenti`
--
DELIMITER $$
CREATE TRIGGER `associazioneUtente` AFTER INSERT ON `utenti` FOR EACH ROW BEGIN
    
    CALL associaUtente(NEW.ID, NEW.userType, NEW.CF);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `voti`
--

CREATE TABLE `voti` (
  `ID` int(11) NOT NULL,
  `ID_seggio` int(11) NOT NULL,
  `ID_sindaco` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `voti`
--

INSERT INTO `voti` (`ID`, `ID_seggio`, `ID_sindaco`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 1, 1),
(5, 1, 1),
(6, 1, 1),
(7, 1, 1),
(8, 1, 1),
(9, 1, 1),
(10, 1, 1),
(11, 1, 1),
(12, 1, 2),
(13, 1, 1),
(14, 1, 1),
(15, 1, 1),
(16, 1, 1),
(17, 1, 1),
(18, 1, 1),
(19, 1, 1),
(20, 1, 1),
(21, 1, 1),
(22, 1, 1),
(23, 1, 1),
(24, 1, 1),
(25, 1, 1),
(26, 8, 1),
(27, 8, 1);

--
-- Trigger `voti`
--
DELIMITER $$
CREATE TRIGGER `votazioneSindaco` AFTER INSERT ON `voti` FOR EACH ROW BEGIN

    CALL incrementaPreferenzeSindaco(NEW.ID_sindaco);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `voticandidato`
--

CREATE TABLE `voticandidato` (
  `ID_voto` int(11) NOT NULL,
  `ID_candidato` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `voticandidato`
--

INSERT INTO `voticandidato` (`ID_voto`, `ID_candidato`) VALUES
(2, 14),
(2, 16),
(3, 35),
(3, 36),
(3, 37),
(6, 5),
(6, 6),
(6, 7),
(7, 2),
(8, 5),
(8, 6),
(8, 7),
(15, 1),
(17, 9),
(17, 10),
(25, 4),
(25, 5),
(25, 6),
(25, 7),
(26, 2),
(26, 3),
(27, 2),
(27, 3);

--
-- Trigger `voticandidato`
--
DELIMITER $$
CREATE TRIGGER `votazioneCandidato` AFTER INSERT ON `voticandidato` FOR EACH ROW BEGIN
    
    CALL incrementaPreferenzeCandidato(NEW.ID_candidato);
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `votilista`
--

CREATE TABLE `votilista` (
  `ID_voto` int(11) NOT NULL,
  `ID_lista` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `votilista`
--

INSERT INTO `votilista` (`ID_voto`, `ID_lista`) VALUES
(7, 1),
(15, 1),
(26, 1),
(27, 1),
(6, 2),
(8, 2),
(25, 2),
(17, 3),
(2, 4),
(3, 9);

--
-- Trigger `votilista`
--
DELIMITER $$
CREATE TRIGGER `votazioneLista` AFTER INSERT ON `votilista` FOR EACH ROW BEGIN
    
    CALL incrementaPreferenzeLista(NEW.ID_lista);

END
$$
DELIMITER ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `addetti`
--
ALTER TABLE `addetti`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `CF` (`CF`),
  ADD UNIQUE KEY `ID_utente` (`ID_utente`),
  ADD KEY `ID_seggio` (`ID_seggio`);

--
-- Indici per le tabelle `candidati`
--
ALTER TABLE `candidati`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `CF` (`CF`),
  ADD UNIQUE KEY `ID_lista` (`ID_lista`,`numCandidato`),
  ADD UNIQUE KEY `ID_utente` (`ID_utente`);

--
-- Indici per le tabelle `cittadini`
--
ALTER TABLE `cittadini`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `CF` (`CF`),
  ADD UNIQUE KEY `ID_utente` (`ID_utente`),
  ADD KEY `ID_voto` (`ID_voto`);

--
-- Indici per le tabelle `liste`
--
ALTER TABLE `liste`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `titolo` (`titolo`),
  ADD KEY `ID_sindaco` (`ID_sindaco`);

--
-- Indici per le tabelle `seggi`
--
ALTER TABLE `seggi`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `comune` (`comune`,`via`,`civico`);

--
-- Indici per le tabelle `sindaci`
--
ALTER TABLE `sindaci`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `CF` (`CF`),
  ADD UNIQUE KEY `ID_utente` (`ID_utente`);

--
-- Indici per le tabelle `utenti`
--
ALTER TABLE `utenti`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `CF` (`CF`);

--
-- Indici per le tabelle `voti`
--
ALTER TABLE `voti`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ID_seggio` (`ID_seggio`),
  ADD KEY `ID_sindaco` (`ID_sindaco`);

--
-- Indici per le tabelle `voticandidato`
--
ALTER TABLE `voticandidato`
  ADD PRIMARY KEY (`ID_voto`,`ID_candidato`),
  ADD KEY `ID_candidato` (`ID_candidato`);

--
-- Indici per le tabelle `votilista`
--
ALTER TABLE `votilista`
  ADD PRIMARY KEY (`ID_voto`),
  ADD KEY `ID_lista` (`ID_lista`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `addetti`
--
ALTER TABLE `addetti`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `candidati`
--
ALTER TABLE `candidati`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `cittadini`
--
ALTER TABLE `cittadini`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=202;

--
-- AUTO_INCREMENT per la tabella `liste`
--
ALTER TABLE `liste`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT per la tabella `seggi`
--
ALTER TABLE `seggi`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT per la tabella `sindaci`
--
ALTER TABLE `sindaci`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT per la tabella `utenti`
--
ALTER TABLE `utenti`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT per la tabella `voti`
--
ALTER TABLE `voti`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `addetti`
--
ALTER TABLE `addetti`
  ADD CONSTRAINT `addetti_ibfk_1` FOREIGN KEY (`ID_seggio`) REFERENCES `seggi` (`ID`),
  ADD CONSTRAINT `addetti_ibfk_2` FOREIGN KEY (`ID_utente`) REFERENCES `utenti` (`ID`);

--
-- Limiti per la tabella `candidati`
--
ALTER TABLE `candidati`
  ADD CONSTRAINT `candidati_ibfk_1` FOREIGN KEY (`ID_lista`) REFERENCES `liste` (`ID`),
  ADD CONSTRAINT `candidati_ibfk_2` FOREIGN KEY (`ID_utente`) REFERENCES `utenti` (`ID`);

--
-- Limiti per la tabella `cittadini`
--
ALTER TABLE `cittadini`
  ADD CONSTRAINT `cittadini_ibfk_1` FOREIGN KEY (`ID_voto`) REFERENCES `voti` (`ID`),
  ADD CONSTRAINT `cittadini_ibfk_2` FOREIGN KEY (`ID_utente`) REFERENCES `utenti` (`ID`);

--
-- Limiti per la tabella `liste`
--
ALTER TABLE `liste`
  ADD CONSTRAINT `liste_ibfk_1` FOREIGN KEY (`ID_sindaco`) REFERENCES `sindaci` (`ID`);

--
-- Limiti per la tabella `sindaci`
--
ALTER TABLE `sindaci`
  ADD CONSTRAINT `sindaci_ibfk_1` FOREIGN KEY (`ID_utente`) REFERENCES `utenti` (`ID`);

--
-- Limiti per la tabella `voti`
--
ALTER TABLE `voti`
  ADD CONSTRAINT `voti_ibfk_1` FOREIGN KEY (`ID_seggio`) REFERENCES `seggi` (`ID`),
  ADD CONSTRAINT `voti_ibfk_2` FOREIGN KEY (`ID_sindaco`) REFERENCES `sindaci` (`ID`);

--
-- Limiti per la tabella `voticandidato`
--
ALTER TABLE `voticandidato`
  ADD CONSTRAINT `voticandidato_ibfk_1` FOREIGN KEY (`ID_voto`) REFERENCES `voti` (`ID`),
  ADD CONSTRAINT `voticandidato_ibfk_2` FOREIGN KEY (`ID_candidato`) REFERENCES `candidati` (`ID`);

--
-- Limiti per la tabella `votilista`
--
ALTER TABLE `votilista`
  ADD CONSTRAINT `votilista_ibfk_1` FOREIGN KEY (`ID_voto`) REFERENCES `voti` (`ID`),
  ADD CONSTRAINT `votilista_ibfk_2` FOREIGN KEY (`ID_lista`) REFERENCES `liste` (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
