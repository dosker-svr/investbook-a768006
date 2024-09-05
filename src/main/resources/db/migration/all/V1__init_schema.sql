/*
 * InvestBook
 * Copyright (C) 2020  Vitalii Ananev <spacious-team@ya.ru>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия сервера:               10.4.12-MariaDB - mariadb.org binary distribution
-- Операционная система:         Win64
-- HeidiSQL Версия:              10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Дамп структуры базы данных portfolio
-- CREATE DATABASE IF NOT EXISTS `portfolio` /*!40100 DEFAULT CHARACTER SET utf8 */;
-- USE `portfolio`;

-- Дамп структуры для таблица portfolio.cash_flow_type
CREATE TABLE IF NOT EXISTS `cash_flow_type` (
  `id` int(10) unsigned NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Тип движения средств';

-- Дамп данных таблицы portfolio.cash_flow_type: ~13 rows (приблизительно)
/*!40000 ALTER TABLE `cash_flow_type` DISABLE KEYS */;
INSERT IGNORE INTO `cash_flow_type` (`id`, `name`) VALUES
(0, 'Пополнение и снятие'),
(1, 'Чистая стоимость сделки (без НКД)'),
(2, 'НКД на день сделки'),
(3, 'Комиссия'),
(4, 'Амортизация облигации'),
(5, 'Погашение облигации'),
(6, 'Купонный доход (до удержания налога)'),
(7, 'Дивиденды (до удержания налога)'),
(8, 'Вариационная маржа'),
(9, 'Гарантийное обеспечение'),
(10, 'Налог уплаченный (с купона, с дивидендов)'),
(11, 'Прогнозируемый налог'),
(12, 'Стоимость сделки с деривативом, валюта'),
(13, 'Стоимость сделки с деривативом, пункты');
/*!40000 ALTER TABLE `cash_flow_type` ENABLE KEYS */;

-- Дамп структуры для таблица portfolio.portfolio
CREATE TABLE IF NOT EXISTS `portfolio` (
  `id` varchar(32) NOT NULL COMMENT 'Портфель (номер брокерского счета)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Таблица пользователей';

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица portfolio.event_cash_flow
CREATE TABLE IF NOT EXISTS `event_cash_flow` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `portfolio` varchar(32) NOT NULL COMMENT 'Портфель (номер брокерского счета)',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `type` int(10) unsigned NOT NULL COMMENT 'Причина движения',
  `value` decimal(12,2) NOT NULL COMMENT 'Размер',
  `currency` char(3) NOT NULL DEFAULT 'RUR' COMMENT 'Код валюты',
  `description` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `event_cash_flow_timestamp_type_value_currency_portfolio_uniq_ix` (`timestamp`,`type`,`value`,`currency`,`portfolio`),
  KEY `event_cash_flow_type_ix` (`type`),
  KEY `event_cash_flow_portfolio_ix` (`portfolio`),
  CONSTRAINT `event_cash_flow_portfolio_fkey` FOREIGN KEY (`portfolio`) REFERENCES `portfolio` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `event_cash_flow_type_fkey` FOREIGN KEY (`type`) REFERENCES `cash_flow_type` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Движение денежных средств, не связанное с ЦБ';

-- Дамп структуры для таблица portfolio.issuer
CREATE TABLE IF NOT EXISTS `issuer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `taxpayer_id` varchar(16) DEFAULT NULL COMMENT 'Идентификатор налогоплательщика (Россия - ИНН, США - EIN и т.д.)',
  `name` varchar(100) NOT NULL COMMENT 'Наименование',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Эмитенты';

-- Дамп структуры для таблица portfolio.portfolio_property
CREATE TABLE IF NOT EXISTS `portfolio_property` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `portfolio` varchar(32) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `property` varchar(64) NOT NULL,
  `value` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `portfolio_property_portfolio_timestamp_property_uniq_ix` (`portfolio`,`timestamp`,`property`),
  KEY `portfolio_property_portfolio_ix` (`portfolio`),
  CONSTRAINT `portfolio_property_portfolio_fkey` FOREIGN KEY (`portfolio`) REFERENCES `portfolio` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Свойства портфеля';

-- Дамп структуры для таблица portfolio.security
CREATE TABLE IF NOT EXISTS `security` (
  `id` varchar(64) NOT NULL COMMENT 'Идентификатор ценной бумаги: ISIN - для акций, облигаций; наименование контракта - для срочного и валютного рынка',
  `isin` char(12) DEFAULT NULL COMMENT 'ISIN',
  `ticker` varchar(16) DEFAULT NULL COMMENT 'Тикер',
  `name` varchar(100) DEFAULT NULL COMMENT 'Полное наименование ценной бумаги или контракта',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Общая информация по ценным бумагам';

-- Дамп структуры для таблица portfolio.security_event_cash_flow
CREATE TABLE IF NOT EXISTS `security_event_cash_flow` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `portfolio` varchar(32) NOT NULL COMMENT 'Портфель (номер брокерского счета)',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `security` varchar(64) NOT NULL COMMENT 'Инструмент, по которому произошло событие',
  `count` int(1) unsigned NOT NULL COMMENT 'Количество ЦБ, по которым произошло событие (для деривативов - опциональное поле, можно заполнять 0)',
  `type` int(10) unsigned NOT NULL COMMENT 'Причина движения',
  `value` decimal(12,2) NOT NULL COMMENT 'Размер',
  `currency` char(3) NOT NULL DEFAULT 'RUR' COMMENT 'Код валюты',
  PRIMARY KEY (`id`),
  UNIQUE KEY `security_event_cash_flow_timestamp_security_type_portfolio_uniq` (`timestamp`,`security`,`type`,`portfolio`),
  KEY `security_event_cash_flow_type_ix` (`type`),
  KEY `security_event_cash_flow_security_ix` (`security`),
  KEY `security_event_cash_flow_portfolio_ix` (`portfolio`),
  CONSTRAINT `security_event_cash_flow_security_fkey` FOREIGN KEY (`security`) REFERENCES `security` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `security_event_cash_flow_portfolio_fkey` FOREIGN KEY (`portfolio`) REFERENCES `portfolio` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `security_event_cash_flow_type_fkey` FOREIGN KEY (`type`) REFERENCES `cash_flow_type` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Движение денежных средств, связанное с ЦБ';

-- Дамп структуры для таблица portfolio.transaction
CREATE TABLE IF NOT EXISTS `transaction` (
  `id` varchar(32) NOT NULL COMMENT 'Номер сделки в системе учета брокера',
  `portfolio` varchar(32) NOT NULL COMMENT 'Портфель (номер брокерского счета)',
  `security` varchar(64) NOT NULL COMMENT 'Инструмент (акция, облигация, контракт)',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Фактическое время исполнения сделки',
  `count` int(1) NOT NULL COMMENT 'Покупка (+), продажа (-)',
  PRIMARY KEY (`id`,`portfolio`),
  KEY `transaction_security_ix` (`security`),
  KEY `transaction_portfolio_ix` (`portfolio`),
  CONSTRAINT `transaction_security_fkey` FOREIGN KEY (`security`) REFERENCES `security` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `transaction_portfolio_fkey` FOREIGN KEY (`portfolio`) REFERENCES `portfolio` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Сделки';

-- Дамп структуры для таблица portfolio.transaction_cash_flow
CREATE TABLE IF NOT EXISTS `transaction_cash_flow` (
  `transaction_id` varchar(32) NOT NULL COMMENT 'ID транзакции',
  `portfolio` varchar(32) NOT NULL COMMENT 'ID портфеля',
  `type` int(10) unsigned NOT NULL COMMENT 'Причина движения',
  `value` decimal(12,2) NOT NULL COMMENT 'Размер',
  `currency` char(3) NOT NULL DEFAULT 'RUR' COMMENT 'Код валюты',
  PRIMARY KEY (`transaction_id`,`portfolio`,`type`),
  KEY `transaction_cash_flow_type_ix` (`type`),
  KEY `transaction_cash_flow_transaction_id_ix` (`transaction_id`),
  KEY `transaction_cash_flow_portfolio_ix` (`portfolio`),
  CONSTRAINT `transaction_cash_flow_portfolio_fkey` FOREIGN KEY (`portfolio`) REFERENCES `portfolio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `transaction_cash_flow_transaction_id_fkey` FOREIGN KEY (`transaction_id`) REFERENCES `transaction` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `transaction_cash_flow_type_fkey` FOREIGN KEY (`type`) REFERENCES `cash_flow_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Движение денежных средств';

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
