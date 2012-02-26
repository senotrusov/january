INSERT INTO sites(
            id, "domain")
    VALUES (1, 'localhost');

INSERT INTO documents(
            id, attrs, overrides, prototype_id, line_id, sections_order, 
            site_id)
    VALUES (1, 'a=>1, b=>2'::hstore, NULL, NULL, 1, NULL, 
            1);

INSERT INTO sections(
            id, attrs, overrides, prototype_id, line_id, paragraphs_order, 
            document_id, site_id)
    VALUES (1, 'a=>1, b=>2'::hstore, NULL, NULL, 1, NULL, 
            1, 1);

INSERT INTO paragraphs(
            id, attrs, overrides, prototype_id, line_id, parent_id, childs_order, 
            section_id, site_id)
    VALUES (1, 'a=>1, b=>2'::hstore, NULL, NULL, 1, NULL, NULL, 
            1, 1);

INSERT INTO paragraphs(
            id, attrs, overrides, prototype_id, line_id, parent_id, childs_order, 
            section_id, site_id)
    VALUES (2, 'b=>2'::hstore, '{"b"}', 1, 1, NULL, NULL, 
            1, 1);

