/*
 * InvestBook
 * Copyright (C) 2021  Vitalii Ananev <an-vitek@ya.ru>
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

ALTER TABLE `security_description`
    DROP FOREIGN KEY `security_description_issuer_fkey`;
ALTER TABLE `security_description`
    ADD CONSTRAINT `security_description_issuer_fkey` FOREIGN KEY (`issuer`)
        REFERENCES `issuer` (`id`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `security_description`
	DROP FOREIGN KEY `security_description_security_fkey`;
ALTER TABLE `security_description`
	ADD CONSTRAINT `security_description_security_fkey` FOREIGN KEY (`security`)
        REFERENCES `security` (`id`) ON UPDATE CASCADE ON DELETE CASCADE;