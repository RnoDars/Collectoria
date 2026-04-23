#!/bin/bash

# Analyse statique des requêtes SQL pour détecter les vulnérabilités d'injection
# Usage: ./analyze-sql-queries.sh

echo "=========================================="
echo "SQL Injection Static Analysis"
echo "=========================================="
echo ""

cd /home/arnaud.dars/git/Collectoria/backend/collection-management

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

POSTGRES_DIR="internal/infrastructure/postgres"

echo -e "${BLUE}Analyzing directory: ${POSTGRES_DIR}${NC}"
echo ""

# Pattern 1: String concatenation in SQL queries
echo "=========================================="
echo "Pattern 1: String Concatenation (High Risk)"
echo "=========================================="
echo "Searching for: query string + variables"
echo ""

CONCAT_FOUND=$(grep -rn "query.*+" "$POSTGRES_DIR" 2>/dev/null | grep -v "// " | grep -E "SELECT|INSERT|UPDATE|DELETE" || echo "")

if [ -z "$CONCAT_FOUND" ]; then
    echo -e "${GREEN}✓ No dangerous concatenations found${NC}"
else
    echo -e "${RED}✗ Potential concatenations found:${NC}"
    echo "$CONCAT_FOUND"
fi
echo ""

# Pattern 2: fmt.Sprintf in SQL queries
echo "=========================================="
echo "Pattern 2: fmt.Sprintf in Queries (High Risk)"
echo "=========================================="
echo "Searching for: fmt.Sprintf with SQL keywords"
echo ""

SPRINTF_FOUND=$(grep -rn "fmt.Sprintf" "$POSTGRES_DIR" 2>/dev/null | grep -E "SELECT|INSERT|UPDATE|DELETE" || echo "")

if [ -z "$SPRINTF_FOUND" ]; then
    echo -e "${GREEN}✓ No fmt.Sprintf in SQL queries${NC}"
else
    echo -e "${RED}✗ fmt.Sprintf found in queries:${NC}"
    echo "$SPRINTF_FOUND"
fi
echo ""

# Pattern 3: strings.Replace or string manipulation
echo "=========================================="
echo "Pattern 3: String Manipulation (Medium Risk)"
echo "=========================================="
echo "Searching for: strings.Replace, strings.Join in query context"
echo ""

STRING_MANIP=$(grep -rn "strings\." "$POSTGRES_DIR" 2>/dev/null | grep -v "// " | grep -E "query|Query|SELECT|INSERT" || echo "")

if [ -z "$STRING_MANIP" ]; then
    echo -e "${GREEN}✓ No string manipulation in queries${NC}"
else
    echo -e "${YELLOW}⚠ String manipulation detected (manual review needed):${NC}"
    echo "$STRING_MANIP"
fi
echo ""

# Pattern 4: Dynamic ORDER BY or LIMIT (common injection vector)
echo "=========================================="
echo "Pattern 4: Dynamic ORDER BY / LIMIT (Medium Risk)"
echo "=========================================="
echo "Searching for: ORDER BY with variables"
echo ""

ORDER_BY=$(grep -rn "ORDER BY" "$POSTGRES_DIR" 2>/dev/null | grep -v "?" | grep -v "ORDER BY id\|ORDER BY created_at\|ORDER BY name" || echo "")

if [ -z "$ORDER_BY" ]; then
    echo -e "${GREEN}✓ All ORDER BY clauses appear safe${NC}"
else
    echo -e "${YELLOW}⚠ Dynamic ORDER BY detected (manual review needed):${NC}"
    echo "$ORDER_BY"
fi
echo ""

# Pattern 5: List all database calls (for manual review)
echo "=========================================="
echo "Pattern 5: All Database Calls (Manual Review)"
echo "=========================================="
echo "Listing all db.Query, db.Exec, db.Get, db.Select calls"
echo ""

echo -e "${BLUE}Total database calls:${NC}"
DB_CALLS=$(grep -rn "db\.\(Query\|QueryRow\|Exec\|Get\|Select\)" "$POSTGRES_DIR" 2>/dev/null | wc -l)
echo "  $DB_CALLS calls found"
echo ""

echo -e "${BLUE}Sample database calls (first 30):${NC}"
grep -rn "db\.\(Query\|QueryRow\|Exec\|Get\|Select\)" "$POSTGRES_DIR" 2>/dev/null | head -30
echo ""
echo "(Run full manual review for complete list)"
echo ""

# Pattern 6: Check for parameterized queries (good practice)
echo "=========================================="
echo "Pattern 6: Parameterized Queries (Good Practice)"
echo "=========================================="
echo "Searching for: queries with ? placeholders"
echo ""

PARAM_QUERIES=$(grep -rn "?" "$POSTGRES_DIR" 2>/dev/null | grep -E "SELECT|INSERT|UPDATE|DELETE" | wc -l)
TOTAL_QUERIES=$(grep -rn -E "SELECT|INSERT|UPDATE|DELETE" "$POSTGRES_DIR" 2>/dev/null | grep "query" | wc -l)

echo -e "${BLUE}Queries with ? placeholders: ${PARAM_QUERIES}${NC}"
echo -e "${BLUE}Total queries found: ${TOTAL_QUERIES}${NC}"

if [ "$PARAM_QUERIES" -gt 0 ]; then
    echo -e "${GREEN}✓ Parameterized queries detected (good practice)${NC}"
fi
echo ""

# Summary
echo "=========================================="
echo "Summary"
echo "=========================================="
echo ""

ISSUES=0

if [ -n "$CONCAT_FOUND" ]; then
    echo -e "${RED}✗ String concatenation detected - HIGH RISK${NC}"
    ((ISSUES++))
fi

if [ -n "$SPRINTF_FOUND" ]; then
    echo -e "${RED}✗ fmt.Sprintf in queries - HIGH RISK${NC}"
    ((ISSUES++))
fi

if [ -n "$STRING_MANIP" ]; then
    echo -e "${YELLOW}⚠ String manipulation - MANUAL REVIEW NEEDED${NC}"
fi

if [ -n "$ORDER_BY" ]; then
    echo -e "${YELLOW}⚠ Dynamic ORDER BY - MANUAL REVIEW NEEDED${NC}"
fi

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ No high-risk patterns detected${NC}"
    echo -e "${GREEN}✓ Code appears to use parameterized queries${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Perform manual line-by-line review of all repositories"
    echo "  2. Create automated SQL injection tests"
    echo "  3. Test all endpoints with injection payloads"
else
    echo -e "${RED}✗ ${ISSUES} high-risk pattern(s) detected${NC}"
    echo ""
    echo "Action required:"
    echo "  1. Review and fix all flagged lines"
    echo "  2. Refactor to use parameterized queries"
    echo "  3. Re-run this analysis after fixes"
fi

echo ""
echo "=========================================="
echo "Analysis Complete"
echo "=========================================="
echo ""
echo "Analyzed files:"
find "$POSTGRES_DIR" -name "*.go" -type f
echo ""
echo "For detailed manual review, check:"
echo "  Security/audit-logs/2026-04-23_sql-injection-audit.md"
