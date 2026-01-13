# MDP Security Audit Report
**Date:** 2026-01-13
**Auditor:** Claude Code Security Analysis
**Tech Stack:** Next.js 16.1.1, React 19.2.3, Go Fiber 2.52.10, PostgreSQL

---

## Executive Summary

| Severity | Count | Status |
|----------|-------|--------|
| CRITICAL | 4 | Requires immediate action |
| HIGH | 5 | Fix before production |
| MEDIUM | 4 | Should fix |
| LOW | 2 | Recommended improvements |

---

## 1. CVE Analysis - Framework Vulnerabilities

### 1.1 React CVE-2025-55182 (CVSS 10.0) - **PATCHED**
- **Status:** Your React 19.2.3 is SAFE (fixed in 19.2.1)
- **Issue:** Remote Code Execution in React Server Components
- **Impact:** Unauthenticated attackers could execute arbitrary code

### 1.2 Next.js CVE-2025-66478 - **ACTION REQUIRED**
- **Status:** Next.js 16.1.1 may be affected - upgrade to 16.0.10+
- **Issue:** Critical vulnerability in RSC protocol
- **Fix:** `npm install next@16.0.10` or latest patch

### 1.3 Go Fiber CVE-2025-54801 (CVSS 8.7) - **PATCHED**
- **Status:** Your Fiber v2.52.10 is SAFE (fixed in 2.52.9)
- **Issue:** BodyParser crash via large slice index
- **Impact:** Denial of Service

### 1.4 PostgreSQL CVE-2025-1094 (CVSS 8.1) - **CHECK VERSION**
- **Status:** Fixed in 17.3, 16.7, 15.11, 14.16, 13.19
- **Issue:** SQL injection via encoding manipulation
- **Action:** Verify PostgreSQL version: `psql --version`

---

## 2. Critical Code Vulnerabilities

### 2.1 CRITICAL: Hardcoded JWT Secret
**File:** `backend/internal/config/config.go:17`
```go
JWTSecret: getEnv("JWT_SECRET", "mdp-secret-key-change-in-production"),
```
**Risk:** JWT tokens can be forged with known secret
**Fix:** Remove default, require environment variable

### 2.2 CRITICAL: Insecure Cookie Configuration
**File:** `backend/internal/handlers/vocabulary.go:20`
```go
c.Cookie(&fiber.Cookie{
    Name:     "client_id",
    HTTPOnly: false,  // VULNERABLE - accessible to JavaScript
    SameSite: "Lax",
})
```
**Risk:** XSS attacks can steal session cookies
**Fix:** Set `HTTPOnly: true`, `Secure: true`, `SameSite: "Strict"`

### 2.3 CRITICAL: No Authorization Checks (IDOR)
**File:** `backend/internal/handlers/vocabulary_quiz.go`
**Issue:** User can modify any other user's vocabulary cards
```go
// Missing check: Does userID own this wordUUID?
response, err := h.repo.UpdateCardStatus(userID, req.WordUUID, req.Action)
```
**Risk:** Horizontal privilege escalation
**Fix:** Verify ownership before operations

### 2.4 CRITICAL: No Rate Limiting
**File:** `backend/cmd/api/main.go`
**Issue:** No protection against brute force or abuse
**Risk:** API abuse, XP farming, DoS
**Fix:** Add Fiber rate limiter middleware

---

## 3. High Severity Issues

### 3.1 Database Credentials in Code
**File:** `backend/internal/config/config.go:16`
```go
DatabaseURL: getEnv("DATABASE_URL", "postgres://postgres:postgres@localhost:5432/mdp?sslmode=disable"),
```
**Fix:** Remove default credentials, use secrets management

### 3.2 Error Message Information Disclosure
**File:** `backend/internal/handlers/handlers.go:31`
```go
return c.Status(500).JSON(fiber.Map{"error": err.Error()})
```
**Risk:** Exposes database schema and internal details
**Fix:** Return generic error messages, log details server-side

### 3.3 No CSRF Protection
**Issue:** POST/PUT/DELETE endpoints vulnerable to cross-site attacks
**Fix:** Implement CSRF tokens or use `SameSite: Strict` cookies

