# In-app fee payments (CludCampus)

## Current state (v1.1.3)
- Fees screen has **Pay now** per due fee and **Pay total**.
- If the app is built with `--dart-define=RAZORPAY_KEY_ID=rzp_test_xxx`, the real Razorpay checkout (test mode) opens.
- Without a key, a clearly labelled **Test payment** sheet simulates UPI / Card / Netbanking with Success / Failure buttons.
- Paid status and payment history live in Riverpod state only (mock data, reset on app restart). The app trusts the client-side success callback — **not acceptable for production**.

## What a real backend needs
1. **Razorpay account in the college's name** — the money settles to the college, so the college must complete Razorpay KYC (PAN, GST/registration, bank account, authorised signatory). CludCampus should never hold student funds. Fees ~2% per transaction (UPI often lower), no annual fee.
2. **Server creates orders** — `POST /fees/{id}/order` (authenticated student). The server looks up the real due amount from the DB (never trust the amount from the app) and calls Razorpay `POST /v1/orders` with `amount` (paise), `currency: INR`, `receipt: <feeId>`, `notes: {studentId, feeIds}`. Return `order_id` + public `key_id` to the app; the app passes `order_id` to checkout. The **key secret stays on the server only**.
3. **Verify the signature** — after checkout the app sends `razorpay_order_id`, `razorpay_payment_id`, `razorpay_signature` to `POST /payments/verify`. Server computes `HMAC_SHA256(order_id + "|" + payment_id, key_secret)` and compares (constant-time). Only then mark the fee paid and issue a receipt number.
4. **Webhook** — configure `https://api.<domain>/razorpay/webhook` for `payment.captured`, `payment.failed`, `order.paid`, `refund.processed`. Verify the `X-Razorpay-Signature` header with the webhook secret over the raw body. This is the source of truth if the app is killed mid-payment. Make handlers idempotent (store `payment_id` uniquely).
5. **Data model** — `fees(id, student_id, title, amount, due_date, status)`, `payments(id, razorpay_order_id, razorpay_payment_id UNIQUE, student_id, amount, method, status, created_at, raw_json)`, `payment_fees(payment_id, fee_id)`.
6. **Receipts & admin** — server-generated receipt numbers/PDF, admin dashboard for reconciliation and refunds (Razorpay Refunds API), daily settlement report.
7. **Hosting** — Firebase Cloud Functions or Supabase Edge Functions are enough for ~300 students.

## Going live checklist
- College KYC approved, live keys generated (`rzp_live_...`).
- Order + verify endpoints and webhook deployed, secrets in server env.
- App updated to request `order_id` from the server and send verification payload.
- Test with real ₹1 payments, then refund.
