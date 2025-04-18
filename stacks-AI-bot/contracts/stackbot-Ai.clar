(define-map strategy-performance 
  { strategy-id: uint } 
  {
    roi: int,
    trades-executed: uint,
    win-rate: uint,
    last-trade-block: uint
  }
)

(define-map trading-pairs 
  { token-x: (string-ascii 32), token-y: (string-ascii 32) } 
  {
    enabled: bool,
    min-trade-amount: uint,
    max-trade-amount: uint,
    last-price: uint
  }
)

;; User balance management
(define-read-only (get-balance (user principal))
  (default-to u0 (map-get? user-balances user))
)

(define-public (deposit (amount uint))
  (begin
    (asserts! (>= amount (var-get min-deposit)) (err ERR_INVALID_AMOUNT))
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (map-set user-balances tx-sender 
      (+ (get-balance tx-sender) amount)
    )
    (ok amount)
  )
)

(define-public (withdraw (amount uint))
  (let (
    (current-balance (get-balance tx-sender))
  )
    (asserts! (>= current-balance amount) (err ERR_INSUFFICIENT_BALANCE))
    (map-set user-balances tx-sender (- current-balance amount))
    (as-contract (stx-transfer? amount (as-contract tx-sender) tx-sender))
    (ok amount)
  )
)

;; Strategy management
(define-read-only (get-next-strategy-id (user principal))
  (default-to u1 
    (map-get? strategy-performance { strategy-id: (+ u1 (get-user-strategy-count user)) })
  )
)

(define-read-only (get-user-strategy-count (user principal))
  ;; In a real contract, you'd implement logic to count strategies
  ;; This is a placeholder
  u0
)