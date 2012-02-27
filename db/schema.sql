
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


CREATE TABLE users (
  id                     bigserial PRIMARY KEY,
  created_at             timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at             timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  email                  character varying(255),
  encrypted_password     character varying(255),
  
  reset_password_token   character varying(255),
  reset_password_sent_at timestamp with time zone,
  
  last_sign_in_at        timestamp with time zone,
  last_sign_in_ip        inet -- character varying(39)
);

CREATE UNIQUE INDEX users_email_idx ON users USING btree (email);



CREATE TABLE boards (
  id          bigserial PRIMARY KEY,
  created_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  slug        character varying(64) NOT NULL
);

CREATE UNIQUE INDEX boards_slug_idx ON boards USING btree (slug);



CREATE TABLE documents (
  id          bigserial PRIMARY KEY,
  created_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  board_id    bigint NOT NULL references boards(id),
  author_id   bigint NOT NULL references users(id),
  
  user_identity_counter integer NOT NULL default 0, -- gapless sequence: update w/lock set + 1 

  image        character varying(128),
  title        character varying(256),
  url          character varying(2048),
  message      character varying(1024)
);

CREATE INDEX documents_board_id_idx  ON documents USING btree (board_id); 
CREATE INDEX documents_author_id_idx ON documents USING btree (author_id); 



CREATE TABLE user_identities (
  id           bigserial PRIMARY KEY,
  user_id      bigint  NOT NULL references users(id),
  document_id  bigint  NOT NULL references documents(id),
  identity     integer NOT NULL 
);

CREATE INDEX user_identities_user_id_idx       ON user_identities USING btree (user_id);
CREATE UNIQUE INDEX user_identities_unique_idx ON user_identities USING btree (document_id, identity);



CREATE TABLE sections (
  id           bigserial PRIMARY KEY,
  created_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  document_id  bigint NOT NULL references documents(id),
  
  image        character varying(128),
  title        character varying(256) NOT NULL,
  
  is_public                       boolean NOT NULL DEFAULT true,
  is_writable_if_user_represented boolean NOT NULL DEFAULT false
);

CREATE INDEX sections_document_id_idx ON sections USING btree (document_id); 




CREATE TABLE paragraphs (
  id           bigserial PRIMARY KEY,
  created_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  section_id   bigint NOT NULL references sections(id),
  author_id    bigint NOT NULL references user_identities(id),
  line_id      bigint NOT NULL references paragraphs(id),
  
  image        character varying(128),
  title        character varying(256),
  url          character varying(2048),
  message      character varying(1024)
);

CREATE INDEX paragraphs_section_id_idx ON paragraphs USING btree (section_id);
CREATE INDEX paragraphs_author_id_idx  ON paragraphs USING btree (author_id);
CREATE INDEX paragraphs_line_id_idx    ON paragraphs USING btree (line_id);

