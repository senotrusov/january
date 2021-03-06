
--  Copyright 2010-2012 Stanislav Senotrusov <stan@senotrusov.com>
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.

BEGIN;

INSERT INTO users(id)
     VALUES (1);


INSERT INTO boards(id, slug)
     VALUES (1, 'n');


INSERT INTO documents(id, board_id, author_id)
     VALUES (1, 1, 1);


INSERT INTO author_identities(id, user_id, document_id, identity)
     VALUES (1, 1, 1, 1);
     
UPDATE documents SET author_identity_counter = 1, author_identity_id = 1 WHERE id = 1;


INSERT INTO sections(id, document_id, author_identity_id, title)
     VALUES (1, 1, 1, 'Comments');


INSERT INTO paragraphs(id, section_id, author_identity_id, line_id, message)
     VALUES (1, 1, 1, 1, 'Hello');

COMMIT;
