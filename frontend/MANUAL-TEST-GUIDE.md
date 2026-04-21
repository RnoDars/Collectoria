# Manual Testing Guide - Card Possession Toggle

## Prerequisites

- Backend server running on `http://localhost:8080`
- Database populated with MECCG cards
- Frontend dependencies installed (`npm install`)

## Test Environment Setup

### 1. Start Backend (Terminal 1)

```bash
cd backend/collections-service
go run cmd/server/main.go
```

Expected output:
```
Server starting on :8080
Database connected
```

### 2. Start Frontend (Terminal 2)

```bash
cd frontend
npm run dev
```

Expected output:
```
▲ Next.js 15.5.15
- Local:        http://localhost:3000
- ready in X ms
```

## Test Scenarios

### Scenario 1: Navigation to Card Management Page

1. Open browser: `http://localhost:3000`
2. Verify homepage loads with HeroCard showing collection progress
3. Click "Add Card" button in HeroCard
4. **Expected**: URL changes to `http://localhost:3000/cards/add`
5. **Expected**: Page shows "Gérer ma Collection" heading

**Pass Criteria:**
- ✅ Navigation works
- ✅ Page loads without errors
- ✅ Back link "← Retour au dashboard" is visible

---

### Scenario 2: Card List Display

1. On `/cards/add` page
2. Wait for cards to load
3. **Expected**: Grid of cards appears
4. **Expected**: Each card shows:
   - Name (FR/EN)
   - Type
   - Series
   - Rarity badge
   - Toggle switch
   - Status label ("Possédée" or "Non possédée")

**Pass Criteria:**
- ✅ Cards display in responsive grid
- ✅ Toggle switches are visible
- ✅ Status labels match toggle state (green for owned, gray for not owned)

---

### Scenario 3: Search Filter

1. In search input, type: `Gandalf`
2. Wait 300ms (debounce)
3. **Expected**: Only cards with "Gandalf" in name appear
4. Clear search input
5. **Expected**: All cards reappear

**Pass Criteria:**
- ✅ Search filters cards correctly
- ✅ Debounce works (no API call on every keystroke)
- ✅ Clear search restores full list

---

### Scenario 4: Dropdown Filters

**Series Filter:**
1. Select "Les Sorciers" from series dropdown
2. **Expected**: Only cards from "Les Sorciers" series appear

**Type Filter:**
1. Select "Héros / Personnage" from type dropdown
2. **Expected**: Only character cards appear

**Rarity Filter:**
1. Select "Rare" from rarity dropdown
2. **Expected**: Only rare cards appear

**Clear Filters:**
1. Reset all dropdowns to default
2. **Expected**: Full card list restored

**Pass Criteria:**
- ✅ Each filter works independently
- ✅ Filters combine correctly (AND logic)
- ✅ Card count updates in header

---

### Scenario 5: Ownership Status Filter

1. Click "Toutes" button (default)
2. **Expected**: All cards shown
3. Click "Possédées" button
4. **Expected**: Only owned cards shown
5. Click "Non possédées" button
6. **Expected**: Only non-owned cards shown
7. Click "Toutes" button
8. **Expected**: All cards shown again

**Pass Criteria:**
- ✅ Toggle buttons highlight active filter
- ✅ Card list updates correctly
- ✅ Card count updates

---

### Scenario 6: Toggle Card to Owned

1. Find a card with "Non possédée" status
2. Click its toggle switch (should be gray)
3. **Expected**: 
   - Toggle animates to "on" position (green gradient)
   - Toast notification appears: "Carte ajoutée à votre collection !" with ✓ icon
   - Status label changes to "Possédée"
   - Toggle becomes disabled during API call
4. Wait for toast to disappear (3 seconds)

**Pass Criteria:**
- ✅ Toggle animation smooth
- ✅ Toast appears bottom-right
- ✅ Card status updates immediately after API response
- ✅ Loading state visible during API call

---

### Scenario 7: Toggle Card to Not Owned

1. Find a card with "Possédée" status (green toggle)
2. Click its toggle switch
3. **Expected**:
   - Toggle animates to "off" position (gray)
   - Toast notification appears: "Carte retirée de votre collection" with ✗ icon
   - Status label changes to "Non possédée"
4. Wait for toast to disappear

**Pass Criteria:**
- ✅ Toggle animation smooth
- ✅ Toast appears with correct message
- ✅ Card status updates correctly

---

### Scenario 8: Homepage Progress Update

1. On `/cards/add`, toggle a card to owned
2. Click "← Retour au dashboard" link
3. **Expected**: 
   - Navigate back to homepage
   - HeroCard progress percentage increased
   - "X cards owned" number increased by 1

