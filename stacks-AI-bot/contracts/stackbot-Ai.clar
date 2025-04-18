;; Stacks AI Bot - AI-powered Trading Contract
;; This contract implements a platform for AI-driven trading on the Stacks blockchain

;; Error codes
(define-constant ERR_UNAUTHORIZED u1)
(define-constant ERR_INSUFFICIENT_BALANCE u2)
(define-constant ERR_INVALID_AMOUNT u3)
(define-constant ERR_STRATEGY_EXISTS u4)
(define-constant ERR_STRATEGY_NOT_FOUND u5)
(define-constant ERR_MARKET_CLOSED u6)
(define-constant ERR_INVALID_TOKEN u7)
(define-constant ERR_INSUFFICIENT_FUNDS u8)
(define-constant ERR_TRADING_DISABLED u9)

;; Data variables
(define-data-var contract-owner principal tx-sender)
(define-data-var trading-enabled bool true)
(define-data-var platform-fee uint u5) ;; 0.5% fee (represented as 5 basis points)
(define-data-var fee-address principal tx-sender)
(define-data-var min-deposit uint u1000000) ;; Minimum deposit in microSTX (1 STX)

;; Maps
(define-map user-balances principal uint)
(define-map user-strategies 
  { user: principal, strategy-id: uint } 
  {
    name: (string-ascii 64),
    risk-level: uint,
    active: bool,
    created-at: uint,
    last-updated: uint
  }
)