ALTER TABLE Posts DROP INDEX idx_posts_message_txt;
ALTER TABLE Posts ADD FULLTEXT INDEX idx_posts_message_txt (`Message`) WITH PARSER ngram COMMENT 'ngram reindex';
