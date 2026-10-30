# HappyWife — Windows setup (from the VM export)

This is a minshop store (Cloudflare Workers + D1 + R2), exported from the
VM. Nothing in this export contains a real secret: `.dev.vars` was NOT
copied, and `node_modules` was NOT copied — both are regenerated below.

## 1. Put it in place

Unzip so the store lives at:

```
C:\002-workspace\happywife-store\
```

Keep the HappyWife docs repo separate, as before:

```
C:\002-workspace\HappyWife\        (docs)
C:\002-workspace\happywife-store\  (this code)
```

## 2. Install Node 22 (required)

minshop's house rules require Node 22. Node 24 is not supported here.

- Install Node 22 LTS from nodejs.org, or via nvm-windows (`nvm install 22`
  then `nvm use 22`).
- Check it in PowerShell:

```powershell
node --version   # should be v22.x
npm --version
```

## 3. Install, disable telemetry, provision

In PowerShell, from `C:\002-workspace\happywife-store`:

```powershell
npm install
npx astro telemetry disable
npm run provision:local -- --seed
```

- `provision:local` generates fresh local secrets into `.dev.vars`
  (gitignored, local only — never commit it, never paste it in chat,
  never screenshot it).
- `--seed` adds the Sample Tee and Sample Mug demo products.
  Remove them in Admin before any real launch.
- This step builds the store and applies all D1 migrations locally.

## 4. Re-apply HappyWife branding (optional, but recommended)

Provisioning starts from a blank store named "My Shop". This export
includes `hw-brand.sql`, which sets the store name and timezone and adds
the pilot test product — the same branding that was verified in the VM:

```powershell
npx wrangler d1 execute DB --local --file=hw-brand.sql
```

That sets:

- `store_name` = HappyWife
- `time_zone` = Asia/Taipei
- Product: HappyWife Smart Toilet Seat
  ("He flips. She smiles. — The smart toilet seat that keeps the peace."),
  slug `happywife-smart-toilet-seat`, **$1.00 TEST price only**,
  stock 10, packed weight unknown (NULL, not guessed).

## 5. Run it and set the admin password (you, not Muse)

```powershell
npm run preview
```

Then open in your own browser:

```
http://localhost:8787/admin/setup
```

The setup page should already show store name "HappyWife".
Enter **your own admin password** (at least 8 characters) and click
Finish setup. That password is stored hashed in the local database —
Muse must not choose it, and you should not send it in chat.

After setup, the storefront at `http://localhost:8787/` stops redirecting
to `/admin/setup`.

## 6. What to check next

- Storefront loads and shows the HappyWife product.
- Demo checkout works (Demo is the only payment method until Stripe
  test mode is added — it never charges).
- **Taiwan shipping is NOT yet configured.** minshop's default zones are
  US-only, so a Taiwan checkout will fail with
  "This store does not ship to TW" until a TW zone is added in
  Admin → Shipping.
- Real price and packed weight are still undecided: $1.00 is a test
  price, and weight is unknown. Set both in Admin before any real
  shipping/launch.

## 7. Stop / restart

- Stop the preview server with Ctrl+C in PowerShell.
- Restart any time with `npm run preview` (no need to re-provision).
- Reset local data completely with `npm run destroy:local`, then
  re-run step 3 (and step 4 if you want the branding back).

## Never do

- Never run a deploy/publish command unless you explicitly decide to.
- Never put real Stripe/Lightning keys in the repo, chat, or screenshots.
  Provider keys go in Admin → Settings, in test mode first.
