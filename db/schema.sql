
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


CREATE TABLE sites (
  id     bigserial PRIMARY KEY,
  domain text
  );



CREATE TABLE documents (
  id             bigserial PRIMARY KEY,
  attrs          hstore,
  overrides      hstore,
  
  prototype_id   bigint, -- no FK and index to minimize unnecessary indexes 
  line_id        bigint references documents(id),
  
  sections_order bigint[],

  site_id        bigint NOT NULL references sites(id)
);

CREATE INDEX documents_line_id_idx ON documents USING btree (line_id); 
CREATE INDEX documents_site_id_idx ON documents USING btree (site_id); 

CREATE INDEX documents_attrs_idx   ON documents USING gin (attrs); 



CREATE TABLE sections (
  id               bigserial PRIMARY KEY,
  attrs            hstore,
  overrides        hstore,
  
  prototype_id     bigint, -- no FK and index to minimize unnecessary indexes
  line_id          bigint references sections(id),

  paragraphs_order bigint[],

  document_id      bigint NOT NULL references documents(id),
  site_id          bigint NOT NULL references sites(id)
);

CREATE INDEX sections_line_id_idx     ON sections USING btree (line_id); 
CREATE INDEX sections_document_id_idx ON sections USING btree (document_id); 
CREATE INDEX sections_site_id_idx     ON sections USING btree (site_id); 

CREATE INDEX sections_attrs_idx       ON sections USING gin (attrs); 


CREATE TABLE paragraphs (
  id           bigserial PRIMARY KEY,
  attrs        hstore,
  overrides    hstore,
  
  prototype_id bigint, -- no FK and index to minimize unnecessary indexes
  line_id      bigint references paragraphs(id),
  
  parent_id    bigint, -- no FK and index to minimize unnecessary indexes
  childs_order bigint[],
  
  section_id   bigint NOT NULL references sections(id),
  site_id      bigint NOT NULL references sites(id)
);

CREATE INDEX paragraphs_line_id_idx    ON paragraphs USING btree (line_id); 
CREATE INDEX paragraphs_section_id_idx ON paragraphs USING btree (section_id); 
CREATE INDEX paragraphs_site_id_idx    ON paragraphs USING btree (site_id);

CREATE INDEX paragraphs_attrs_idx      ON paragraphs USING gin (attrs); 