**Pass Criteria:**
- ✅ Progress updates automatically
- ✅ Numbers are accurate
- ✅ Progress bar animates to new value

---

### Scenario 9: Data Persistence

1. Toggle a card to owned
2. Refresh page (F5)
3. **Expected**: Card still shows as owned
4. Navigate to homepage and back
5. **Expected**: Card still shows as owned

**Pass Criteria:**
- ✅ State persists across page reloads
- ✅ State persists across navigation

---

### Scenario 10: Infinite Scroll

1. On `/cards/add` with default filters
2. Scroll down to bottom of page
3. **Expected**: 
   - "Loading..." skeletons appear
   - Next page of cards loads automatically
   - Scroll continues smoothly
4. Continue scrolling until all cards loaded
5. **Expected**: Message "Toutes les cartes sont affichées."

**Pass Criteria:**
- ✅ Infinite scroll triggers automatically
- ✅ No duplicate cards appear
- ✅ End of list message appears

---

### Scenario 11: Error Handling

**Simulate Network Error:**
1. Stop backend server
2. Try to toggle a card
3. **Expected**:
   - Error toast appears: "Erreur lors de la mise à jour de la carte"
   - Card status does NOT change
   - Toggle returns to previous position

**Restart Backend:**
4. Restart backend server
5. Try toggle again
6. **Expected**: Works normally

**Pass Criteria:**
- ✅ Error toast appears
- ✅ UI doesn't break
- ✅ User can retry after backend restart

---

### Scenario 12: Loading States

1. Clear browser cache
2. Navigate to `/cards/add`
3. **Expected**: 
   - Skeleton cards appear while loading
   - Filters bar visible but populated after load
   - Smooth transition from skeleton to real cards

**Pass Criteria:**
- ✅ Skeletons match card layout
- ✅ No layout shift during load
- ✅ Smooth transition

---

### Scenario 13: Empty State

1. Apply filters that match no cards (e.g., search "ZZZZZZ")
2. **Expected**:
   - Message: "Aucune carte trouvée"
   - Sub-message: "Essayez de modifier vos filtres."
   - No cards displayed

**Pass Criteria:**
- ✅ Empty state message centered
- ✅ Clear instructions for user
- ✅ Filters still functional

---

### Scenario 14: Responsive Design

**Desktop (>1200px):**
- Grid: 4 columns
- Filters: Single row

**Tablet (768-1200px):**
- Grid: 3 columns
- Filters: May wrap

**Mobile (<768px):**
- Grid: 1-2 columns
- Filters: Stacked vertically

**Test:**
1. Resize browser window
2. Test all breakpoints
3. **Expected**: Layout adapts smoothly

**Pass Criteria:**
- ✅ No horizontal scroll at any size
- ✅ All elements readable and clickable
- ✅ Toggle switches remain functional

---

### Scenario 15: Accessibility

**Keyboard Navigation:**
1. Use Tab key to navigate
2. **Expected**: Can reach all interactive elements
3. Press Enter on toggle switch
4. **Expected**: Toggle activates

**Screen Reader:**
1. Use screen reader (e.g., NVDA, JAWS)
2. Navigate to toggle switch
3. **Expected**: Announces role and state
4. Example: "Ajouter à la collection, switch, not pressed"

**Pass Criteria:**
- ✅ All interactive elements keyboard accessible
- ✅ Focus indicators visible
- ✅ ARIA labels correct

---

## Performance Checks

### Bundle Size
```bash
npm run build
```

**Expected:**
- `/cards/add` route: ~126 kB First Load JS
- No warnings about large bundles

### Test Coverage
```bash
npm test
```

**Expected:**
- 60/60 tests passing
- useCardToggle: 5/5 tests
- /cards/add page: 12/12 tests

---

## Browser Compatibility

Test on:
- ✅ Chrome (latest)
- ✅ Firefox (latest)
- ✅ Safari (latest)
- ✅ Edge (latest)

---

## Network Conditions

Test under:
- ✅ Fast 3G
- ✅ Slow 3G
- ✅ Offline (error handling)

Chrome DevTools → Network tab → Throttling dropdown

---

## Sign-off

After completing all scenarios:

- [ ] All 15 scenarios pass
- [ ] No console errors
- [ ] No TypeScript errors
- [ ] Tests passing (60/60)
- [ ] Build successful
- [ ] Documentation reviewed

**Tester Name:** ___________________  
**Date:** ___________________  
**Environment:** Development / Staging / Production  
**Result:** ✅ PASS / ❌ FAIL  

**Notes:**
_____________________________________________________________________
_____________________________________________________________________
_____________________________________________________________________
