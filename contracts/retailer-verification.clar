;; retailer-verification.clar
;; Simple contract for retailer verification

;; Data storage for admin
(define-data-var admin principal tx-sender)

;; Map of verified retailers
(define-map verified-retailers principal bool)

;; Register a retailer (anyone can register)
(define-public (register-retailer)
  (ok (map-insert verified-retailers tx-sender true))
)

;; Verify if a retailer is registered
(define-read-only (is-verified (retailer principal))
  (default-to false (map-get? verified-retailers retailer))
)

;; Remove a retailer (admin only)
(define-public (remove-retailer (retailer principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (map-delete verified-retailers retailer))
  )
)

;; Set a new admin (admin only)
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (var-set admin new-admin))
  )
)
