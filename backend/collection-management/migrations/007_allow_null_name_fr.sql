-- Allow NULL values for name_fr (some cards have no French translation)
ALTER TABLE cards ALTER COLUMN name_fr DROP NOT NULL;
