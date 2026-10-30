INSERT INTO settings (key, value) VALUES ('store_name', 'HappyWife')
ON CONFLICT(key) DO UPDATE SET value = excluded.value;
INSERT INTO settings (key, value) VALUES ('time_zone', 'Asia/Taipei')
ON CONFLICT(key) DO UPDATE SET value = excluded.value;
INSERT INTO products (name, slug, description, price_cents, currency, stock, active, weight_grams, requires_shipping)
SELECT 'HappyWife Smart Toilet Seat', 'happywife-smart-toilet-seat', 'He flips. She smiles. — The smart toilet seat that keeps the peace. [PILOT TEST PRODUCT — $1.00 is a test price only, not a commercial price. Packed weight not yet set.]', 100, 'usd', 10, 1, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'HappyWife Smart Toilet Seat');
UPDATE products SET public_id = 'prod_' || lower(substr(hex(randomblob(10)),1,10)) WHERE name = 'HappyWife Smart Toilet Seat' AND public_id IS NULL;