### 3.4 Missing Security Headers
**Missing headers:**
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY`
- `Strict-Transport-Security`
- `Content-Security-Policy`

### 3.5 Input Validation Gaps
**Issue:** UUID parameters not validated for format
```go
uuid := c.Params("uuid")  // Accepts any string
```
**Fix:** Validate UUID format with regex

---

## 4. Medium Severity Issues

### 4.1 CORS Configuration
**File:** `backend/cmd/api/main.go:56-61`
- Hardcoded localhost origins (OK for dev, not for prod)
- `AllowCredentials: true` with CORS needs careful handling

### 4.2 Integer Parameter Bounds
**Issue:** No minimum validation for `limit`, `offset`
- Allows `limit: 0` or `offset: -1`

### 4.3 Demo Mode with Null Database
**Issue:** API can run with nil database pointer, will crash

### 4.4 Dynamic SQL Placeholder Construction
**File:** `backend/internal/repository/repository.go:90`
```go
query += " AND year = $" + string(rune('0'+argNum))
```
**Issue:** Brittle pattern, fails for 10+ parameters

---

## 5. Positive Findings

| Area | Status |
|------|--------|
| SQL Injection Prevention | Parameterized queries used throughout |
| Password Hashing | Not applicable (no user passwords) |
| Input Type Validation | QueryInt used for numeric params |
| Quiz Type Validation | Whitelist validation implemented |
| Card Action Validation | Whitelist validation implemented |
| Logging | No sensitive data logged |

---

## 6. OWASP Top 10:2025 Mapping

| OWASP Category | Status | Issues Found |
|----------------|--------|--------------|
| A01: Broken Access Control | FAIL | No auth checks, IDOR vulnerabilities |
| A02: Security Misconfiguration | FAIL | Hardcoded secrets, missing headers |
| A03: Software Supply Chain | CHECK | Verify Next.js version |
| A04: Cryptographic Failures | WARN | sslmode=disable in DB |
| A05: Injection | PASS | Parameterized queries |
| A06: Insecure Design | FAIL | Cookie-based auth without validation |
| A07: Authentication Failures | FAIL | No proper authentication |
| A08: Integrity Failures | PASS | No signing issues found |
| A09: Logging Failures | WARN | No security event logging |
| A10: Exceptional Conditions | WARN | Error details exposed |

---

## 7. Immediate Action Checklist

### CRITICAL (Before Production)
- [ ] Update Next.js to patched version (16.0.10+)
- [ ] Verify PostgreSQL version is patched
- [ ] Set `HTTPOnly: true` on cookies
- [ ] Remove hardcoded JWT secret default
- [ ] Remove hardcoded database credentials
- [ ] Add rate limiting middleware

### HIGH (Within 1 Week)
- [ ] Add authorization checks for user data
- [ ] Implement CSRF protection
- [ ] Add security headers middleware
- [ ] Sanitize error messages
- [ ] Validate UUID format on inputs

### MEDIUM (Within 1 Month)
- [ ] Environment-based CORS configuration
- [ ] Input bounds validation
- [ ] Security event logging
- [ ] Database connection with SSL

---

## 8. Recommended Security Middleware

```go
// Add to main.go after imports
import "github.com/gofiber/fiber/v2/middleware/limiter"
import "github.com/gofiber/fiber/v2/middleware/helmet"

// Rate limiting
app.Use(limiter.New(limiter.Config{
    Max:        100,
    Expiration: 1 * time.Minute,
}))

// Security headers
app.Use(helmet.New())

// Fix cookie
c.Cookie(&fiber.Cookie{
    Name:     "client_id",
    Value:    clientID,
    MaxAge:   365 * 24 * 60 * 60,
    HTTPOnly: true,   // Changed
    Secure:   true,   // Added (for HTTPS)
    SameSite: "Strict", // Changed
})
```

---

## 9. References

- [CVE-2025-55182 - React RCE](https://react.dev/blog/2025/12/03/critical-security-vulnerability-in-react-server-components)
- [CVE-2025-66478 - Next.js RSC](https://nextjs.org/blog/CVE-2025-66478)
- [CVE-2025-54801 - Fiber BodyParser](https://nvd.nist.gov/vuln/detail/CVE-2025-54801)
- [CVE-2025-1094 - PostgreSQL SQL Injection](https://www.postgresql.org/support/security/CVE-2025-1094/)
- [OWASP Top 10:2025](https://owasp.org/Top10/2025/en/)
- [Go Fiber Security Best Practices](https://docs.gofiber.io/guide/security)

---

**Report Generated:** 2026-01-13
**Next Review:** Recommended after implementing fixes
